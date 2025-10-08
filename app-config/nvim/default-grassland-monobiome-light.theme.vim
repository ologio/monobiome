" vi:syntax=vim
"
" Top-level remarks:
"
" - `hi` sets highlight colors for syntax groups, allowing one to specify fg and bg colors
"   for GUI and terminal Vim.
" - `link` allows for linking one syntax group to another, reusing the same color
"   settings. Language-specific groups can then point to one of the base color highlight
"   groups, for example, without needing to repeat the raw color values.
"
" There are several kinds of syntax identifiers:
"
" - Vim/editor related (e.g., Normal, Folded): these control colors of central Vim
"   elements, like whitespace, bold text, the foldcolumn, etc
" - Generic syntax identifiers (e.g., Boolean, Conditional): these are key groups for
"   syntax elements that various language syntax files link to. For instance, Python
"   syntax files might have specific patterns that match function keywords like "def," and
"   the resulting syntax region can be highlighted by linking it to the core "Function"
"   highlight identifier.
" - Treesitter-based identifiers (e.g., @variable, @boolean): highlight groups for
"   treesitter-based syntax highlighting, which can replace regex-based matching when
"   enabled for richer (and often faster) highlighting. These groups can be linked to the
"   core identifiers like any other language.
"
"   *Note*: each of these identifiers can add a lang-specific suffix to style those groups
"   as they apply to particular languages. For ex, `@boolean.python ThemeRed` would style
"   Python booleans red, while the lang-agnostic `@boolean` definition remains.
" - Plugin-oriented identifiers (e.g., SpellBad, ErrorFloat): these are groups mostly core
"   to vim/nvim, but often appear only in the context of plugins or certain modules (like
"   LSP). For instance, ErrorFloat styles floating windows that might be drawn by nvim's
"   built-in LSP hover info.

" GUI color definitions
let s:gui00        = "#d9e0da"
let g:base16_gui00 = "#d9e0da"
let s:gui01        = "#c9d0ca"
let g:base16_gui01 = "#c9d0ca"
let s:gui02        = "#b9c0ba"
let g:base16_gui02 = "#b9c0ba"
let s:gui03        = "#a9b0aa"
let g:base16_gui03 = "#a9b0aa"
let s:gui04        = "#444944"
let g:base16_gui04 = "#444944"
let s:gui05        = "#373c37"
let g:base16_gui05 = "#373c37"
let s:gui06        = "#2a2f2b"
let g:base16_gui06 = "#2a2f2b"
let s:gui07        = "#1e231f"
let g:base16_gui07 = "#1e231f"
let s:gui08        = "#b42219"
let g:base16_gui08 = "#b42219"
let s:gui09        = "#905201"
let g:base16_gui09 = "#905201"
let s:gui0A        = "#6a6535"
let g:base16_gui0A = "#6a6535"
let s:gui0B        = "#377242"
let g:base16_gui0B = "#377242"
let s:gui0C        = "#377242"
let g:base16_gui0C = "#377242"
let s:gui0D        = "#3860ac"
let g:base16_gui0D = "#3860ac"
let s:gui0E        = "#3860ac"
let g:base16_gui0E = "#3860ac"
let s:gui0F        = "#b42219"
let g:base16_gui0F = "#b42219"

let s:grey         = "#7c827d"

" Terminal color definitions
let s:cterm00        = "00"
let g:base16_cterm00 = "00"
let s:cterm03        = "08"
let g:base16_cterm03 = "08"
let s:cterm05        = "07"
let g:base16_cterm05 = "07"
let s:cterm07        = "15"
let g:base16_cterm07 = "15"
let s:cterm08        = "01"
let g:base16_cterm08 = "01"
let s:cterm0A        = "03"
let g:base16_cterm0A = "03"
let s:cterm0B        = "02"
let g:base16_cterm0B = "02"
let s:cterm0C        = "06"
let g:base16_cterm0C = "06"
let s:cterm0D        = "04"
let g:base16_cterm0D = "04"
let s:cterm0E        = "05"
let g:base16_cterm0E = "05"

let s:cterm01        = "10"
let g:base16_cterm01 = "10"
let s:cterm02        = "11"
let g:base16_cterm02 = "11"
let s:cterm04        = "12"
let g:base16_cterm04 = "12"
let s:cterm06        = "13"
let g:base16_cterm06 = "13"
let s:cterm09        = "09"
let g:base16_cterm09 = "09"
let s:cterm0F        = "14"
let g:base16_cterm0F = "14"

" Neovim terminal colours
if has("nvim")
  let g:terminal_color_0 =  "#d9e0da"
  let g:terminal_color_1 =  "#b42219"
  let g:terminal_color_2 =  "#377242"
  let g:terminal_color_3 =  "#6a6535"
  let g:terminal_color_4 =  "#3860ac"
  let g:terminal_color_5 =  "#3860ac"
  let g:terminal_color_6 =  "#377242"
  let g:terminal_color_7 =  "#373c37"
  let g:terminal_color_8 =  "#a9b0aa"
  let g:terminal_color_9 =  "#b42219"
  let g:terminal_color_10 = "#377242"
  let g:terminal_color_11 = "#6a6535"
  let g:terminal_color_12 = "#3860ac"
  let g:terminal_color_13 = "#3860ac"
  let g:terminal_color_14 = "#377242"
  let g:terminal_color_15 = "#1e231f"
  let g:terminal_color_background = g:terminal_color_0
  let g:terminal_color_foreground = g:terminal_color_5

  if &background == "light"
    let g:terminal_color_background = g:terminal_color_7
    let g:terminal_color_foreground = g:terminal_color_2
  endif

elseif has("terminal")
  let g:terminal_ansi_colors = [
    \ "#d9e0da",
    \ "#b42219",
    \ "#377242",
    \ "#6a6535",
    \ "#3860ac",
    \ "#3860ac",
    \ "#377242",
    \ "#373c37",
    \ "#a9b0aa",
    \ "#b42219",
    \ "#377242",
    \ "#6a6535",
    \ "#3860ac",
    \ "#3860ac",
    \ "#377242",
    \ "#1e231f",
    \ ]
endif

let s:guibg = s:gui00
let s:ctermbg = s:cterm00

" Theme setup
hi clear
syntax reset
let g:colors_name = "active"

