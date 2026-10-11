import { readFileSync } from "node:fs";
import { homedir } from "node:os";
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

export default function (pi: ExtensionAPI) {
  const connect = () => {
    const { mcpServers } = JSON.parse(readFileSync(`${homedir()}/.agents/mcp.json`, "utf8"));
    pi.registerMcpServer("esploro-session", { ...mcpServers.esploro, enabled: true });
  };
  if (process.env.ESPLORO_SESSION === "1") connect();
  pi.registerCommand("esploro-connect", {
    description: "Connect native Esploro MCP for this session only",
    handler: async (_args, ctx) => {
      connect();
      ctx.ui.notify("Esploro connecting for this session. Check /mcp.", "info");
    },
  });
  pi.registerCommand("esploro-disconnect", {
    description: "Disconnect this session's Esploro MCP",
    handler: async (_args, ctx) => {
      pi.unregisterMcpServer("esploro-session");
      ctx.ui.notify("Esploro disconnected.", "info");
    },
  });
}
