" For a config with external plugins, see my neovim config
" Colours are based on my yatt.theme / Yet Another Terminal Theme for xfce4-terminal
set nocompatible
set laststatus=2
filetype off
set wildmenu
set nowrapscan
set backupdir=/tmp//
set directory=/tmp//
set undodir=/tmp//

" Visual
set showmode
syntax on
set number
set relativenumber
set nowrap
set signcolumn=yes
set colorcolumn=81
colorscheme default
highlight SignColumn ctermbg=NONE
highlight ColorColumn ctermbg=black
highlight Comment ctermfg=darkgreen
highlight string ctermfg=darkred
highlight Function ctermfg=darkmagenta
highlight Conditional ctermfg=darkmagenta
highlight Normal ctermfg=white ctermbg=black
highlight StatusLine ctermfg=black ctermbg=gray
highlight Boolean ctermfg=darkblue
highlight Statement ctermfg=darkblue
highlight LineNr ctermfg=darkgray
highlight Number ctermfg=lightblue
augroup mode-indicator
    autocmd!
    autocmd InsertEnter * highlight ColorColumn ctermbg=darkgray ctermfg=white
    autocmd InsertLeave * highlight ColorColumn ctermbg=NONE ctermfg=NONE
    autocmd InsertEnter * highlight StatusLine ctermbg=green
    autocmd InsertLeave * highlight StatusLine ctermbg=gray
    autocmd InsertEnter * highlight LineNr ctermfg=white
    autocmd InsertLeave * highlight LineNr ctermfg=darkgray
augroup END

" Indenting
set shiftwidth=4
set tabstop=4
set softtabstop=-1
set noexpandtab
set autoindent

" Leader
let mapleader = " "

" Copy and paste (works fine on x11 but not on wayland)
nnoremap <C-c> "+yy
inoremap <C-c> <Esc>"+yya
vnoremap <C-c> "+y
nnoremap <C-p> "+p
inoremap <C-p> <Esc>"+pa
vnoremap <C-p> d"+p

" Unbind command history
nnoremap q: <nop>
nnoremap Q <nop>