" Highlighting function
" Optional variables are attributes and guisp
function! g:Base16hi(group, guifg, guibg, ctermfg, ctermbg, ...)
  " For a given syntax group, sets the GUI and terminal foreground and backgrounds
  " Optional parameters are interpreted as `attr` and `guisp`, the first of which appears
  " to be a modifier for the group (e.g., bold, italic), and `guisp` appears to be
  " 'special' colors used for underlines in the GUI.
  let l:attr = get(a:, 1, "")
  let l:guisp = get(a:, 2, "")

  " See :help highlight-guifg
  let l:gui_special_names = ["NONE", "bg", "background", "fg", "foreground"]

  if a:guifg != ""
    if index(l:gui_special_names, a:guifg) >= 0
      exec "hi " . a:group . " guifg=" . a:guifg
    else
      exec "hi " . a:group . " guifg=" . a:guifg
    endif
  endif

  if a:guibg != ""
    if index(l:gui_special_names, a:guibg) >= 0
      exec "hi " . a:group . " guibg=" . a:guibg
    else
      exec "hi " . a:group . " guibg=" . a:guibg
    endif
  endif

  if a:ctermfg != ""
    exec "hi " . a:group . " ctermfg=" . a:ctermfg
  endif

  if a:ctermbg != ""
    exec "hi " . a:group . " ctermbg=" . a:ctermbg
  endif

  if l:attr != ""
    exec "hi " . a:group . " gui=" . l:attr . " cterm=" . l:attr
  endif

  if l:guisp != ""
    if index(l:gui_special_names, l:guisp) >= 0
      exec "hi " . a:group . " guisp=" . l:guisp
    else
      exec "hi " . a:group . " guisp=" . l:guisp
    endif
  endif
endfunction


fun <sid>hi(group, guifg, guibg, ctermfg, ctermbg, attr, guisp)
  call g:Base16hi(a:group, a:guifg, a:guibg, a:ctermfg, a:ctermbg, a:attr, a:guisp)
endfun


" color groups for interpretability
call <sid>hi("ThemeBg0",         s:gui00, "", s:cterm00, "", "",       "")
call <sid>hi("ThemeBg1",         s:gui01, "", s:cterm01, "", "",       "")
call <sid>hi("ThemeBg2",         s:gui02, "", s:cterm02, "", "",       "")
call <sid>hi("ThemeBg3",         s:gui03, "", s:cterm03, "", "",       "")
call <sid>hi("ThemeFg3",         s:gui04, "", s:cterm04, "", "",       "")
call <sid>hi("ThemeFg2",         s:gui05, "", s:cterm05, "", "",       "")
call <sid>hi("ThemeFg1",         s:gui06, "", s:cterm06, "", "",       "")
call <sid>hi("ThemeFg0",         s:gui07, "", s:cterm07, "", "",       "")

call <sid>hi("ThemeBg0bold", s:gui00, "", s:cterm00, "", "bold",       "")
call <sid>hi("ThemeBg1bold", s:gui01, "", s:cterm01, "", "bold",       "")
call <sid>hi("ThemeBg2bold", s:gui02, "", s:cterm02, "", "bold",       "")
call <sid>hi("ThemeBg3bold", s:gui03, "", s:cterm03, "", "bold",       "")
call <sid>hi("ThemeFg3bold", s:gui04, "", s:cterm04, "", "bold",       "")
call <sid>hi("ThemeFg2bold", s:gui05, "", s:cterm05, "", "bold",       "")
call <sid>hi("ThemeFg1bold", s:gui06, "", s:cterm06, "", "bold",       "")
call <sid>hi("ThemeFg0bold", s:gui07, "", s:cterm07, "", "bold",       "")

call <sid>hi("ThemeBg0Italic", s:gui00, "", s:cterm00, "", "italic",       "")
call <sid>hi("ThemeBg1Italic", s:gui01, "", s:cterm01, "", "italic",       "")
call <sid>hi("ThemeBg2Italic", s:gui02, "", s:cterm02, "", "italic",       "")
call <sid>hi("ThemeBg3Italic", s:gui03, "", s:cterm03, "", "italic",       "")
call <sid>hi("ThemeFg3Italic", s:gui04, "", s:cterm04, "", "italic",       "")
call <sid>hi("ThemeFg2Italic", s:gui05, "", s:cterm05, "", "italic",       "")
call <sid>hi("ThemeFg1Italic", s:gui06, "", s:cterm06, "", "italic",       "")
call <sid>hi("ThemeFg0Italic", s:gui07, "", s:cterm07, "", "italic",       "")

call <sid>hi("ThemeRed",         s:gui08, "", s:cterm08, "", "",       "")
call <sid>hi("ThemeOrange",      s:gui09, "", s:cterm09, "", "",       "")
call <sid>hi("ThemeYellow",      s:gui0A, "", s:cterm0A, "", "",       "")
call <sid>hi("ThemeGreen",       s:gui0B, "", s:cterm0B, "", "",       "")
call <sid>hi("ThemeCyan",        s:gui0C, "", s:cterm0C, "", "",       "")
call <sid>hi("ThemeBlue",        s:gui0D, "", s:cterm0D, "", "",       "")
call <sid>hi("ThemeViolet",      s:gui0E, "", s:cterm0E, "", "",       "")
call <sid>hi("ThemeMagenta",     s:gui0F, "", s:cterm0F, "", "",       "")

call <sid>hi("ThemeRedNone",     s:gui08, "", s:cterm08, "", "NONE",   "")
call <sid>hi("ThemeOrangeNone",  s:gui09, "", s:cterm09, "", "NONE",   "")
call <sid>hi("ThemeYellowNone",  s:gui0A, "", s:cterm0A, "", "NONE",   "")
call <sid>hi("ThemeGreenNone",   s:gui0B, "", s:cterm0B, "", "NONE",   "")
call <sid>hi("ThemeCyanNone",    s:gui0C, "", s:cterm0C, "", "NONE",   "")
call <sid>hi("ThemeBlueNone",    s:gui0D, "", s:cterm0D, "", "NONE",   "")
call <sid>hi("ThemeVioletNone",  s:gui0E, "", s:cterm0E, "", "NONE",   "")
call <sid>hi("ThemeMagentaNone", s:gui0F, "", s:cterm0F, "", "NONE",   "")

call <sid>hi("ThemeRedBold",     s:gui08, "", s:cterm08, "", "bold",   "")
call <sid>hi("ThemeOrangeBold",  s:gui09, "", s:cterm09, "", "bold",   "")
call <sid>hi("ThemeYellowBold",  s:gui0A, "", s:cterm0A, "", "bold",   "")
call <sid>hi("ThemeGreenBold",   s:gui0B, "", s:cterm0B, "", "bold",   "")
call <sid>hi("ThemeCyanBold",    s:gui0C, "", s:cterm0C, "", "bold",   "")
call <sid>hi("ThemeBlueBold",    s:gui0D, "", s:cterm0D, "", "bold",   "")
call <sid>hi("ThemeVioletBold",  s:gui0E, "", s:cterm0E, "", "bold",   "")
call <sid>hi("ThemeMagentaBold", s:gui0F, "", s:cterm0F, "", "bold",   "")

