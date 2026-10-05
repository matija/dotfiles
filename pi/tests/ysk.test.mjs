import assert from "node:assert/strict";
import { execFileSync } from "node:child_process";
import { createRequire } from "node:module";
import { test } from "node:test";

const root = process.env.PI_PACKAGE_DIR || `${execFileSync("npm", ["root", "-g"], { encoding: "utf8" }).trim()}/@earendil-works/pi-coding-agent`;
const require = createRequire(`${root}/package.json`);
const { createJiti } = require("jiti");
const jiti = createJiti(import.meta.url, { alias: {
  "@earendil-works/pi-coding-agent": `${root}/dist/index.js`,
  "@earendil-works/pi-tui": `${root}/node_modules/@earendil-works/pi-tui/dist/index.js`,
} });
const { reviewTranscript } = await jiti.import("../extensions/you-should-know/review.ts");
const { UsageLedger, usageRecord } = await jiti.import("../extensions/you-should-know/usage.ts");
const { transcript } = await jiti.import("../extensions/you-should-know/transcript.ts");
const observer = (await jiti.import("../extensions/you-should-know/index.ts")).default;
const response = (probability) => ({ ok: true, json: async () => ({ model: "jev-1.13.0", usage: { input_tokens: 100 }, answers: {
  interrupt: { type: "choice", choice: probability > 0.5 ? "warn" : "quiet", confidence: 1, probabilities: { warn: probability, quiet: 1 - probability } },
  category: { type: "choice", choice: "verification", confidence: 1, probabilities: { verification: 1, data_loss: 0, security: 0, none: 0 } },
} }) });

test("observer uses subscription Luna only after the Jev gate", async () => {
  const originalFetch = globalThis.fetch, originalKey = process.env.TYPESAFE_API_KEY;
  process.env.TYPESAFE_API_KEY = "test-only";
  let probability = 0, calls = 0;
  globalThis.fetch = async (_url, options) => { assert.equal(options.redirect, "error"); return response(probability); };
  const ctx = { modelRegistry: {
    find: (provider, id) => { assert.equal(provider, "openai-codex"); assert.equal(id, "gpt-6-luna"); return { provider, id }; },
    streamSimple: (_model, context, options) => {
      calls++; assert.equal(context.tools, undefined); assert.equal(options.maxRetries, 0);
      return { result: async () => ({ stopReason: "stop", content: [{ type: "text", text: "The tests failed." }], usage: { input: 10, output: 5 } }) };
    },
  } };
  try {
    const run = () => reviewTranscript(ctx, "tests failed", "", 0.85, new AbortController().signal, () => {}, () => {});
    assert.equal((await run()).note, ""); assert.equal(calls, 0);
    probability = 0.99;
    assert.equal((await run()).note, "The tests failed."); assert.equal(calls, 1);
  } finally {
    globalThis.fetch = originalFetch;
    if (originalKey === undefined) delete process.env.TYPESAFE_API_KEY; else process.env.TYPESAFE_API_KEY = originalKey;
  }
});

test("footer identifies subscription usage instead of API billing", () => {
  const ledger = new UsageLedger();
  ledger.add(usageRecord("jev", { input_tokens: 1000 }));
  ledger.add(usageRecord("luna", { input: 100, output: 10, cost: { total: 4 } }));
  assert.equal(ledger.footer(), "YSK Jev ~$0.001 (1) Luna subscription (1)");
});

test("snapshot excludes thinking and images and remains bounded", () => {
  const ctx = { sessionManager: { getBranch: () => [{ type: "message", message: { role: "assistant", content: [
    { type: "thinking", thinking: "private" }, { type: "image", data: "image" }, { type: "text", text: "a".repeat(30000) },
  ] } }] } };
  assert.equal(transcript(ctx), "a".repeat(24000));
});

test("registers local commands without context injection", () => {
  const commands = new Map(), events = new Map();
  observer({ registerCommand: (name, command) => commands.set(name, command), on: (name, handler) => events.set(name, handler) });
  for (const name of ["ysk", "ysk-test", "ysk-chat", "ysk-dismiss", "ysk-inject"]) assert.ok(commands.has(name));
  assert.ok(!events.has("context"));
  assert.ok(!events.has("before_agent_start"));
});

test("live-test command uses the real review path and renders repeatable warnings", async () => {
  const originalFetch = globalThis.fetch, originalKey = process.env.TYPESAFE_API_KEY;
  process.env.TYPESAFE_API_KEY = "test-only";
  const commands = new Map(), entries = [], widgets = new Map(), notices = [];
  let calls = 0;
  globalThis.fetch = async (_url, options) => {
    const state = JSON.parse(options.body).state;
    assert.match(state, /Previous YSK note: none/);
    assert.match(state, /Tests: 1 failed, 0 passed/);
    assert.match(state, /All tests passed/);
    assert.ok(!state.includes("main-context-secret"));
    return response(0.99);
  };
  observer({ registerCommand: (name, command) => commands.set(name, command), on: () => {}, appendEntry: (type, data) => entries.push({ type, data }) });
  const ctx = {
    mode: "tui", isIdle: () => true,
    sessionManager: { getBranch: () => { throw new Error("Test must not read main-context-secret"); } },
    ui: { notify: (text) => notices.push(text), setWidget: (key, widget) => widgets.set(key, widget) },
    modelRegistry: {
      find: (provider, id) => { assert.equal(provider, "openai-codex"); return { provider, id }; },
      streamSimple: () => { calls++; return { result: async () => ({ stopReason: "stop", content: [{ type: "text", text: "The tests failed, but the assistant claimed they passed." }], usage: { input: 10, output: 5 } }) }; },
    },
  };
  try {
    await commands.get("ysk").handler("1", ctx);
    for (let i = 0; i < 2; i++) await commands.get("ysk-test").handler("", ctx);
    assert.equal(calls, 2);
    assert.ok(notices.some((text) => text.includes("Jev P(warn)=0.990, threshold=0.85")));
    assert.equal(entries.filter((entry) => entry.type === "you-should-know-review").length, 2);
    assert.ok(entries.filter((entry) => entry.type === "you-should-know-review").every((entry) => entry.data.test && entry.data.threshold === 0.85));
    const theme = { fg: (_color, text) => text, bold: (text) => text };
    const rendered = widgets.get("you-should-know")({}, theme).render(100).join("\n");
    assert.match(rendered, /YSK:.*tests failed/);
    await commands.get("ysk").handler("off", ctx);
    const before = calls;
    await commands.get("ysk-test").handler("", ctx);
    assert.equal(calls, before);
    assert.match(notices.at(-1), /Run \/ysk on/);
  } finally {
    globalThis.fetch = originalFetch;
    if (originalKey === undefined) delete process.env.TYPESAFE_API_KEY; else process.env.TYPESAFE_API_KEY = originalKey;
  }
});
