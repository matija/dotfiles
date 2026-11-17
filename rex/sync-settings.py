import json
import plistlib
import subprocess
from pathlib import Path

keys = {
    'Workspace.animationStyle',
    'Workspace.appIcon',
    'Workspace.appearance',
    'Workspace.customThemes',
    'Workspace.darkThemeID',
    'Workspace.darkUsesExtendedThemePalette',
    'Workspace.inactivePaneFadeMode',
    'Workspace.interfaceStyle',
    'Workspace.lightThemeID',
    'Workspace.lightUsesExtendedThemePalette',
    'Workspace.paneDensity',
    'Workspace.tabIconTintMode',
    'Workspace.tabsFillAvailableSpace',
    'Workspace.usesStandardInactiveWindowPaneStyles',
    'rex.agents.names-sessions',
    'rex.client.remoteControl',
    'rex.server.automatic-restart-enabled',
    'rex.server.block-plugin-reload-enabled',
    'rex.server.run-mode',
    'rex.server.tailnet-enabled',
    'rex.server.web-client-origin-patterns',
    'SUEnableAutomaticChecks',
    'SUAutomaticallyUpdate',
    'SUScheduledCheckInterval',
}
preferences = plistlib.loads(subprocess.check_output([
    'defaults', 'export', 'com.superlogical.rex', '-'
]))
settings = {key: value for key, value in preferences.items() if key in keys}
if 'Workspace.customThemes' in settings:
    settings['Workspace.customThemes'] = json.loads(settings['Workspace.customThemes'])
Path(__file__).with_name('settings.json').write_text(
    json.dumps(settings, indent=2, sort_keys=True) + '\n'
)