call <sid>hi("ThemeRedItalic",     s:gui08, "", s:cterm08, "", "italic",   "")
call <sid>hi("ThemeOrangeItalic",  s:gui09, "", s:cterm09, "", "italic",   "")
call <sid>hi("ThemeYellowItalic",  s:gui0A, "", s:cterm0A, "", "italic",   "")
call <sid>hi("ThemeGreenItalic",   s:gui0B, "", s:cterm0B, "", "italic",   "")
call <sid>hi("ThemeCyanItalic",    s:gui0C, "", s:cterm0C, "", "italic",   "")
call <sid>hi("ThemeBlueItalic",    s:gui0D, "", s:cterm0D, "", "italic",   "")
call <sid>hi("ThemeVioletItalic",  s:gui0E, "", s:cterm0E, "", "italic",   "")
call <sid>hi("ThemeMagentaItalic", s:gui0F, "", s:cterm0F, "", "italic",   "")

call <sid>hi("ThemeRedBoldItalic",     s:gui08, "", s:cterm08, "", "bold,italic", "")
call <sid>hi("ThemeOrangeBoldItalic",  s:gui09, "", s:cterm09, "", "bold,italic", "")
call <sid>hi("ThemeYellowBoldItalic",  s:gui0A, "", s:cterm0A, "", "bold,italic", "")
call <sid>hi("ThemeGreenBoldItalic",   s:gui0B, "", s:cterm0B, "", "bold,italic", "")
call <sid>hi("ThemeCyanBoldItalic",    s:gui0C, "", s:cterm0C, "", "bold,italic", "")
call <sid>hi("ThemeBlueBoldItalic",    s:gui0D, "", s:cterm0D, "", "bold,italic", "")
call <sid>hi("ThemeVioletBoldItalic",  s:gui0E, "", s:cterm0E, "", "bold,italic", "")
call <sid>hi("ThemeMagentaBoldItalic", s:gui0F, "", s:cterm0F, "", "bold,italic", "")

call <sid>hi("ThemeGrey",        s:grey,  "", s:cterm03, "", "",       "")
call <sid>hi("ThemeGreyItalic",  s:grey,  "", s:cterm03, "", "italic", "")


" Vim editor colors
call <sid>hi("Bold",          "", "", "", "", "bold", "")
call <sid>hi("Italic",        "", "", "", "", "italic", "")
call <sid>hi("BoldItalic",    "", "", "", "", "italic,bold", "")

call <sid>hi("Normal",        s:gui05, s:guibg, s:cterm05, s:ctermbg, "", "")
call <sid>hi("Debug",         s:gui08, "", s:cterm08, "", "", "")
call <sid>hi("Directory",     s:gui0D, "", s:cterm0D, "", "", "")
call <sid>hi("Error",         s:guibg, s:gui08, s:ctermbg, s:cterm08, "", "")
call <sid>hi("ErrorMsg",      s:gui08, s:guibg, s:cterm08, s:ctermbg, "", "")
call <sid>hi("Exception",     s:gui08, "", s:cterm08, "", "", "")
call <sid>hi("FoldColumn",    s:gui03, s:guibg, s:cterm03, s:ctermbg, "", "")
call <sid>hi("Folded",        s:gui03, s:gui01, s:cterm02, s:ctermbg, "", "")
call <sid>hi("IncSearch",     s:gui01, s:gui09, s:cterm01, s:cterm09, "none", "")
call <sid>hi("Macro",         s:gui0C, "", s:cterm0C, "", "", "")
call <sid>hi("MatchParen",    "", s:gui03, "", s:cterm03,  "", "")
call <sid>hi("ModeMsg",       s:gui0B, "", s:cterm0B, "", "", "")
call <sid>hi("MoreMsg",       s:gui0B, "", s:cterm0B, "", "", "")
call <sid>hi("Question",      s:gui0D, "", s:cterm0D, "", "", "")
call <sid>hi("Search",        s:gui01, s:gui0A, s:cterm01, s:cterm0A,  "", "")
call <sid>hi("Substitute",    s:gui01, s:gui0A, s:cterm01, s:cterm0A, "none", "")
call <sid>hi("SpecialKey",    s:gui03, "", s:cterm03, "", "", "")
call <sid>hi("TooLong",       s:gui08, "", s:cterm08, "", "", "")
call <sid>hi("Underlined",    "", "", "", "", "underline", "fg")
call <sid>hi("Visual",        "", s:gui02, "", s:cterm02, "", "")
call <sid>hi("VisualNOS",     s:gui08, "", s:cterm08, "", "", "")
call <sid>hi("WarningMsg",    s:gui08, "", s:cterm08, "", "", "")
call <sid>hi("WildMenu",      s:guibg, s:gui06, s:ctermbg, s:cterm05, "", "")
call <sid>hi("Title",         s:gui0D, "", s:cterm0D, "", "none", "")

"call <sid>hi("Conceal",       s:gui0D, s:guibg, s:cterm0D, s:ctermbg, "", "")
hi! link Conceal              ThemeBlue

call <sid>hi("Cursor",        s:gui05, s:guibg, "", "", "inverse", "")
call <sid>hi("NonText",       s:gui03, "", s:cterm03, "", "", "")
call <sid>hi("Whitespace",    s:gui03, "", s:cterm03, "", "", "")
call <sid>hi("LineNr",        s:gui03, s:guibg, s:cterm03, s:ctermbg, "", "")
call <sid>hi("SignColumn",    s:gui03, s:guibg, s:cterm03, s:ctermbg, "", "")
call <sid>hi("StatusLine",    s:gui07, s:gui01, s:cterm07, s:cterm01, "none", "")
call <sid>hi("StatusLineNC",  s:gui06, s:gui01, s:cterm05, s:cterm01, "none", "")
call <sid>hi("VertSplit",     s:gui01, s:guibg, s:cterm01, s:ctermbg, "none", "")
call <sid>hi("ColorColumn",   "", s:gui01, "", s:cterm01, "none", "")
call <sid>hi("CursorColumn",  "", s:gui01, "", s:cterm01, "none", "")
call <sid>hi("CursorLine",    "", s:gui01, "", s:cterm01, "none", "")
call <sid>hi("CursorLineNr",  s:gui04, s:gui00, s:cterm04, s:cterm01, "", "")
call <sid>hi("QuickFixLine",  "", s:gui01, "", s:cterm01, "none", "")
call <sid>hi("PMenu",         s:gui06, s:gui01, s:cterm06, s:cterm01, "none", "")
call <sid>hi("PMenuSel",      s:gui06, s:gui02, s:cterm06, s:cterm02, "", "")
call <sid>hi("PMenuSbar",     "", s:gui03, "", s:cterm03, "", "")
call <sid>hi("PMenuThumb",    "", s:gui04, "", s:cterm04, "", "")
call <sid>hi("TabLine",       s:gui03, s:gui01, s:cterm03, s:cterm01, "none", "")
call <sid>hi("TabLineFill",   s:gui03, s:gui01, s:cterm03, s:cterm01, "none", "")
call <sid>hi("TabLineSel",    s:gui0B, s:gui01, s:cterm0B, s:cterm01, "none", "")

