#!/usr/bin/env node
import { createHash } from "node:crypto";
import { execFileSync } from "node:child_process";
import { existsSync, mkdirSync, readFileSync, writeFileSync, unlinkSync, rmdirSync, statSync, openSync, readSync, closeSync } from "node:fs";
import { homedir } from "node:os";
import { join } from "node:path";
import { pathToFileURL } from "node:url";
import { setTimeout as delay } from "node:timers/promises";
import { reviewTranscript } from "../../pi/extensions/you-should-know/review.ts";

const home = process.env.CODEX_HOME || join(homedir(), ".codex");
const disabled = join(home, "jev-disabled");
const settings = JSON.parse(readFileSync(new URL("./settings.json", import.meta.url), "utf8"));
const clean = (value) => value.replace(/[\u0000-\u001f\u007f-\u009f]/g, " ").trim();
const hash = (value) => createHash("sha256").update(value).digest("hex");
const enabled = () => settings.enabled && !existsSync(disabled);
const emit = (output = {}) => console.log(JSON.stringify(output));
const warning = (title, message) => `⚠ JEV — ${title}\n\n${clean(message)}`;

function text(value) {
  if (typeof value === "string") {
    try { return text(JSON.parse(value)); } catch { return value; }
  }
  if (Array.isArray(value)) return value.map(text).filter(Boolean).join("\n");
  if (!value || typeof value !== "object" || /image|reasoning|thinking/.test(value.type || "")) return "";
  return [value.text, value.output, value.content, value.result].map(text).filter(Boolean).join("\n");
}

function transcript(input) {
  const lines = [];
  if (input.transcript_path) {
    const fd = openSync(input.transcript_path, "r");
    try {
      const size = statSync(input.transcript_path).size;
      const start = Math.max(0, size - 2_000_000);
      const buffer = Buffer.alloc(size - start);
      readSync(fd, buffer, 0, buffer.length, start);
      const records = buffer.toString("utf8").split("\n");
      if (start) records.shift();
      for (const line of records) {
        let entry;
        try { entry = JSON.parse(line); } catch { continue; }
        if (entry.type !== "response_item") continue;
        const item = entry.payload;
        if (item?.type === "message" && item.channel !== "analysis" && ["user", "assistant"].includes(item.role)) {
          const content = text(item.content);
          if (content) lines.push(`${item.role}: ${content}`);
        } else if (["function_call", "custom_tool_call"].includes(item?.type)) {
          lines.push(`toolCall ${item.name}: ${item.arguments ?? item.input ?? ""}`);
        } else if (["function_call_output", "custom_tool_call_output"].includes(item?.type)) {
          lines.push(`toolResult: ${text(item.output)}`);
        }
      }
    } finally { closeSync(fd); }
  }
  if (input.hook_event_name === "PostToolUse") {
    lines.push(`toolCall ${input.tool_name}: ${JSON.stringify(input.tool_input)}`);
    lines.push(`toolResult: ${text(input.tool_response)}`);
  }
  const last = input.last_assistant_message;
  if (last && lines.at(-1) !== `assistant: ${last}`) lines.push(`assistant: ${last}`);
  const source = lines.join("\n\n").trim().slice(-24_000);
  if (!source) throw new Error("No readable Codex transcript is available.");
  return source;
}

async function registry(signal) {
  const agent = join(homedir(), ".pi/agent");
  if (!process.env.TYPESAFE_API_KEY) {
    const auth = JSON.parse(readFileSync(join(agent, "auth.json"), "utf8"));
    if (auth.typesafe?.type === "api_key") process.env.TYPESAFE_API_KEY = auth.typesafe.key;
  }
  let root = process.env.PI_PACKAGE_DIR;
  if (!root) {
    const versionFile = join(agent, "install/current-version");
    if (existsSync(versionFile)) {
      const version = readFileSync(versionFile, "utf8").trim();
      if (!/^[a-zA-Z0-9._+-]+$/.test(version)) throw new Error("The installed Pi version is invalid.");
      root = join(agent, "install/releases", version, "node_modules/@earendil-works/pi-coding-agent");
    } else {
      root = join(execFileSync("npm", ["root", "-g"], { encoding: "utf8", timeout: 5000 }).trim(), "@earendil-works/pi-coding-agent");
    }
  }
  const { ModelRuntime, ModelRegistry } = await import(pathToFileURL(join(root, "dist/index.js")).href);
  const runtime = await ModelRuntime.create({ authPath: join(agent, "auth.json"), allowModelNetwork: false, signal });
  return new ModelRegistry(runtime);
}

