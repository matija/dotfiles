-- Polar Aurora — Neovim colorscheme
-- Colours sampled from the Polar Aurora swatch in the Herdr appearance panel.

require('main.themes.owl').load('polar-aurora', {
  dark = true,

  bg = '#101318', -- background
  bg_alt = '#0b0e13', -- toolPendingBg
  bg_float = '#161d25', -- toolSuccessBg
  bg_highlight = '#1a2532', -- userMsgBg
  bg_visual = '#233446',
  bg_sel = '#1e2a38', -- darkGray

  fg = '#d8dfe5', -- foreground
  fg_dim = '#5c6b80', -- gray
  fg_dark = '#4b586b', -- dimGray
  border = '#1e2a38', -- darkGray
  comment = '#66788c', -- syntaxComment

  red = '#de7d8c',
  green = '#7bdca9',
  yellow = '#e2c676',
  blue = '#71a3e0',
  magenta = '#a28ae7',
  cyan = '#71cfd5',
  orange = '#e5a178', -- syntaxNumber
  accent = '#92eebb',

  keyword = '#a28ae7', -- magenta
  func = '#71a3e0', -- blue
  variable = '#71cfd5', -- cyan
  string = '#b58ad9', -- syntaxString
  number = '#e5a178', -- syntaxNumber
  type = '#e2c676', -- yellow
  operator = '#71cfd5', -- cyan
  punct = '#d8dfe5', -- foreground

  diff_add = '#1b3a2f',
  diff_change = '#1a2333',
  diff_delete = '#33212a',
  diff_text = '#2c5a45',

  terminal = {
    '#101318', '#de7d8c', '#7bdca9', '#e2c676',
    '#71a3e0', '#a28ae7', '#71cfd5', '#d8dfe5',
    '#5c6b80', '#ea94a1', '#92eebb', '#ecd58f',
    '#8bb5e9', '#b6a2ee', '#8adde2', '#f2f6f9',
  },
})