" Standard syntax
call <sid>hi("Define",       s:gui0E, "", s:cterm0E, "", "none", "")
call <sid>hi("Identifier",   s:gui06, "", s:cterm05, "", "none", "")
call <sid>hi("Keyword",      s:gui0D, "", s:cterm0E, "", "none", "")
call <sid>hi("Todo",         s:gui08, s:guibg, s:cterm08, s:ctermbg, "italic", "")

hi! link Boolean             ThemeOrange
hi! link Character           ThemeRed
hi! link Comment             ThemeGreyItalic
hi! link Conditional         ThemeRed
hi! link Constant            ThemeOrange
hi! link Delimiter           ThemeFg1
hi! link Float               ThemeOrange
hi! link Function            ThemeBlue
hi! link Include             ThemeBlue
hi! link Constant            ThemeOrange
hi! link Label               ThemeOrange
hi! link Number              ThemeOrange
hi! link Operator            ThemeYellow
hi! link PreProc             ThemeOrange
hi! link Repeat              ThemeViolet
hi! link Special             ThemeYellow
hi! link SpecialChar         ThemeMagenta
hi! link Statement           ThemeRed
hi! link StorageClass        ThemeOrange
hi! link String              ThemeGreen
hi! link Structure           ThemeOrange
hi! link Tag                 ThemeOrange
hi! link Type                ThemeYellow
hi! link Typedef             ThemeOrange


" Treesitter
if has("nvim-0.8.0")
  hi! link @field                    ThemeRed
  hi! link @property                 ThemeRed
  hi! link @namespace                ThemeFg1Italic
  hi! link @variable.builtin         ThemeFg1Italic
  hi! link @variable                 ThemeFg2
  hi! link @conceal                  ThemeBlue

  hi! link @text.uri                 ThemeRedItalic
  hi! link @text.reference           ThemeRed

  hi! link @annotation               ThemeViolet
  hi! link @attribute                ThemeBlue

  hi! link @boolean                  ThemeOrange
  hi! link @character                ThemeRed
  hi! link @character.special        ThemeMagenta
  hi! link @comment                  Comment

  hi! link @constant                 ThemeBlue
  hi! link @constant.builtin         ThemeBlue

  hi! link @constant.macro           ThemeRed

  hi! link @keyword.directive.define ThemeViolet
  hi! link @keyword.exception        ThemeRed

  hi! link @comment.error            ThemeRed
  hi! link @number.float             ThemeRed
  hi! link @keyword.function         ThemeRed

  hi! link @function                 ThemeBlue
  hi! link @function.builtin         ThemeBlue
  hi! link @function.call            ThemeBlue
  hi! link @function.macro           ThemeRed
  hi! link @function.method          ThemeBlue
  hi! link @function.method.call     ThemeBlue

  hi! link @keyword.debug            ThemeRed
  hi! link @keyword.conditional      ThemeRed
  hi! link @keyword.import           ThemeViolet
  hi! link @keyword.coroutine        ThemeViolet
  hi! link @keyword.operator         ThemeYellow
  hi! link @keyword.directive        ThemeViolet
  hi! link @keyword.repeat           ThemeViolet
  hi! link @keyword.storage          ThemeViolet
  hi! link @keyword.return           ThemeRed

  hi! link @constructor              ThemeBlue
  hi! link @namespace.builtin        ThemeViolet

  hi! link @none                     ThemeFg1
  hi! link @number                   ThemeOrange
  hi! link @string                   ThemeGreen

  hi! link @tag                      ThemeRed
  hi! link @tag.delimiter            ThemeViolet
  hi! link @tag.attribute            ThemeYellow

  " affects markdown
  hi! link @markup                   ThemeYellow

  hi! link @markup.raw               ThemeGreen
  hi! link @markup.raw.block.lang    ThemeFg2Bold
  hi! link @markup.raw.block.marker  ThemeRed
  "call <sid>hi("@markup.raw.block.lang", s:gui08, "#1e0000", "", s:ctermbg, "", "")

  hi! link @markup.list              ThemeBlue
  hi! link @markup.quote             ThemeGrey

  hi! link @markup.link              ThemeYellow " borders
  hi! link @markup.link.text         ThemeBlue
  hi! link @markup.link.label        ThemeYellow
  hi! link @markup.link.url          ThemeYellow
  hi! link @markup.link.dest         ThemeFg3
  
  hi! link @markup.link.wiki         ThemeYellow
  hi! link @markup.link.wiki.text    ThemeBlue
  hi! link @markup.link.wiki.label   ThemeYellow

  "hi! link @markup.link.label.symbol ThemeGreen

  "hi! link markdownWikiLink          ThemeViolet
  "
  hi! link @markup.environment       ThemeYellow
  hi! link @markup.environment.name  ThemeYellow
  hi! link @markup.math              ThemeYellow
  hi! link @punctuation.delimiter.latex ThemeOrange

  hi! link @markup.strong            Bold
  hi! link @markup.emphasis          Bold
  hi! link @markup.strikethrough     ThemeYellow
  hi! link @markup.underline         ThemeYellow

  hi! link @comment.info             ThemeBlue
  hi! link @comment.todo             ThemeYellow
  hi! link @comment.note             ThemeBg3
  hi! link @comment.hint             ThemeGreen
  hi! link @comment.warning          ThemeOrange

  hi! link @type                     ThemeYellow
  hi! link @type.builtin             ThemeOrange
  hi! link @type.definition          ThemeViolet
  hi! link @type.qualifier           ThemeViolet

  " Markdown
  " hi! link @spell.markdown ThemeFg3
  
  "call <sid>hi("@markup.heading.marker",  s:gui08, "", "", s:ctermbg, "bold", "")
  "hi! link @markup.heading           ThemeRed
  hi! link @markup.heading.marker    ThemeOrange
  hi! link @markup.heading.title     ThemeRed "Italic

  " set this for a strong background 
  "call <sid>hi("@markup.heading.title", s:gui08, "#440503", "", s:ctermbg, "italic", "")

  hi! link @markup.heading.title.1   Bold
  hi! link @markup.heading.title.3   Italic
  "hi! link @markup.heading.4.title   Italic

  " YAML
  hi! link @string.yaml ThemeBlue
  hi! link @punctuation.delimiter.yaml ThemeGreen
  hi! link @property.yaml ThemeFg2

  " Diff
  hi! link @diff.minus ThemeRed
  hi! link @diff.plus  ThemeGreen

  call <sid>hi("TreesitterContext", "", s:gui00, "", "", "", "")
  "hi TreesitterContextLineNumberBottom gui=underline guisp=Gray
  "call <sid>hi("TreesitterContextBottom", "", "", "", "", "underline", s:gui02)
  call <sid>hi("TreesitterContextSeparator", s:gui03, "", "", "", "", "")
  "call <sid>hi("TreesitterContextLineNumberBottom", "", "", "", "", "underline", s:gui02)
endif

" Standard highlights to be used by plugins
if has("patch-8.0.1038")
  call <sid>hi("Deprecated",   "", "", "", "", "strikethrough", "")
