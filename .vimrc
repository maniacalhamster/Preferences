" ~/.vimrc
" 
" Personal Preferences for vim on Windows 10 
" Thu Oct 22, 2020

set rtp+=~/.vim					"Add .vim directory to runntimepath

set cc=80						"Colored Column at col 88 for guideline
set nu							"Line numbering on
set ru							"Shows which line you're on

set ai							"Autoindent on
set ci							"Support C autoindenting of braces, etc.
set sm							"Shows current mode (Insert, Replace, Visual, etc.
set fo+=r						"Supports continuing * in C block comments

"Optional ftplugin.vim and indent.vim specifications can be used
filetype plugin indent on	
set ts=4						"tabstop sets # columsn per TAB symbol
set sw=4						"shiftwidth sets # columns per reindent (>> <<) and auto C-style indents
"set expandtab					"TABS in insert mode will generate spaces if prefered

set nowrap						"No line wrapping! It's hard to read!
set backspace=indent,eol,start	"Backspace will now work like you're used to
set showmatch					"Check matching delims () {} []
set nojoinspaces				"No white space after .?! when using (J)oin

syntax on						"Syntax highlighting on
color onedark					"Modded version of onedark.vim personally used for colorscheme
set t_ut=						"Fix BCE to allow consistent colorscheme background

set foldmethod=syntax			"Automatically creates folds based off syntax
set foldlevel=2					"Files open with only foldlevels of 2+ closed
" Mapping spacebar to (recursively if needed) toggle folds encountered
nnoremap <silent><space> za

set incsearch					"Enables incremental searching
set hlsearch					"Enables search highlighting
" Ctrl-L remapped to clear highlighting along with redrawing screen
nnoremap <C-L> :nohl <CR><C-L>

" Switching between many opened files mapped to Ctrl-J/Ctrl-K
nnoremap <C-J> :next <CR>		
nnoremap <C-K> :prev <CR>

" Splitting vim windows made easier with Ctrl-A (like screen!)
nnoremap <C-A>\| :vs<CR>
nnoremap <C-A><C-s> :sp<CR>
nnoremap <C-A><C-Q> :on<CR>

" Moving around split screens with Ctrl-A Ctrl-HJKL
nnoremap <C-A><C-H> :wincmd h<CR>
nnoremap <C-A><C-L> :wincmd l<CR>
nnoremap <C-A><C-j> :wincmd j<CR>
nnoremap <C-A><C-k> :wincmd k<CR>