" Fix awkward keybinds on nordic layout (although I usually just swap to US layout)
vnoremap ¤ $
nnoremap ¤ $
inoremap ¤ $
nnoremap § @
inoremap § @
inoremap å `
inoremap Å \
inoremap ä ]
inoremap Ä }
inoremap ö [
inoremap Ö {
nnoremap Ä }
nnoremap Ö {
" ...and still have access to Å/Ä/Ö
inoremap <C-å> å
inoremap <C-ä> ä
inoremap <C-ö> ö

" Tabs and buffers
nnoremap <leader>n :tabnew<CR>
nnoremap <leader>q :bd<CR>
nnoremap <leader>tq :bd!<CR>
nnoremap <leader>1 :tabn1<CR>
nnoremap <leader>2 :tabn2<CR>
nnoremap <leader>3 :tabn3<CR>
nnoremap <leader>4 :tabn4<CR>
nnoremap <leader>5 :tabn5<CR>
nnoremap <leader>6 :tabn6<CR>
nnoremap <leader>7 :tabn7<CR>
nnoremap <leader>8 :tabn8<CR>
nnoremap <leader>9 :tabn9<CR>
nnoremap <leader>0 :tabn10<CR>

" Snippets
nnoremap <leader>jsd o/**<cr> * Description<cr>* @param {}  - <cr>*/<Esc>kklviw
nnoremap <leader>html i<!DOCTYPE html><cr><html lang="en"><cr>	<head><cr>	<meta charset="UTF-8"><cr><meta name="viewport" content="width=device-width, initial-scale=1"><cr><title>Webpage</title><cr><link rel="icon" href="assets/images/favicon.png"><cr><link href="style/main.css" rel="stylesheet"><cr><script src="scripts/main.js" defer></script><cr><BS></head><cr><body><cr>	<header><cr></header><cr><cr><main><cr></main><cr><cr><footer><cr></footer><cr><cr><script><cr>	// Inline script<cr><BS></script><cr><BS></body><cr><BS></html><Esc>gg

" Auto-complete
inoremap <C-h> <C-n><C-p>
inoremap <C-j> <C-n>
inoremap <C-k> <C-p>

" Terminal
nnoremap <leader>t :tabnew<CR>:terminal<CR>
tnoremap <Esc> <C-\><C-n>
tnoremap <C-q> <C-\><C-n>:bd!<CR>:bd<CR>

" File explorer
nnoremap <leader>fs :Explore<CR>


" Strip trailing spaces
augroup strip-trailing
    autocmd!
    autocmd BufWritePre * call StripTrailing()
augroup END

function! StripTrailing()
    :silent! %s/ \+\n/\r/g
    :silent! %s/\t\+\n/\r/g
endfunction


" VCDiff
augroup vc-diff
    autocmd!
    autocmd InsertLeave * call VCDiff()
    autocmd InsertEnter * call sign_unplace("vcDiffs")
    " or you might prefer:
    "autocmd TextChangedI * call VCDiff()
    autocmd TextChanged * call VCDiff()
augroup END

highlight diffAdd ctermfg=green ctermbg=NONE
highlight diffDel ctermfg=red ctermbg=NONE
highlight diffChg ctermfg=yellow ctermbg=NONE
highlight diffDCh ctermfg=brown ctermbg=NONE
call sign_define([{"name" : "vcAdd", "numhl" : "diffAdd"}, {"name" : "vcDel", "numhl" : "diffDel"}, {"name" : "vcChg", "numhl" : "diffChg"}, {"name" : "vcDCh", "numhl" : "diffDCh"}])

function! VCDiff()
    let vcRoot = "NONE"
    let vcSystem = "RCS"

    " RCS
    if filereadable(expand("%:p")..",v")
        let vcRoot = expand("%:p:h")
    endif
    if filereadable(expand("%:p:h").."/RCS/"..expand("%:t:r").."."..expand("%:e")..",v")
        let vcRoot = expand("%:p:h").."/RCS/"
    endif

    " GIT / Mercurial
    const fullPath = expand("%:p")
    const filePath = split(fullPath, "/")
    let searchPath = "/"
	if vcRoot == "NONE"
		for directory in filePath
			let searchPath = searchPath..directory.."/"
			if isdirectory(searchPath..".git/")
				let vcRoot = searchPath
				let vcSystem = "GIT"
				let relPath = split(fullPath, searchPath)[0]
			elseif isdirectory(searchPath..".hg/")
				let vcRoot = searchPath
				let vcSystem = "HG"
				let relPath = split(fullPath, searchPath)[0]
			endif
		endfor
	endif

    if vcRoot != "NONE"
        let vcDiff = ""
		silent! w! /tmp/VimVCDiff
		if vcSystem == "GIT"
			let vcDiff = system("cd "..vcRoot.." && git show $(git rev-parse --abbrev-ref HEAD):"..relPath.." | diff -U 0 - /tmp/VimVCDiff")
		elseif vcSystem == "HG"
			let vcDiff = system("cd "..vcRoot.." && hg cat "..relPath.." | diff -U 0 - /tmp/VimVCDiff")
		elseif vcSystem == "RCS"
			let vcDiff = system("cd "..vcRoot.." && co -p "..expand("%:t:r").."."..expand("%:e").." | diff -U 0 - /tmp/VimVCDiff")
		endif
		call system("rm -rf /tmp/VimVCDiff")
        const vcHunks = split(vcDiff, "@@")
        let counter = 0
        call sign_unplace("vcDiffs")
        for hunk in vcHunks
            let counter = counter+1
            if counter%2 == 0
                let before = split(split(split(hunk, " ")[0], "-")[0], ",")
                let after = split(split(split(hunk, " ")[1], "+")[0], ",")
                if len(before) == 2 && before[1] == "0"
                    let vimSign = "vcAdd"
                elseif len(after) == 2 && after[1] == "0"
                    let vimSign = "vcDel"
                elseif len(before) == 2 && len(after) == 1
                    let vimSign = "vcDCh"
                else
                   let vimSign = "vcChg"
                endif
                if len(after) == 2 && after[1] != "0"
                    for i in range(after[0], after[0]+after[1]-1, 1)
                        call sign_place(0, "vcDiffs", vimSign, bufname("%"), {"lnum" : i})
                    endfor
                elseif after[0] == "0"
                    call sign_place(0, "vcDiffs", vimSign, bufname("%"), {"lnum" : 1})
                else
                    call sign_place(0, "vcDiffs", vimSign, bufname("%"), {"lnum" : after[0]})
                endif
            endif
        endfor
    endif
endfunction


" RicherSyntax
highlight symbolColour ctermfg=darkyellow
highlight altColour ctermfg=darkcyan

augroup richer-syntax
    autocmd!
    autocmd VimEnter *.* call RicherSyntax()
    autocmd BufAdd *.* call RicherSyntax()
augroup END

function! RicherSyntax()
    call clearmatches()
    call matchadd('altColour', '\.[A-Za-z]\+')
    call matchadd('altColour', '[A-Za-z]\+(')
    call matchadd('symbolColour', '[^A-Za-z0-9]\+')
    call matchadd('Number', '[0-9]')
endfunction

" Language-specific syntax

" JavaScript
augroup javascript-syntax
    autocmd!
    autocmd VimEnter *.js call JavaScriptSyntax()
    autocmd BufAdd *.js call JavaScriptSyntax()
augroup END

function! JavaScriptSyntax()
    call matchadd('Function', '\<Date\>\|\<function\>\|\<return\>\|\<for\>\|\<forEach\>')
    call matchadd('Statement', '\<let\>')
    call matchadd('string', '"[^"]\+"')
    call matchadd('string', '`[^`]\+`')
    call matchadd('Function', '\${[^\$]\+\}')
    call matchadd('Comment', '// .\+\n')
endfunction

" Lua
augroup lua-syntax
    autocmd!
    autocmd VimEnter *.lua call LuaSyntax()
    autocmd BufAdd *.lua call LuaSyntax()
augroup END

function! LuaSyntax()
    call matchadd('Function', '\<for\>\|\<in\>\|\<while\>\|\<do\>\|\<end\>\|\<and\>\|\<or\>')
    call matchadd('Statement', '\<true\>\|\<false\>')
    call matchadd('string', '"[^"]\+"')
    call matchadd('Comment', '--.\+\n')
endfunction

" Python
augroup py-syntax
    autocmd!
    autocmd VimEnter *.py call PythonSyntax()
    autocmd BufAdd *.py call PythonSyntax()
augroup END

function! PythonSyntax()
    call matchadd('Function', '\<def\>\|\<try\>\|\<except\>\|\<in\>\|\<as\>\|\<for\>\|\<with\>\|\<while\>')
    call matchadd('Statement', '\<True\>\|\<False\>')
    call matchadd('string', '"[^"]\+"')
    call matchadd('Comment', '#.\+\n')
endfunction

" Papyrus
augroup papyrus-syntax
    autocmd!
    autocmd VimEnter *.psc call PapyrusSyntax()
    autocmd BufAdd *.psc call PapyrusSyntax()
augroup END

function! PapyrusSyntax()
	call matchadd('Function', '\<scriptname\>\|\<extends\>\|\<return\>\|\<global\>\|\<hidden\>\|\<event\>\|\<function\>\|\<if\>\|\<else\>\|\<elseif\>\|\<endevent\>\|\<endfunction\>\|\<endif\>\|\<true\>\|\<false\>\|\<import\>\|\<property\>\c')
    call matchadd('Statement', '\<bool\>\|\<int\>\|\<float\>\|\<string\>\|\<actor\>\|\<form\>\|\<utility\>\|\<objectreference\>\|\<projectile\>\|\<auto\>\c')
    call matchadd('string', '"[^"]\+"')
    call matchadd('Comment', ';.\+\n')
endfunction