async function review(source, previous, signal) {
  const modelRegistry = await registry(signal);
  const usage = [];
  const result = await reviewTranscript({ modelRegistry }, source, previous, settings.threshold, signal,
    (record) => usage.push(record), () => {});
  return { ...result, usage };
}

async function acquire(lock, final) {
  const deadline = Date.now() + 45_000;
  while (enabled()) {
    try {
      mkdirSync(lock, { mode: 0o700 });
      writeFileSync(join(lock, "pid"), String(process.pid), { mode: 0o600 });
      return true;
    } catch (error) {
      if (error.code !== "EEXIST") throw error;
      let stale;
      try { stale = Date.now() - statSync(lock).mtimeMs > 100_000; }
      catch (error) { if (error.code === "ENOENT") continue; throw error; }
      try {
        const pid = Number(readFileSync(join(lock, "pid"), "utf8"));
        if (pid > 0) process.kill(pid, 0);
      } catch (error) { if (error.code === "ESRCH") stale = true; }
      if (stale) {
        try { unlinkSync(join(lock, "pid")); } catch (error) { if (error.code !== "ENOENT") throw error; }
        try { rmdirSync(lock); } catch (error) { if (error.code !== "ENOENT") throw error; }
        continue;
      }
      if (!final) return false;
      if (Date.now() >= deadline) throw new Error("The previous Jev review did not finish.");
      await delay(100);
    }
  }
  return false;
}

async function hook(input) {
  if (!enabled() || !["PostToolUse", "Stop"].includes(input.hook_event_name)) return emit();
  if (!input.session_id) throw new Error("The Codex session ID is missing.");
  const dir = join(home, "state/jev");
  mkdirSync(dir, { recursive: true, mode: 0o700 });
  const statePath = join(dir, `${hash(input.session_id)}.json`);
  const lock = `${statePath}.lock`;
  const final = input.hook_event_name === "Stop";
  if (!await acquire(lock, final)) return emit();
  try {
    let state = {};
    if (existsSync(statePath)) state = JSON.parse(readFileSync(statePath, "utf8"));
    if (!final && Date.now() - (state.started || 0) < settings.intervalSeconds * 1000) return emit();
    const source = transcript(input), fingerprint = hash(source);
    if (fingerprint === state.fingerprint) return emit();
    state.started = Date.now();
    writeFileSync(statePath, JSON.stringify(state), { mode: 0o600 });
    const result = await review(source, state.previous || "", AbortSignal.timeout(40_000));
    const note = result.note && result.note !== state.previous ? result.note : "";
    state = { started: state.started, fingerprint, previous: note || state.previous || "",
      probability: result.decision.probability, category: result.decision.category, usage: result.usage };
    if (!enabled()) return emit();
    writeFileSync(statePath, JSON.stringify(state), { mode: 0o600 });
    const output = note ? { systemMessage: warning("REVIEW REQUIRED", note) } : {};
    // if (final && note && !input.stop_hook_active) {
    //   output.decision = "block";
    //   output.reason = note;
    // }
    emit(output);
  } finally {
    unlinkSync(join(lock, "pid"));
    rmdirSync(lock);
  }
}

async function main() {
  const action = process.argv[2];
  if (["on", "off", "status"].includes(action)) {
    if (action === "off") {
      mkdirSync(home, { recursive: true });
      writeFileSync(disabled, "", { mode: 0o600 });
    }
    if (action === "on" && existsSync(disabled)) unlinkSync(disabled);
    console.log(`Codex Jev alerts: ${enabled() ? "on" : "off"}`);
    return;
  }
  if (action === "test") {
    const { TEST_TRANSCRIPT } = await import("../../pi/extensions/you-should-know/test-scenario.ts");
    const result = await review(TEST_TRANSCRIPT, "", AbortSignal.timeout(40_000));
    if (!result.note) throw new Error("The live self-test did not produce a warning.");
    emit({ systemMessage: warning("SELF-TEST WARNING", result.note), probability: result.decision.probability });
    return;
  }
  if (action) throw new Error("Use codex-jev on, off, status, or test.");
  await hook(JSON.parse(readFileSync(0, "utf8")));
}

main().catch((error) => {
  const detail = /^(TYPESAFE_API_KEY|Jev HTTP|Jev returned|openai-codex\/gpt-6-luna|Luna failed|No readable Codex|The Codex session|The previous Jev|The live self-test|Use codex-jev)/.test(error.message || "")
    ? ` ${clean(error.message)}` : " Check Pi credentials, Node.js 24, and provider connectivity.";
  emit({ systemMessage: warning("REVIEW UNAVAILABLE", `No verification result was produced.${detail}`) });
  if (process.argv[2]) process.exitCode = 1;
});