endif
call <sid>hi("SearchMatch",  s:gui0C, "", s:cterm0C, "", "", "")

call <sid>hi("GitAddSign",           s:gui0B, "", s:cterm0B, "", "", "")
call <sid>hi("GitChangeSign",        s:gui04, "", s:cterm04, "", "", "")
call <sid>hi("GitDeleteSign",        s:gui08, "", s:cterm08, "", "", "")
call <sid>hi("GitChangeDeleteSign",  s:gui04, "", s:cterm04, "", "", "")

call <sid>hi("ErrorSign",    s:gui08, "", s:cterm08, "", "", "")
call <sid>hi("WarningSign",  s:gui09, "", s:cterm09, "", "", "")
call <sid>hi("InfoSign",     s:gui0D, "", s:cterm0D, "", "", "")
call <sid>hi("HintSign",     s:gui0C, "", s:cterm0C, "", "", "")
call <sid>hi("OkSign",       s:gui0B, "", s:cterm0B, "", "", "")

call <sid>hi("ErrorFloat",   s:gui08, s:gui01, s:cterm08, s:cterm01, "", "")
call <sid>hi("WarningFloat", s:gui09, s:gui01, s:cterm09, s:cterm01, "", "")
call <sid>hi("InfoFloat",    s:gui0D, s:gui01, s:cterm0D, s:cterm01, "", "")
call <sid>hi("HintFloat",    s:gui0C, s:gui01, s:cterm0C, s:cterm01, "", "")
call <sid>hi("OkFloat",      s:gui0B, s:gui01, s:cterm0B, s:cterm01, "", "")
call <sid>hi("NormalFloat",  s:gui05, s:gui01, s:cterm05, s:cterm01, "", "")

call <sid>hi("ErrorHighlight",   "", "", s:ctermbg, s:cterm08, "underline", s:gui08)
call <sid>hi("WarningHighlight", "", "", s:ctermbg, s:cterm09, "underline", s:gui09)
call <sid>hi("InfoHighlight",    "", "", s:ctermbg, s:cterm0D, "underline", s:gui0D)
call <sid>hi("HintHighlight",    "", "", s:ctermbg, s:cterm0C, "underline", s:gui0C)
call <sid>hi("OkHighlight",      "", "", s:ctermbg, s:cterm0B, "underline", s:gui0B)

call <sid>hi("SpellBad",     "", "", s:ctermbg, s:cterm08, "undercurl", s:gui08)
call <sid>hi("SpellLocal",   "", "", s:ctermbg, s:cterm0C, "undercurl", s:gui0C)
call <sid>hi("SpellCap",     "", "", s:ctermbg, s:cterm0D, "undercurl", s:gui0D)
call <sid>hi("SpellRare",    "", "", s:ctermbg, s:cterm0E, "undercurl", s:gui0E)

call <sid>hi("ReferenceText",   s:gui01, s:gui0A, s:cterm01, s:cterm0A, "", "")
call <sid>hi("ReferenceRead",   s:gui01, s:gui0B, s:cterm01, s:cterm0B, "", "")
call <sid>hi("ReferenceWrite",  s:gui01, s:gui08, s:cterm01, s:cterm08, "", "")

" LSP
if has("nvim")
  hi! link DiagnosticError  ErrorSign
  hi! link DiagnosticWarn   WarningSign
  hi! link DiagnosticInfo   InfoSign
  hi! link DiagnosticHint   HintSign
  hi! link DiagnosticOk     OkSign

  hi! link DiagnosticFloatingError  ErrorFloat
  hi! link DiagnosticFloatingWarn   WarningFloat
  hi! link DiagnosticFloatingInfo   InfoFloat
  hi! link DiagnosticFloatingHint   HintFloat
  hi! link DiagnosticFloatingOk     OkFloat

  hi! link DiagnosticUnderlineError  ErrorHighlight
  hi! link DiagnosticUnderlineWarn   WarningHighlight
  hi! link DiagnosticUnderlineInfo   InfoHighlight
  hi! link DiagnosticUnderlineHint   HintHighlight
  hi! link DiagnosticUnderlineOk     OkHighlight

  hi! link DiagnosticsVirtualTextError    ErrorSign
  hi! link DiagnosticsVirtualTextWarning  WarningSign
  hi! link DiagnosticsVirtualTextInfo     InfoSign
  hi! link DiagnosticsVirtualTextHint     HintSign
  hi! link DiagnosticsVirtualTextOk       OkSign

  " Remove untill endif on next nvim release
  hi! link LspDiagnosticsSignError    ErrorSign
  hi! link LspDiagnosticsSignWarning  WarningSign
  hi! link LspDiagnosticsSignInfo     InfoSign
  hi! link LspDiagnosticsSignHint     HintSign

  hi! link LspDiagnosticsVirtualTextError    ErrorSign
  hi! link LspDiagnosticsVirtualTextWarning  WarningSign
  hi! link LspDiagnosticsVirtualTextInfo     InfoSign
  hi! link LspDiagnosticsVirtualTextHint     HintSign

  hi! link LspDiagnosticsFloatingError    ErrorFloat
  hi! link LspDiagnosticsFloatingWarning  WarningFloat
  hi! link LspDiagnosticsFloatingInfo     InfoFloat
  hi! link LspDiagnosticsFloatingHint     HintFloat

  hi! link LspDiagnosticsUnderlineError    ErrorHighlight
  hi! link LspDiagnosticsUnderlineWarning  WarningHighlight
  hi! link LspDiagnosticsUnderlineInfo     InfoHighlight
  hi! link LspDiagnosticsUnderlineHint     HintHighlight

  hi! link LspReferenceText   ReferenceText
  hi! link LspReferenceRead   ReferenceRead
  hi! link LspReferenceWrite  ReferenceWrite
endif

" "
" LANGUAGES
" "

" C
call <sid>hi("cOperator",   s:gui0C, "", s:cterm0C, "", "", "")
call <sid>hi("cPreCondit",  s:gui0E, "", s:cterm0E, "", "", "")

" C#
call <sid>hi("csClass",                 s:gui0A, "", s:cterm0A, "", "", "")
call <sid>hi("csAttribute",             s:gui0A, "", s:cterm0A, "", "", "")
call <sid>hi("csModifier",              s:gui0E, "", s:cterm0E, "", "", "")
call <sid>hi("csType",                  s:gui08, "", s:cterm08, "", "", "")
call <sid>hi("csUnspecifiedStatement",  s:gui0D, "", s:cterm0D, "", "", "")
call <sid>hi("csContextualStatement",   s:gui0E, "", s:cterm0E, "", "", "")
call <sid>hi("csNewDecleration",        s:gui08, "", s:cterm08, "", "", "")

" Clap
hi! link ClapInput             ColorColumn
hi! link ClapSpinner           ColorColumn
hi! link ClapDisplay           Default
hi! link ClapPreview           ColorColumn
hi! link ClapCurrentSelection  CursorLine
hi! link ClapNoMatchesFound    ErrorFloat

