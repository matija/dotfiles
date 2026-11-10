#!/usr/bin/env python3
import argparse
import json
import shutil
from datetime import datetime
from pathlib import Path

parser = argparse.ArgumentParser(description="Install Codex Jev alerts from this checkout.")
parser.add_argument("--home", type=Path, default=Path.home())
args = parser.parse_args()
home = args.home.expanduser().resolve()
repo = Path(__file__).resolve().parent.parent
codex = home / ".codex"
codex.mkdir(parents=True, exist_ok=True)
backup = codex / "backups" / datetime.now().strftime("%Y%m%d-%H%M%S-%f")
command = 'node "$HOME/.codex/jev/observer.mjs"'
hooks_path = codex / "hooks.json"
config = json.loads(hooks_path.read_text()) if hooks_path.exists() else {}
hooks = config.setdefault("hooks", {})
for event, asynchronous, timeout in (("PostToolUse", True, 45), ("Stop", False, 90)):
    groups = hooks.setdefault(event, [])
    retained = []
    for group in groups:
        original = group.get("hooks", [])
        remaining = [item for item in original if item.get("command") != command]
        if remaining or not original:
            retained.append({**group, "hooks": remaining})
    groups[:] = retained
    handler = {"type": "command", "command": command, "timeout": timeout,
               "statusMessage": "Checking for consequential mistakes with Jev"}
    if asynchronous:
        handler["async"] = True
    groups.append({"hooks": [handler]})

for target, source in ((codex / "jev", repo / "codex/jev"),
                       (home / ".local/bin/codex-jev", repo / "codex/jev/observer.mjs")):
    if target.is_symlink() and target.resolve() == source:
        continue
    if target.exists() or target.is_symlink():
        saved = backup / target.relative_to(home)
        saved.parent.mkdir(parents=True, exist_ok=True)
        target.rename(saved)
    target.parent.mkdir(parents=True, exist_ok=True)
    target.symlink_to(source, target_is_directory=source.is_dir())

content = json.dumps(config, indent=2) + "\n"
if not hooks_path.exists() or hooks_path.read_text() != content:
    if hooks_path.exists():
        backup.mkdir(parents=True, exist_ok=True)
        shutil.copy2(hooks_path, backup / "hooks.json")
    hooks_path.write_text(content)
print("Installed Codex Jev alerts. Review and trust both new hooks in /hooks.")
print("Disable alerts: codex-jev off")
