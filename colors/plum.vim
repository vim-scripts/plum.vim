" 
" File: plum.vim
" Description: Dark colorscheme
" Mantainer: Giacomo Comitti - https://github.com/gcmt
" Url: https://github.com/gcmt/vim-plum-colorscheme
" License: MIT
" Version: 0.1
" Last Changed: 15 Jul /2013
"
" 

" Colors

let s:foreground = "6d6d97"
let s:background = "000116"

let s:darkerfg = "44486a"
let s:lighterbg = "15161f"
let s:verylighterbg = "26283a"

let s:purple = "8957aa"
let s:darkpurple = "4b2b5c"
let s:blue = "345399"
let s:greishblue = "3a3c68"
let s:aqua = "2f6f7a"
let s:red = "8e3737"
let s:lightred = "ff6155"
let s:orange = "965E61"
let s:grey = "707070"
let s:pink = "902e67"
let s:darkpink = "570e39"
let s:green = "1d704a"
let s:lightblue = "b5d5ff"
let s:lightgrey = "cccccc"


set background=dark
hi clear
syntax reset

let g:colors_name = "plum"


if has("gui_running") || &t_Co == 88 || &t_Co == 256

    " Color conversion functions {{{

	" Returns an approximate grey index for the given grey level
	fun <SID>grey_number(x)  " {{{
		if &t_Co == 88
			if a:x < 23
				return 0
			elseif a:x < 69
				return 1
			elseif a:x < 103
				return 2
			elseif a:x < 127
				return 3
			elseif a:x < 150
				return 4
			elseif a:x < 173
				return 5
			elseif a:x < 196
				return 6
			elseif a:x < 219
				return 7
			elseif a:x < 243
				return 8
			else
				return 9
			endif
		else
			if a:x < 14
				return 0
			else
				let l:n = (a:x - 8) / 10
				let l:m = (a:x - 8) % 10
				if l:m < 5
					return l:n
				else
					return l:n + 1
				endif
			endif
		endif
	endfun  " }}}

	" Returns the actual grey level represented by the grey index
	fun <SID>grey_level(n)  " {{{
		if &t_Co == 88
			if a:n == 0
				return 0
			elseif a:n == 1
				return 46
			elseif a:n == 2
				return 92
			elseif a:n == 3
				return 115
			elseif a:n == 4
				return 139
			elseif a:n == 5
				return 162
			elseif a:n == 6
				return 185
			elseif a:n == 7
				return 208
			elseif a:n == 8
				return 231
			else
				return 255
			endif
		else
			if a:n == 0
				return 0
			else
				return 8 + (a:n * 10)
			endif
		endif
	endfun  " }}}

	" Returns the palette index for the given grey index
	fun <SID>grey_colour(n)  " {{{
		if &t_Co == 88
			if a:n == 0
				return 16
			elseif a:n == 9
				return 79
			else
				return 79 + a:n
			endif
		else
			if a:n == 0
				return 16
			elseif a:n == 25
				return 231
			else
				return 231 + a:n
			endif
		endif
	endfun  " }}}

	" Returns an approximate colour index for the given colour level
	fun <SID>rgb_number(x)  " {{{
		if &t_Co == 88
			if a:x < 69
				return 0
			elseif a:x < 172
				return 1
			elseif a:x < 230
				return 2
			else
				return 3
			endif
		else
			if a:x < 75
				return 0
			else
				let l:n = (a:x - 55) / 40
				let l:m = (a:x - 55) % 40
				if l:m < 20
					return l:n
				else
					return l:n + 1
				endif
			endif
		endif
	endfun  " }}}

	" Returns the actual colour level for the given colour index
	fun <SID>rgb_level(n)  " {{{
		if &t_Co == 88
			if a:n == 0
				return 0
			elseif a:n == 1
				return 139
			elseif a:n == 2
				return 205
			else
				return 255
			endif
		else
			if a:n == 0
				return 0
			else
				return 55 + (a:n * 40)
			endif
		endif
	endfun  " }}}

	" Returns the palette index for the given R/G/B colour indices
	fun <SID>rgb_colour(x, y, z)  " {{{
		if &t_Co == 88
			return 16 + (a:x * 16) + (a:y * 4) + a:z
		else
			return 16 + (a:x * 36) + (a:y * 6) + a:z
		endif
	endfun  " }}}

	" Returns the palette index to approximate the given R/G/B colour levels
	fun <SID>colour(r, g, b)  " {{{
		" Get the closest grey
		let l:gx = <SID>grey_number(a:r)
		let l:gy = <SID>grey_number(a:g)
		let l:gz = <SID>grey_number(a:b)

		" Get the closest colour
		let l:x = <SID>rgb_number(a:r)
		let l:y = <SID>rgb_number(a:g)
		let l:z = <SID>rgb_number(a:b)

		if l:gx == l:gy && l:gy == l:gz
			" There are two possibilities
			let l:dgr = <SID>grey_level(l:gx) - a:r
			let l:dgg = <SID>grey_level(l:gy) - a:g
			let l:dgb = <SID>grey_level(l:gz) - a:b
			let l:dgrey = (l:dgr * l:dgr) + (l:dgg * l:dgg) + (l:dgb * l:dgb)
			let l:dr = <SID>rgb_level(l:gx) - a:r
			let l:dg = <SID>rgb_level(l:gy) - a:g
			let l:db = <SID>rgb_level(l:gz) - a:b
			let l:drgb = (l:dr * l:dr) + (l:dg * l:dg) + (l:db * l:db)
			if l:dgrey < l:drgb
				" Use the grey
				return <SID>grey_colour(l:gx)
			else
				" Use the colour
				return <SID>rgb_colour(l:x, l:y, l:z)
			endif
		else
			" Only one possibility
			return <SID>rgb_colour(l:x, l:y, l:z)
		endif
	endfun  " }}}

	" Returns the palette index to approximate the 'rrggbb' hex string
	fun <SID>rgb(rgb)  " {{{
		let l:r = ("0x" . strpart(a:rgb, 0, 2)) + 0
		let l:g = ("0x" . strpart(a:rgb, 2, 2)) + 0
		let l:b = ("0x" . strpart(a:rgb, 4, 2)) + 0

		return <SID>colour(l:r, l:g, l:b)
	endfun  " }}}

	" Sets the highlighting for the given group
	fun <SID>X(group, fg, bg, attr)  " {{{
		if a:fg != ""
			exec "hi " . a:group . " guifg=#" . a:fg . " ctermfg=" . <SID>rgb(a:fg)
		endif
		if a:bg != ""
			exec "hi " . a:group . " guibg=#" . a:bg . " ctermbg=" . <SID>rgb(a:bg)
		endif
		if a:attr != ""
			exec "hi " . a:group . " gui=" . a:attr . " cterm=" . a:attr
		endif
	endfun  " }}}

    " }}}

	" Vim Highlighting
	call <SID>X("Normal", s:foreground, s:background, "")
    highlight LineNr term=bold cterm=NONE ctermfg=DarkGrey ctermbg=NONE gui=NONE guifg=#2c2d4f guibg=NONE
	call <SID>X("NonText", s:blue, "", "")
	call <SID>X("SpecialKey", s:verylighterbg, "", "")
	call <SID>X("Search", "", s:lightred, "")
	call <SID>X("IncSearch", s:lightred, s:foreground, "")
	call <SID>X("StatusLine", s:pink, s:lighterbg, "none")
	call <SID>X("StatusLineNC", s:lighterbg, s:greishblue, "")
    call <SID>X("StlErr", s:blue, s:lighterbg, "")
	call <SID>X("StlFname", s:pink, s:lighterbg, "bold")
	call <SID>X("VertSplit", s:verylighterbg, s:background, "none")
	call <SID>X("Visual", "", s:verylighterbg, "")
	call <SID>X("MatchParen", "", s:verylighterbg, "")
	call <SID>X("Directory", s:greishblue, "", "")
	call <SID>X("Folded", s:darkerfg, s:background, "")
	call <SID>X("FoldColumn", "", s:background, "")
	call <SID>X("ModeMsg", s:pink, "", "")
	call <SID>X("MoreMsg", s:pink, "", "")
	call <SID>X("Question", s:aqua, "", "")
	call <SID>X("Cursor", s:background, s:aqua, "")
	call <SID>X("WarningMsg", s:pink, s:background, "")
	call <SID>X("ErrorMsg", s:pink, s:background, "")
	call <SID>X("WildMenu", s:purple, s:verylighterbg, "")
	call <SID>X("SignColumn", "", s:background, "")
	call <SID>X("SignErr", s:red, s:background, "")
	call <SID>X("SignWrn", s:orange, s:background, "")
	if version >= 700
		call <SID>X("CursorLine", "", s:lighterbg, "none")
		call <SID>X("CursorColumn", "", s:lighterbg, "none")
		call <SID>X("PMenu", s:blue, s:lightblue, "none")
		call <SID>X("PMenuSel", s:lightblue, s:blue, "none")
		call <SID>X("PMenuSBar", s:grey, s:grey, "none")
		call <SID>X("PMenuThumb", s:grey, s:lightgrey, "none")
		call <SID>X("TabLine", s:foreground, s:verylighterbg, "none")
		call <SID>X("TabLineSel", s:background, s:lightblue, "none")
		call <SID>X("TabLineFill", s:lightgrey, s:verylighterbg,"none")
    end
	if version >= 703
		call <SID>X("ColorColumn", "", s:lighterbg, "none")
		call <SID>X("Conceal", s:verylighterbg, "", "")
	end

	" Standard Language Highlighting
	call <SID>X("Comment", s:greishblue, "", "")
	call <SID>X("Todo", s:blue, s:verylighterbg, "")
	call <SID>X("Statement", s:blue, "", "none")
	call <SID>X("Identifier", s:foreground, "", "none")
	call <SID>X("Conditional", s:purple, "", "")
	call <SID>X("Repeat", s:orange, "", "")
	call <SID>X("Function", s:blue, "", "")
	call <SID>X("Constant", s:grey, "", "")
	call <SID>X("Number", s:grey, "", "")
	call <SID>X("Boolean", s:grey, "", "")
	call <SID>X("String", s:darkpurple, "", "")
	call <SID>X("Character", s:darkpurple, "", "")
	call <SID>X("Operator", s:aqua, "", "none")
	call <SID>X("Type", s:aqua, "", "none")
	call <SID>X("Exception", s:pink, "", "")
	call <SID>X("Keyword", s:foreground, "", "")
	call <SID>X("Title", s:foreground, "", "bold")
	call <SID>X("Structure", s:foreground, "", "")
	call <SID>X("Special", s:darkerfg, "", "")
	call <SID>X("PreProc", s:foreground, "", "")
	call <SID>X("Define", s:darkerfg, "", "none")
	call <SID>X("Include", s:darkerfg, "", "")

	" Python Highlighting
    call <SID>X("pythonFunction", s:foreground, "", "")
	call <SID>X("pythonPreCondit", s:darkerfg, "", "")
	call <SID>X("pythonSelf", s:darkerfg, "", "")
	call <SID>X("pythonDottedName", s:darkerfg, "", "")

	" Go Highlighting
	call <SID>X("goDirective", s:greishblue, "", "")
	call <SID>X("goGoroutine", s:pink, "", "")
	call <SID>X("goSpecial", s:greishblue, "", "")
	call <SID>X("goFunction", s:foreground, "", "underline")

	" Vim Highlighting
	call <SID>X("vimCommand", s:blue, "", "none")
	call <SID>X("vimFuncname", s:foreground, "", "none")

	" Java Highlighting
	call <SID>X("javaTypeDef", s:darkerfg, "", "")
	call <SID>X("javaOperator", s:pink, "", "")
	call <SID>X("javaClassDecl", s:blue, "", "")
	call <SID>X("javaStorageClass", s:blue, "", "")

	" JavaScript Highlighting
	call <SID>X("javaScriptBraces", s:darkerfg, "", "")
	call <SID>X("javaScriptIdentifier", s:darkerfg, "", "")
	call <SID>X("javaScriptLabel", s:purple, "", "")
	call <SID>X("javaScriptMember", s:darkerfg, "", "")
	call <SID>X("javaScriptGlobal", s:darkerfg, "", "")
	call <SID>X("javaScriptReserver", s:blue, "", "")
	call <SID>X("javaScriptNull", s:grey, "", "")
	call <SID>X("javaScriptType", s:foreground, "", "")
	call <SID>X("javaScriptNumber", s:grey, "", "")

	" HTML Highlighting
	call <SID>X("htmlTag", s:greishblue, "", "")
	call <SID>X("htmlEndTag", s:greishblue, "", "")
	call <SID>X("htmlTagName", s:blue, "", "")
	call <SID>X("htmlArg", s:greishblue, "", "")
	call <SID>X("htmlScriptTag", s:blue, "", "")

    " Markdown Highlighting
	call <SID>X("markdownListMarker", s:aqua, "", "")
	call <SID>X("markdownCode", s:greishblue, "", "")
	call <SID>X("markdownBold", s:darkerfg, "", "bold")
	call <SID>X("markdownBlockquote", s:darkerfg, "", "")

	" Diff Highlighting
	call <SID>X("diffAdded", s:green, "", "")
	call <SID>X("diffRemoved", s:red, "", "")

	" Delete Functions {{{
	delf <SID>X
	delf <SID>rgb
	delf <SID>colour
	delf <SID>rgb_colour
	delf <SID>rgb_level
	delf <SID>rgb_number
	delf <SID>grey_colour
	delf <SID>grey_level
	delf <SID>grey_number
    " }}}
endif
