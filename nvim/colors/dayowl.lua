-- Dayowl — Neovim colorscheme
-- Ported from mitsuhiko/agent-stuff (themes/dayowl.json).

require('main.themes.owl').load('dayowl', {
  dark = false,

  bg = '#f8f9fa', -- background
  bg_alt = '#f1f4f7', -- customMsgBg
  bg_float = '#ffffff', -- export.cardBg
  bg_highlight = '#fff3d6', -- userMsgBg
  bg_visual = '#dcecff', -- selectedBg
  bg_sel = '#e4ecf4',

  fg = '#5c6166', -- foreground
  fg_dim = '#686868', -- brightBlack
  fg_dark = '#8a9199', -- dimGray
  border = '#d8dde3', -- borderGray
  comment = '#8a9199', -- syntaxComment

  red = '#ea6c6d',
  green = '#6cbf43',
  yellow = '#eca944',
  blue = '#3199e1',
  magenta = '#9e75c7',
  cyan = '#46ba94',
  orange = '#ffaa33', -- accent
  accent = '#ffaa33',

  keyword = '#ea6c6d', -- red
  func = '#f2ae49', -- brightYellow
  variable = '#5c6166', -- foreground
  string = '#399ee6', -- brightBlue
  number = '#a37acc', -- brightMagenta
  type = '#399ee6', -- brightBlue
  operator = '#eca944', -- yellow
  punct = '#5c6166', -- foreground

  diff_add = '#edf7e6',
  diff_change = '#fff6e6',
  diff_delete = '#fff0f0',
  diff_text = '#d8ecc4',

  terminal = {
    '#000000', '#ea6c6d', '#6cbf43', '#eca944',
    '#3199e1', '#9e75c7', '#46ba94', '#bababa',
    '#686868', '#f07171', '#86b300', '#f2ae49',
    '#399ee6', '#a37acc', '#4cbf99', '#d1d1d1',
  },
})