" Coc
hi! link CocErrorSign         ErrorSign
hi! link CocWarningSign       WarningSign
hi! link CocInfoSign          InfoSign
hi! link CocHintSign          HintSign

hi! link CocErrorFloat        ErrorFloat
hi! link CocWarningFloat      WarningFloat
hi! link CocInfoFloat         InfoFloat
hi! link CocHintFloat         HintFloat

hi! link CocErrorHighlight    ErrorHighlight
hi! link CocWarningHighlight  WarningHighlight
hi! link CocInfoHighlight     InfoHighlight
hi! link CocHintHighlight     HintHighlight

hi! link CocSem_angle             Keyword
hi! link CocSem_annotation        Keyword
hi! link CocSem_attribute         Type
hi! link CocSem_bitwise           Keyword
hi! link CocSem_boolean           Boolean
hi! link CocSem_brace             Normal
hi! link CocSem_bracket           Normal
hi! link CocSem_builtinAttribute  Type
hi! link CocSem_builtinType       Type
hi! link CocSem_character         String
hi! link CocSem_class             Structure
hi! link CocSem_colon             Normal
hi! link CocSem_comma             Normal
hi! link CocSem_comment           Comment
hi! link CocSem_comparison        Keyword
hi! link CocSem_concept           Keyword
hi! link CocSem_constParameter    Identifier
hi! link CocSem_dependent         Keyword
hi! link CocSem_dot               Keyword
hi! link CocSem_enum              Structure
hi! link CocSem_enumMember        Constant
hi! link CocSem_escapeSequence    Type
hi! link CocSem_event             Identifier
hi! link CocSem_formatSpecifier   Type
hi! link CocSem_function          Function
hi! link CocSem_interface         Type
hi! link CocSem_keyword           Keyword
hi! link CocSem_label             Keyword
hi! link CocSem_logical           Keyword
hi! link CocSem_macro             Macro
hi! link CocSem_method            Function
hi! link CocSem_modifier          Keyword
hi! link CocSem_namespace         Identifier
hi! link CocSem_number            Number
hi! link CocSem_operator          Operator
hi! link CocSem_parameter         Identifier
hi! link CocSem_parenthesis       Normal
hi! link CocSem_property          Identifier
hi! link CocSem_punctuation       Keyword
hi! link CocSem_regexp            Type
hi! link CocSem_selfKeyword       Constant
hi! link CocSem_semicolon         Normal
hi! link CocSem_string            String
hi! link CocSem_struct            Structure
hi! link CocSem_type              Type
hi! link CocSem_typeAlias         Type
hi! link CocSem_typeParameter     Type
hi! link CocSem_unknown           Normal
hi! link CocSem_variable          Identifier

call <sid>hi("CocHighlightRead",   s:gui0B, s:gui01,  s:cterm0B, s:cterm01, "", "")
call <sid>hi("CocHighlightText",   s:gui0A, s:gui01,  s:cterm0A, s:cterm01, "", "")
call <sid>hi("CocHighlightWrite",  s:gui08, s:gui01,  s:cterm08, s:cterm01, "", "")
call <sid>hi("CocListMode",        s:gui01, s:gui0B,  s:cterm01, s:cterm0B, "bold", "")
call <sid>hi("CocListPath",        s:gui01, s:gui0B,  s:cterm01, s:cterm0B, "", "")
call <sid>hi("CocSessionsName",    s:gui06, "", s:cterm05, "", "", "")

" CSS
hi! link cssBraces               ThemeBlue
hi! link cssFunctionName         ThemeYellow
hi! link cssIdentifier           ThemeOrange
hi! link cssClassName            ThemeGreen
hi! link cssColor                ThemeBlue
hi! link cssSelectorOp           ThemeBlue
hi! link cssSelectorOp2          ThemeBlue
hi! link cssImportant            ThemeGreen
hi! link cssVendor               ThemeFg1

hi! link cssTextProp             ThemeCyan
hi! link cssAnimationProp        ThemeCyan
hi! link cssUIProp               ThemeYellow
hi! link cssTransformProp        ThemeCyan
hi! link cssTransitionProp       ThemeCyan
hi! link cssPrintProp            ThemeCyan
hi! link cssPositioningProp      ThemeYellow
hi! link cssBoxProp              ThemeCyan
hi! link cssFontDescriptorProp   ThemeCyan
hi! link cssFlexibleBoxProp      ThemeCyan
hi! link cssBorderOutlineProp    ThemeCyan
hi! link cssBackgroundProp       ThemeCyan
hi! link cssMarginProp           ThemeCyan
hi! link cssListProp             ThemeCyan
hi! link cssTableProp            ThemeCyan
hi! link cssFontProp             ThemeCyan
hi! link cssPaddingProp          ThemeCyan
hi! link cssDimensionProp        ThemeCyan
hi! link cssRenderProp           ThemeCyan
hi! link cssColorProp            ThemeCyan
hi! link cssGeneratedContentProp ThemeCyan


" CMP
hi! link CmpItemAbbrDeprecated  Deprecated
hi! link CmpItemAbbrMatch       SearchMatch
hi! link CmpItemAbbrMatchFuzzy  SearchMatch
hi! link CmpItemKindClass       Type
hi! link CmpItemKindColor       Keyword
hi! link CmpItemKindConstant    Constant
hi! link CmpItemKindConstructor Special
hi! link CmpItemKindEnum        Type
hi! link CmpItemKindEnumMember  Constant
hi! link CmpItemKindEvent       Identifier
hi! link CmpItemKindField       Character
hi! link CmpItemKindFile        Directory
hi! link CmpItemKindFolder      Directory
hi! link CmpItemKindFunction    Function
hi! link CmpItemKindInterface   Type
hi! link CmpItemKindKeyword     Keyword
hi! link CmpItemKindMethod      Function
hi! link CmpItemKindModule      Namespace
hi! link CmpItemKindOperator    Operator
hi! link CmpItemKindProperty    Identifier
hi! link CmpItemKindReference   Character
hi! link CmpItemKindSnippet     String
hi! link CmpItemKindStruct      Type
hi! link CmpItemKindText        Text
hi! link CmpItemKindUnit        Namespace
hi! link CmpItemKindValue       Comment
hi! link CmpItemKindVariable    Identifier

if has("nvim-0.8.0")
  hi! link CmpItemKindField @field
  hi! link CmpItemKindProperty @property
endif

