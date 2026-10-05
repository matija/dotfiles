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
  for (const name of ["ysk", "ysk-chat", "ysk-dismiss", "ysk-inject"]) assert.ok(commands.has(name));
  assert.ok(!events.has("context"));
  assert.ok(!events.has("before_agent_start"));
});
