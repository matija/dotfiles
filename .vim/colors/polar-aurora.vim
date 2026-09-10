" Polar Aurora — Vim colorscheme
" Colours sampled from the Polar Aurora swatch in the Herdr appearance panel.

set background=dark
highlight clear
if exists('syntax_on')
  syntax reset
endif
let g:colors_name = 'polar-aurora'

let s:bg      = '#101318'
let s:bg_alt  = '#0b0e13'
let s:bg_sel  = '#1e2a38'
let s:bg_vis  = '#233446'
let s:fg      = '#d8dfe5'
let s:fg_dim  = '#5c6b80'
let s:fg_dark = '#4b586b'
let s:comment = '#66788c'
let s:red     = '#de7d8c'
let s:green   = '#7bdca9'
let s:yellow  = '#e2c676'
let s:blue    = '#71a3e0'
let s:magenta = '#a28ae7'
let s:cyan    = '#71cfd5'
let s:orange  = '#e5a178'
let s:accent  = '#92eebb'
let s:string  = '#b58ad9'

function! s:hi(group, fg, bg, attr)
  let l:cmd = 'highlight ' . a:group
  let l:cmd .= empty(a:fg) ? '' : ' guifg=' . a:fg
  let l:cmd .= empty(a:bg) ? '' : ' guibg=' . a:bg
  let l:cmd .= ' gui=' . (empty(a:attr) ? 'NONE' : a:attr)
  execute l:cmd
endfunction

call s:hi('Normal', s:fg, s:bg, '')
call s:hi('NormalNC', s:fg, s:bg, '')
call s:hi('ColorColumn', '', s:bg_alt, '')
call s:hi('Cursor', s:bg, s:fg, '')
call s:hi('CursorLine', '', s:bg_sel, '')
call s:hi('CursorLineNr', s:accent, '', 'bold')
call s:hi('LineNr', s:fg_dark, '', '')
call s:hi('SignColumn', '', s:bg, '')
call s:hi('Folded', s:fg_dim, s:bg_alt, '')
call s:hi('FoldColumn', s:fg_dark, s:bg, '')
call s:hi('VertSplit', s:bg_sel, s:bg, '')
call s:hi('Directory', s:blue, '', '')
call s:hi('NonText', s:fg_dark, '', '')
call s:hi('SpecialKey', s:fg_dark, '', '')
call s:hi('MatchParen', s:accent, '', 'bold')
call s:hi('ModeMsg', s:fg, '', 'bold')
call s:hi('MoreMsg', s:blue, '', '')
call s:hi('Question', s:blue, '', '')
call s:hi('Title', s:blue, '', 'bold')
call s:hi('Visual', '', s:bg_vis, '')
call s:hi('Search', s:bg, s:yellow, '')
call s:hi('IncSearch', s:bg, s:orange, '')
call s:hi('WarningMsg', s:yellow, '', '')
call s:hi('ErrorMsg', s:red, '', '')
call s:hi('Pmenu', s:fg, s:bg_alt, '')
call s:hi('PmenuSel', s:fg, s:bg_sel, 'bold')
call s:hi('PmenuSbar', '', s:bg_alt, '')
call s:hi('PmenuThumb', '', s:fg_dark, '')
call s:hi('WildMenu', s:bg, s:accent, '')
call s:hi('StatusLine', s:fg, s:bg_sel, '')
call s:hi('StatusLineNC', s:fg_dark, s:bg_alt, '')
call s:hi('TabLine', s:fg_dim, s:bg_alt, '')
call s:hi('TabLineFill', '', s:bg_alt, '')
call s:hi('TabLineSel', s:fg, s:bg, 'bold')

call s:hi('DiffAdd', '', '#1b3a2f', '')
call s:hi('DiffChange', '', '#1a2333', '')
call s:hi('DiffDelete', '', '#33212a', '')
call s:hi('DiffText', '', '#2c5a45', '')

call s:hi('Comment', s:comment, '', 'italic')
call s:hi('Constant', s:orange, '', '')
call s:hi('String', s:string, '', '')
call s:hi('Character', s:string, '', '')
call s:hi('Number', s:orange, '', '')
call s:hi('Boolean', s:orange, '', '')
call s:hi('Float', s:orange, '', '')
call s:hi('Identifier', s:cyan, '', '')
call s:hi('Function', s:blue, '', '')
call s:hi('Statement', s:magenta, '', '')
call s:hi('Conditional', s:magenta, '', '')
call s:hi('Repeat', s:magenta, '', '')
call s:hi('Label', s:magenta, '', '')
call s:hi('Operator', s:cyan, '', '')
call s:hi('Keyword', s:magenta, '', '')
call s:hi('Exception', s:magenta, '', '')
call s:hi('PreProc', s:magenta, '', '')
call s:hi('Include', s:magenta, '', '')
call s:hi('Define', s:magenta, '', '')
call s:hi('Macro', s:magenta, '', '')
call s:hi('PreCondit', s:magenta, '', '')
call s:hi('Type', s:yellow, '', '')
call s:hi('StorageClass', s:magenta, '', '')
call s:hi('Structure', s:yellow, '', '')
call s:hi('Typedef', s:yellow, '', '')
call s:hi('Special', s:cyan, '', '')
call s:hi('SpecialChar', s:orange, '', '')
call s:hi('Tag', s:blue, '', '')
call s:hi('Delimiter', s:fg, '', '')
call s:hi('SpecialComment', s:fg_dim, '', 'italic')
call s:hi('Debug', s:red, '', '')
call s:hi('Underlined', s:cyan, '', 'underline')
call s:hi('Ignore', s:fg_dark, '', '')
call s:hi('Error', s:red, '', '')
call s:hi('Todo', s:bg, s:yellow, 'bold')

call s:hi('SpellBad', s:red, '', 'undercurl')
call s:hi('SpellCap', s:yellow, '', 'undercurl')
call s:hi('SpellLocal', s:cyan, '', 'undercurl')
call s:hi('SpellRare', s:magenta, '', 'undercurl')

let g:terminal_ansi_colors = [
      \ '#101318', '#de7d8c', '#7bdca9', '#e2c676',
      \ '#71a3e0', '#a28ae7', '#71cfd5', '#d8dfe5',
      \ '#5c6b80', '#ea94a1', '#92eebb', '#ecd58f',
      \ '#8bb5e9', '#b6a2ee', '#8adde2', '#f2f6f9' ]
