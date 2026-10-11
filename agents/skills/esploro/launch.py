import argparse
import json
import os
import subprocess
import tempfile
from pathlib import Path

parser = argparse.ArgumentParser()
parser.add_argument("harness", choices=["pi", "codex", "claude"])
args, extra = parser.parse_known_args()
if extra[:1] == ["--"]:
    extra = extra[1:]
server = json.loads((Path.home() / ".agents/mcp.json").read_text())["mcpServers"]["esploro"]
env = os.environ.copy()
if args.harness == "pi":
    env["ESPLORO_SESSION"] = "1"
    command = ["pi"]
elif args.harness == "codex":
    authorization = server.get("headers", {}).get("Authorization", "")
    if not authorization.startswith("Bearer "):
        parser.error("Codex launcher requires a Bearer Authorization header")
    env["ESPLORO_MCP_TOKEN"] = authorization.removeprefix("Bearer ")
    command = ["codex", "-c", "mcp_servers.esploro.url=" + json.dumps(server["url"]), "-c", "mcp_servers.esploro.enabled=true", "-c", 'mcp_servers.esploro.bearer_token_env_var="ESPLORO_MCP_TOKEN"']
else:
    with tempfile.NamedTemporaryFile(mode="w", suffix=".json") as config:
        json.dump({"mcpServers": {"esploro": {"type": "http", "url": server["url"], "headers": server.get("headers", {})}}}, config)
        config.flush()
        raise SystemExit(subprocess.call(["claude", "--mcp-config", config.name, *extra], env=env))
raise SystemExit(subprocess.call([*command, *extra], env=env))
