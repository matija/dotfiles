-- Nightowl — Neovim colorscheme
-- Ported from mitsuhiko/agent-stuff (themes/nightowl.json).

require('main.themes.owl').load('nightowl', {
  dark = true,

  bg = '#011627', -- background
  bg_alt = '#01111d', -- toolPendingBg
  bg_float = '#0b253a', -- toolSuccessBg
  bg_highlight = '#0b2942', -- userMsgBg
  bg_visual = '#1d3b53',
  bg_sel = '#122d42', -- darkGray

  fg = '#d6deeb', -- foreground
  fg_dim = '#5f7e97', -- gray
  fg_dark = '#4b6479', -- dimGray
  border = '#122d42', -- darkGray
  comment = '#637777', -- syntaxComment

  red = '#EF5350',
  green = '#c5e478',
  yellow = '#ffcb8b',
  blue = '#82AAFF',
  magenta = '#c792ea',
  cyan = '#7fdbca',
  orange = '#F78C6C', -- syntaxNumber
  accent = '#80CBC4',

  keyword = '#c792ea', -- magenta
  func = '#82AAFF', -- blue
  variable = '#7fdbca', -- cyan
  string = '#c789d6', -- syntaxString
  number = '#F78C6C', -- syntaxNumber
  type = '#ffcb8b', -- yellow
  operator = '#7fdbca', -- cyan
  punct = '#d6deeb', -- foreground

  diff_add = '#2c4339',
  diff_change = '#1b2640',
  diff_delete = '#352330',
  diff_text = '#4b6446',

  terminal = {
    '#011627', '#EF5350', '#c5e478', '#ffcb8b',
    '#82AAFF', '#c792ea', '#7fdbca', '#d6deeb',
    '#5f7e97', '#EF5350', '#22da6e', '#ffeb95',
    '#82AAFF', '#c792ea', '#80CBC4', '#ffffff',
  },
})
