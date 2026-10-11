import argparse
import json
import re
from pathlib import Path

parser = argparse.ArgumentParser()
parser.add_argument("harness", choices=["pi", "codex", "cursor", "claude"])
parser.add_argument("action", choices=["enable", "disable"])
args = parser.parse_args()
home = Path.home()
source = home / ".agents/mcp.json"
shared = json.loads(source.read_text())
server = shared["mcpServers"]["esploro"]
enabled = args.action == "enable"


def save_json(path, data):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(data, indent=2) + "\n")
    path.chmod(0o600)


if args.harness == "pi":
    path = home / ".pi/agent/mcp.json"
    data = json.loads(path.read_text()) if path.exists() else {"mcpServers": {}}
    data.setdefault("mcpServers", {})["esploro"] = {**server, "enabled": enabled}
    save_json(path, data)
elif args.harness == "codex":
    path = home / ".codex/config.toml"
    text = path.read_text() if path.exists() else ""
    text = re.sub(r"(?ms)^\[mcp_servers\.esploro(?:\.[^\]]+)?\]\n.*?(?=^\[|\Z)", "", text)
    section = "\n[mcp_servers.esploro]\n"
    section += "url = " + json.dumps(server["url"]) + "\n"
    section += "enabled = " + str(enabled).lower() + "\n"
    section += 'bearer_token_env_var = "ESPLORO_MCP_TOKEN"\n'
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(text.rstrip() + "\n" + section)
    path.chmod(0o600)
else:
    path = home / (".cursor/mcp.json" if args.harness == "cursor" else ".claude.json")
    data = json.loads(path.read_text()) if path.exists() else {}
    servers = data.setdefault("mcpServers", {})
    if enabled:
        servers["esploro"] = {"type": "http", "url": server["url"], "headers": server.get("headers", {})}
    else:
        servers.pop("esploro", None)
    save_json(path, data)

print(f"Esploro native MCP {args.action}d for {args.harness}.")
print("Pi: run /reload, then check /mcp. Other harnesses: reload MCP if available, otherwise start a new session; Cursor may require approval or enabling in MCP settings.")
