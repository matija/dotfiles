# Dotfiles

Personal configs for Neovim, Vim, Bash, Zsh, and tmux.
Includes agent skills, rules, extensions, and themes for AI tools and VS Code.

`sync.sh` copies live configs into this repo.

[Pi setup and two-way synchronization](pi/README.md) use symlinks to this checkout.

Charcoal Atelier follows the palette bundled in Rex Beta: `#161616` background, `#d6d2cc` text, and `#e05d3a` accent.
The exact Rex theme is saved in `themes/charcoal-atelier.json`.

Slack import: `#161616,#E05D3A,#9AAB84,#D96A4D` (dark mode, window gradient off).
The VS Code theme also works in Cursor; each app's installed theme and appearance settings are tracked separately.
Codex appearance includes its terminal theme and desktop dark colors.

## Funky Fresh

Light and dark variants adapt Slack's [Funky Fresh palette](https://slack.green/en/tools/slack-theme-generator): `#BEB0FF`, `#71D18F`, `#00FF50`, and `#CDC8E8`.
Light is the current default. Text colors use darker shades for contrast on light backgrounds.

| App | Light theme | Dark theme |
| --- | --- | --- |
| Neovim | `funky-fresh-light` | `funky-fresh-dark` |
| Pi | `funky-fresh-light` | `funky-fresh-dark` |
| Codex CLI | `funky-fresh-light` | `funky-fresh-dark` |
| Claude Code | `custom:funky-fresh-light` | `custom:funky-fresh-dark` |
| Cursor and VS Code | `Funky Fresh Light` | `Funky Fresh Dark` |
| Zed | `Funky Fresh Light` | `Funky Fresh Dark` |

Cursor Agent uses the terminal's colors, not a custom theme file.
The Ghostty themes in `cursor-agent/themes/` supply matching terminal colors.
The installed Ghostty default is `funky-fresh-light`.
These terminal colors also supply the base background for the other CLI apps.

Select themes through `/settings` in Pi, `/theme` in Codex or Claude Code, or the editor's Color Theme selector.
For Neovim, use `:colorscheme funky-fresh-dark` or `:colorscheme funky-fresh-light`.
For Ghostty, set `theme = funky-fresh-dark` or `theme = funky-fresh-light` in its config.
Restart terminal apps after a terminal theme change.
The Codex desktop appearance remains unchanged.
