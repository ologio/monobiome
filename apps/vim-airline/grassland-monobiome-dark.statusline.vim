" -----------------------------------------------------------------------------
" File: active.vim
" Description: SOLR color scheme for Airline
" Author: samgriesemer <samgriesemer@gmail.com>
" Source: https://github.com/samgriesemer/active
" -----------------------------------------------------------------------------
" -> generated_color_map(s1, s2, s3) will generate colors for the airline suffixes:
"
"    -> _a :: s1
"    -> _b :: s2
"    -> _c :: s3
"    -> _x :: s3
"    -> _y :: s2
"    -> _z :: s1
"
"    It simply generates a dictionary, and below we do this for several modes.

let g:airline#themes#active#palette = {}
let s:gui_bg0 = "#1d2321"
let s:gui_bg1 = "#29302d"
let s:gui_bg2 = "#353c3a"
let s:gui_bg3 = "#424a47"
let s:gui_fg3 = "#a8b0ad"
let s:gui_fg2 = "#b7c0bc"
let s:gui_fg1 = "#c7d0cc"
let s:gui_fg0 = "#d7e0dd"
let s:gui_red = "#e95949"
let s:gui_ora = "#ca791c"
let s:gui_yel = "#989250"
let s:gui_gre = "#5da268"
let s:gui_cya = "#5da268"
let s:gui_blu = "#658ed9"
let s:gui_vio = "#658ed9"
let s:gui_mag = "#e95949"

let s:grey  = "#7a827f"

" Terminal color definitions
let s:cterm00  = 0
let s:cterm01  = 10
let s:cterm02  = 11
let s:cterm03  = 8
let s:cterm04  = 12
let s:cterm05  = 7
let s:cterm06  = 13
let s:cterm07  = 15
let s:cterm08  = 1
let s:cterm09  = 9
let s:cterm0A  = 3
let s:cterm0B  = 2
let s:cterm0C  = 6
let s:cterm0D  = 4
let s:cterm0E  = 5
let s:cterm0F  = 14

let M0 = airline#themes#get_highlight('Title')
let accents_group = airline#themes#get_highlight('Statement')
let modified_group = [M0[0], '', M0[2], '', '']

let warning_group = airline#themes#get_highlight2(['Normal', 'bg'], ['Structure', 'fg'])
"let warning_group = airline#themes#get_highlight2(['Structure', 'fg'], ['Normal', 'bg'])
let error_group = airline#themes#get_highlight2(['Normal', 'bg'], ['WarningMsg', 'fg'])


" status line settings
"            [ guifg      guibg      ctermfg    ctermbg   ]
let s:N1   = [ s:gui_bg0, s:gui_fg3, s:cterm01, s:cterm0B ]
let s:N2   = [ s:gui_fg1, s:gui_bg2, s:cterm06, s:cterm02 ]
let s:N3   = [ s:gui_fg2, s:gui_bg1, s:cterm09, s:cterm01 ]
let g:airline#themes#active#palette.normal = airline#themes#generate_color_map(s:N1, s:N2, s:N3)

let modified_group = [ s:gui_yel, '', s:cterm01, '' ]
let warning_group  = [ s:gui_gre, s:gui_bg1, s:cterm01, s:cterm0B ]
let g:airline#themes#active#palette.normal_modified = { 'airline_c': modified_group }
let g:airline#themes#active#palette.normal.airline_warning          = warning_group
let g:airline#themes#active#palette.normal_modified.airline_warning = warning_group
"let g:airline#themes#active#palette.normal.airline_error            = error_group
"let g:airline#themes#active#palette.normal_modified.airline_error   = error_group


let s:I1   = [ s:gui_bg0, s:gui_gre, s:cterm01, s:cterm0D ]
let s:I2   = [ s:gui_fg1, s:gui_bg2, s:cterm06, s:cterm02 ]
let s:I3   = [ s:gui_fg2, s:gui_bg1, s:cterm09, s:cterm01 ]
let g:airline#themes#active#palette.insert = airline#themes#generate_color_map(s:I1, s:I2, s:I3)

let g:airline#themes#active#palette.insert.airline_warning          = warning_group


let s:R1   = [ s:gui_bg0, s:gui_red, s:cterm01, s:cterm08 ]
let s:R2   = [ s:gui_fg1, s:gui_bg2, s:cterm06, s:cterm02 ]
let s:R3   = [ s:gui_fg2, s:gui_bg1, s:cterm09, s:cterm01 ]
let g:airline#themes#active#palette.replace = airline#themes#generate_color_map(s:R1, s:R2, s:R3)

let g:airline#themes#active#palette.replace.airline_warning          = warning_group


let s:V1   = [ s:gui_bg0, s:gui_yel, s:cterm01, s:cterm0E ]
let s:V2   = [ s:gui_fg1, s:gui_bg2, s:cterm06, s:cterm02 ]
let s:V3   = [ s:gui_fg2, s:gui_bg1, s:cterm09, s:cterm01 ]
let g:airline#themes#active#palette.visual = airline#themes#generate_color_map(s:V1, s:V2, s:V3)

let g:airline#themes#active#palette.visual.airline_warning          = warning_group


let s:IA1   = [ s:gui_fg2, s:gui_bg1, s:cterm05, s:cterm01 ]
let s:IA2   = [ s:gui_fg2, s:gui_bg1, s:cterm05, s:cterm01 ]
let s:IA3   = [ s:gui_fg2, s:gui_bg1, s:cterm05, s:cterm01 ]
let g:airline#themes#active#palette.inactive = airline#themes#generate_color_map(s:IA1, s:IA2, s:IA3)

let g:airline#themes#active#palette.inactive.airline_warning          = warning_group
