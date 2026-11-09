set background=dark
highlight clear
if exists('syntax_on')
  syntax reset
endif
let g:colors_name = 'charcoal-atelier'

let s:bg      = '#161616'
let s:bg_alt  = '#1d1d1d'
let s:bg_sel  = '#262626'
let s:bg_vis  = '#3a3835'
let s:fg      = '#d6d2cc'
let s:fg_dim  = '#8f8c88'
let s:fg_dark = '#706e6b'
let s:comment = '#8f8c88'
let s:red     = '#d96a4d'
let s:green   = '#9aab84'
let s:yellow  = '#cfae7a'
let s:blue    = '#8aa0b4'
let s:magenta = '#b193a8'
let s:cyan    = '#8fafa8'
let s:orange  = '#cfae7a'
let s:accent  = '#e05d3a'
let s:string  = '#9aab84'

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
call s:hi('Cursor', s:bg, s:accent, '')
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
call s:hi('Visual', '#efece7', s:bg_vis, '')
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

call s:hi('DiffAdd', '', '#293025', '')
call s:hi('DiffChange', '', '#292929', '')
call s:hi('DiffDelete', '', '#302420', '')
call s:hi('DiffText', '', '#3e4c34', '')

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
      \ '#222222', '#d96a4d', '#9aab84', '#cfae7a',
      \ '#8aa0b4', '#b193a8', '#8fafa8', '#b5b1ab',
      \ '#5f5c58', '#e8886e', '#b3c39d', '#e0c493',
      \ '#a4b9cc', '#c8adc0', '#a8c7c0', '#efece7' ]