" Diff
call <sid>hi("DiffAdd",      s:gui0B, s:gui01,  s:cterm0B, s:cterm01, "", "")
call <sid>hi("DiffChange",   s:gui06, s:gui01,  s:cterm05, s:cterm01, "", "")
call <sid>hi("DiffDelete",   s:gui02, s:guibg,  s:cterm02, s:ctermbg, "", "")
call <sid>hi("DiffText",     s:gui0D, s:gui01,  s:cterm0D, s:cterm01, "", "")
call <sid>hi("DiffAdded",    s:gui0B, s:guibg,  s:cterm0B, s:ctermbg, "", "")
call <sid>hi("DiffFile",     s:gui08, s:guibg,  s:cterm08, s:ctermbg, "", "")
call <sid>hi("DiffNewFile",  s:gui0B, s:guibg,  s:cterm0B, s:ctermbg, "", "")
call <sid>hi("DiffLine",     s:gui0D, s:guibg,  s:cterm0D, s:ctermbg, "", "")
call <sid>hi("DiffRemoved",  s:gui08, s:guibg,  s:cterm08, s:ctermbg, "", "")

" Git
call <sid>hi("gitcommitOverflow",       s:gui08, "", s:cterm08, "", "", "")
call <sid>hi("gitcommitSummary",        s:gui0B, "", s:cterm0B, "", "", "")
call <sid>hi("gitcommitComment",        s:gui03, "", s:cterm03, "", "", "")
call <sid>hi("gitcommitUntracked",      s:gui03, "", s:cterm03, "", "", "")
call <sid>hi("gitcommitDiscarded",      s:gui03, "", s:cterm03, "", "", "")
call <sid>hi("gitcommitSelected",       s:gui03, "", s:cterm03, "", "", "")
call <sid>hi("gitcommitHeader",         s:gui0E, "", s:cterm0E, "", "", "")
call <sid>hi("gitcommitSelectedType",   s:gui0D, "", s:cterm0D, "", "", "")
call <sid>hi("gitcommitUnmergedType",   s:gui0D, "", s:cterm0D, "", "", "")
call <sid>hi("gitcommitDiscardedType",  s:gui0D, "", s:cterm0D, "", "", "")
call <sid>hi("gitcommitBranch",         s:gui09, "", s:cterm09, "", "bold", "")
call <sid>hi("gitcommitUntrackedFile",  s:gui0A, "", s:cterm0A, "", "", "")
call <sid>hi("gitcommitUnmergedFile",   s:gui08, "", s:cterm08, "", "bold", "")
call <sid>hi("gitcommitDiscardedFile",  s:gui08, "", s:cterm08, "", "bold", "")
call <sid>hi("gitcommitSelectedFile",   s:gui0B, "", s:cterm0B, "", "bold", "")

" GitGutter
hi! link GitGutterAdd          GitAddSign
hi! link GitGutterChange       GitChangeSign
hi! link GitGutterDelete       GitDeleteSign
hi! link GitGutterChangeDelete GitChangeDeleteSign

" indent-blankline (nvim)
if has("nvim")
  call <sid>hi("@ibl.indent.char.1",s:gui01, "", s:cterm01, "", "", "")
endif

" HTML
call <sid>hi("htmlBold",    s:gui07, "", s:cterm0A, "", "bold", "")
call <sid>hi("htmlItalic",  s:gui06, "", s:cterm0E, "", "italic", "")
call <sid>hi("htmlEndTag",  s:gui06, "", s:cterm05, "", "", "")
call <sid>hi("htmlTag",     s:gui06, "", s:cterm05, "", "", "")

" JavaScript
call <sid>hi("javaScript",        s:gui06, "", s:cterm05, "", "", "")
call <sid>hi("javaScriptBraces",  s:gui06, "", s:cterm05, "", "", "")
call <sid>hi("javaScriptNumber",  s:gui09, "", s:cterm09, "", "", "")
" pangloss/vim-javascript
call <sid>hi("jsOperator",          s:gui0D, "", s:cterm0D, "", "", "")
call <sid>hi("jsStatement",         s:gui0E, "", s:cterm0E, "", "", "")
call <sid>hi("jsReturn",            s:gui0E, "", s:cterm0E, "", "", "")
call <sid>hi("jsThis",              s:gui08, "", s:cterm08, "", "", "")
call <sid>hi("jsClassDefinition",   s:gui0A, "", s:cterm0A, "", "", "")
call <sid>hi("jsFunction",          s:gui0E, "", s:cterm0E, "", "", "")
call <sid>hi("jsFuncName",          s:gui0D, "", s:cterm0D, "", "", "")
call <sid>hi("jsFuncCall",          s:gui0D, "", s:cterm0D, "", "", "")
call <sid>hi("jsClassFuncName",     s:gui0D, "", s:cterm0D, "", "", "")
call <sid>hi("jsClassMethodType",   s:gui0E, "", s:cterm0E, "", "", "")
call <sid>hi("jsRegexpString",      s:gui0C, "", s:cterm0C, "", "", "")
call <sid>hi("jsGlobalObjects",     s:gui0A, "", s:cterm0A, "", "", "")
call <sid>hi("jsGlobalNodeObjects", s:gui0A, "", s:cterm0A, "", "", "")
call <sid>hi("jsExceptions",        s:gui0A, "", s:cterm0A, "", "", "")
call <sid>hi("jsBuiltins",          s:gui0A, "", s:cterm0A, "", "", "")

" Mail
call <sid>hi("mailQuoted1",  s:gui0A, "", s:cterm0A, "", "", "")
call <sid>hi("mailQuoted2",  s:gui0B, "", s:cterm0B, "", "", "")
call <sid>hi("mailQuoted3",  s:gui0E, "", s:cterm0E, "", "", "")
call <sid>hi("mailQuoted4",  s:gui0C, "", s:cterm0C, "", "", "")
call <sid>hi("mailQuoted5",  s:gui0D, "", s:cterm0D, "", "", "")
call <sid>hi("mailQuoted6",  s:gui0A, "", s:cterm0A, "", "", "")
call <sid>hi("mailURL",      s:gui0D, "", s:cterm0D, "", "", "")
call <sid>hi("mailEmail",    s:gui0D, "", s:cterm0D, "", "", "")

" Markdown
call <sid>hi("markdownCode",              s:gui0B, "", s:cterm0B, "", "", "")
call <sid>hi("markdownError",             s:gui06, s:guibg, s:cterm05, s:ctermbg, "", "")
call <sid>hi("markdownCodeBlock",         s:gui0B, "", s:cterm0B, "", "", "")
call <sid>hi("markdownHeadingDelimiter",  s:gui0D, "", s:cterm0D, "", "", "")

" Matchup
call <sid>hi("MatchWord",  s:gui0B, s:gui01,  s:cterm0B, s:cterm01, "underline", "")

" NERDTree
call <sid>hi("NERDTreeDirSlash",  s:gui0D, "", s:cterm0D, "", "", "")
call <sid>hi("NERDTreeExecFile",  s:gui06, "", s:cterm05, "", "", "")

" Netrw
hi! link netrwDir      ThemeCyan
hi! link netrwClassify ThemeCyan
hi! link netrwLink     ThemeBg3
hi! link netrwSymLink  ThemeFg1
hi! link netrwExe      ThemeYellow
hi! link netrwComment  ThemeBg3
hi! link netrwList     ThemeBlue
hi! link netrwHelpCmd  ThemeCyan
hi! link netrwCmdSep   ThemeFg3
hi! link netrwVersion  ThemeGreen

