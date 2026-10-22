-- Polar Aurora — Neovim colorscheme

require('main.themes.owl').load('polar-aurora', {
  dark = true,

  bg = '#181818', -- background
  bg_alt = '#121212', -- toolPendingBg
  bg_float = '#202020', -- toolSuccessBg
  bg_highlight = '#282828', -- userMsgBg
  bg_visual = '#383838',
  bg_sel = '#303030', -- darkGray

  fg = '#dedede', -- foreground
  fg_dim = '#777777', -- gray
  fg_dark = '#666666', -- dimGray
  border = '#303030', -- darkGray
  comment = '#858585', -- syntaxComment

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
  punct = '#dedede', -- foreground

  diff_add = '#1b3a2f',
  diff_change = '#242424',
  diff_delete = '#33212a',
  diff_text = '#2c5a45',

  terminal = {
    '#181818', '#de7d8c', '#7bdca9', '#e2c676',
    '#71a3e0', '#a28ae7', '#71cfd5', '#dedede',
    '#777777', '#ea94a1', '#92eebb', '#ecd58f',
    '#8bb5e9', '#b6a2ee', '#8adde2', '#f5f5f5',
  },
})
