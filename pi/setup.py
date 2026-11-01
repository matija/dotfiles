#!/usr/bin/env python3
import argparse
import shutil
from datetime import datetime
from pathlib import Path

parser = argparse.ArgumentParser(description="Link Pi configuration to this dotfiles checkout.")
parser.add_argument("--home", type=Path, default=Path.home())
args = parser.parse_args()
home = args.home.expanduser().resolve()
repo = Path(__file__).resolve().parent.parent
agent = home / ".pi/agent"
shared = home / ".agents"
backup = home / ".pi/backups" / datetime.now().strftime("%Y%m%d-%H%M%S-%f")

links = {
    shared / "AGENTS.md": repo / "agents/AGENTS.md",
    shared / "skills": repo / "agents/skills",
    agent / "AGENTS.md": shared / "AGENTS.md",
    agent / "skills": shared / "skills",
    agent / "settings.json": repo / "pi/settings.json",
    agent / "themes": repo / "pi/themes",
    agent / "extensions": repo / "pi/extensions",
}
if (shared / "mcp.json").exists() or (agent / "mcp.json").exists():
    shared.mkdir(parents=True, exist_ok=True)
    if not (shared / "mcp.json").exists():
        shutil.copy2(agent / "mcp.json", shared / "mcp.json")
        (shared / "mcp.json").chmod(0o600)
    links[agent / "mcp.json"] = shared / "mcp.json"

for target, source in links.items():
    if target.is_symlink() and target.readlink() == source:
        print(f"unchanged: {target}")
        continue
    if target.exists() or target.is_symlink():
        saved = backup / target.relative_to(home)
        saved.parent.mkdir(parents=True, exist_ok=True)
        target.rename(saved)
        print(f"backup: {saved}")
    target.parent.mkdir(parents=True, exist_ok=True)
    target.symlink_to(source, target_is_directory=source.is_dir())
    print(f"link: {target} -> {source}")