" PHP
call <sid>hi("phpMemberSelector",  s:gui06, "", s:cterm05, "", "", "")
call <sid>hi("phpComparison",      s:gui06, "", s:cterm05, "", "", "")
call <sid>hi("phpParent",          s:gui06, "", s:cterm05, "", "", "")
call <sid>hi("phpMethodsVar",      s:gui0C, "", s:cterm0C, "", "", "")

" Python
"call <sid>hi("pythonOperator",  s:gui0E, "", s:cterm0E, "", "", "")
"call <sid>hi("pythonRepeat",    s:gui0E, "", s:cterm0E, "", "", "")
"call <sid>hi("pythonInclude",   s:gui0E, "", s:cterm0E, "", "", "")
"call <sid>hi("pythonStatement", s:gui0E, "", s:cterm0E, "", "", "")

" hi! link pythonBuiltin     ThemeCyan
" hi! link pythonBuiltinObj  ThemeCyan
" hi! link pythonBuiltinFunc ThemeGreen
" hi! link pythonFunction    Function
" hi! link pythonDecorator     ThemeYellow
" hi! link pythonDecoratorName ThemeYellow
" hi! link pythonTripleQuotes	 ThemeGreenItalic
" hi! link pythonInclude     ThemeBlue
" hi! link pythonImport      ThemeBlue
" hi! link pythonRun         ThemeBlue
" hi! link pythonCoding      ThemeBlue
" hi! link pythonOperator    ThemeRed
" hi! link pythonException   ThemeRed
" hi! link pythonExceptions  ThemeYellow
" hi! link pythonBoolean     ThemeYellow
" hi! link pythonDot         ThemeFg3
" hi! link pythonConditional ThemeCyan
" hi! link pythonRepeat      ThemeRed
" hi! link pythonDottedName  ThemeGreen


" Ruby
call <sid>hi("rubyAttribute",               s:gui0D, "", s:cterm0D, "", "", "")
call <sid>hi("rubyConstant",                s:gui0A, "", s:cterm0A, "", "", "")
call <sid>hi("rubyInterpolationDelimiter",  s:gui0F, "", s:cterm0F, "", "", "")
call <sid>hi("rubyRegexp",                  s:gui0C, "", s:cterm0C, "", "", "")
call <sid>hi("rubySymbol",                  s:gui0B, "", s:cterm0B, "", "", "")
call <sid>hi("rubyStringDelimiter",         s:gui0B, "", s:cterm0B, "", "", "")

" SASS
call <sid>hi("sassidChar",     s:gui08, "", s:cterm08, "", "", "")
call <sid>hi("sassClassChar",  s:gui09, "", s:cterm09, "", "", "")
call <sid>hi("sassInclude",    s:gui0E, "", s:cterm0E, "", "", "")
call <sid>hi("sassMixing",     s:gui0E, "", s:cterm0E, "", "", "")
call <sid>hi("sassMixinName",  s:gui0D, "", s:cterm0D, "", "", "")

" Signify
hi! link SignifySignAdd    GitAddSign
hi! link SignifySignChange GitChangeSign
hi! link SignifySignDelete GitDeleteSign

" Startify
call <sid>hi("StartifyBracket",  s:gui03, "", s:cterm03, "", "", "")
call <sid>hi("StartifyFile",     s:gui07, "", s:cterm07, "", "", "")
call <sid>hi("StartifyFooter",   s:gui03, "", s:cterm03, "", "", "")
call <sid>hi("StartifyHeader",   s:gui0B, "", s:cterm0B, "", "", "")
call <sid>hi("StartifyNumber",   s:gui09, "", s:cterm09, "", "", "")
call <sid>hi("StartifyPath",     s:gui03, "", s:cterm03, "", "", "")
call <sid>hi("StartifySection",  s:gui0E, "", s:cterm0E, "", "", "")
call <sid>hi("StartifySelect",   s:gui0C, "", s:cterm0C, "", "", "")
call <sid>hi("StartifySlash",    s:gui03, "", s:cterm03, "", "", "")
call <sid>hi("StartifySpecial",  s:gui03, "", s:cterm03, "", "", "")

" Java
call <sid>hi("javaOperator", s:gui0D, "", s:cterm0D, "", "", "")

" JSON
hi! link jsonKeyword ThemeGreen
hi! link jsonQuote   ThemeGreen
hi! link jsonBraces  ThemeFg1
hi! link jsonString  ThemeFg1

" Markdown
hi! link markdownH1                ThemeRedBold
hi! link markdownH2                ThemeRed
hi! link markdownH3                ThemeRed
hi! link markdownH4                ThemeRed
hi! link markdownH5                ThemeRed
hi! link markdownH6                ThemeRed

hi! link markdownCode              ThemeYellow
hi! link markdownCodeBlock         ThemeYellow
hi! link markdownCodeDelimiter     ThemeYellow

hi! link markdownBlockquote        ThemeGrey
hi! link markdownListMarker        ThemeBlue
hi! link markdownOrderedListMarker ThemeBlue
hi! link markdownRule              ThemeGrey
hi! link markdownHeadingRule       ThemeGrey

hi! link markdownUrlDelimiter      ThemeFg3
hi! link markdownLinkDelimiter     ThemeFg3
hi! link markdownLinkTextDelimiter ThemeFg3
hi! link markdownHeadingDelimiter  ThemeOrange
hi! link markdownUrlTitleDelimiter ThemeGreen

hi! link markdownLink              ThemeGreen
hi! link markdownWikiLink          ThemeViolet
"hi! link markdownUrl               ThemeOrange
hi! link markdownUrl               ThemeRed
hi! link markdownUrlProtocol       ThemeGreenItalic
hi! link markdownInlineUrl         ThemeOrange

hi! link markdownLinkText          ThemeViolet
hi! link markdownIdDeclaration     markdownLinkText

hi! link pandocAtxHeader           ThemeRed
hi! link pandocAtxStart            ThemeOrange


"call s:HL('markdownItalic', s:fg3, s:none, s:italic)
"call s:HL('markdownLinkText', s:gray, s:none, s:underline)


" Remove functions
delf <sid>hi

" Remove color variables
unlet s:gui00 s:gui01 s:gui02 s:gui03 s:gui04 s:gui05 s:gui06 s:gui07 s:gui08 s:gui09 s:gui0A s:gui0B s:gui0C s:gui0D s:gui0E s:gui0F s:guibg
unlet s:cterm00 s:cterm01 s:cterm02 s:cterm03 s:cterm04 s:cterm05 s:cterm06 s:cterm07 s:cterm08 s:cterm09 s:cterm0A s:cterm0B s:cterm0C s:cterm0D s:cterm0E s:cterm0F s:ctermbg

