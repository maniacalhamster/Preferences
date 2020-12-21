" ~/.vimrc
"
" Personal Preferences for vim on Windows 10 + Ubuntu Servers (VMs and school)
" Sat Dec 20, 2020
set rtp+=~/.vim		                " Add .vim directory to runtimepath
set pythonthreedll=python39.dll     " Set Python3dll to be used
set encoding=utf-8                  " Set vim to use utf-8 encoding

" Required for Vundle =========================================================
set nocompatible                    " No strict compatability w/ vi (cool stuff)
filetype off                        " Temporary?        -Required for Vundle
set rtp+=~/.vim/bundle/Vundle.vim

call vundle#begin('~/.vim/bundle')	" Add plugins between vundle# begin and end

" Vundle Plugin Manager installed using Vundle          -Required for Vundle
" Onedark Color/Theme   installed using Vundle
" YouCompleteMe Plugin  installed using Vundle
Plugin 'VundleVim/Vundle.vim'		
Plugin 'joshdick/onedark.vim'
Plugin 'ycm-core/YouCompleteMe'

call vundle#end()
filetype plugin indent on		    " Turn on plugin?   - Required for Vundle

" Brief help
" :PluginList		- lists configured plugins
" :PluginInstall	- installs plugins; append '!' to do (:PluginUpdate)
" :PluginSearch foo	- searches for foo; append '!' to refresh local cache
" :PluginClean		- confirms unused plugins removed; '!' auto approves
"
" :h vundle for more details
" End of Vundle Requirements ==================================================

set colorcolumn=80			" Colored column guideline at col 80
set number					" Line numbering on
set ruler					" Shows which line, col position

set autoindent				" Autoindent on
set cindent					" Support for C autoindenting
set showmode				" Show mode (Ins, Rep, Vis, etc.)
set formatoptions+=r		" Support continuing * in C block comments

set tabstop=4				" Tabstop affects TAB symbols (manual Tabs)
set shiftwidth=4			" Shiftwidth affects reindent (<< >>) & C autoindent
" set expandtab				" Tab replaced with spaces if you're into that...

set nowrap					" No line wrapping - ugly with line numbering
set backspace=indent,eol,start		" Makes backspace work like normal
set showmatch				" Shows matching delims () {} []j
set nojoinspaces			" No whitespaces after .?! using (J)oin

syntax on					" Syntax highlighting on
color onedark				" preferred colorscheme here

set noswapfile				" Replace swapfile with persistent undo
set nowritebackup			" No need for writebackup with persistent undo 
set undodir=~/.vim/undodir	" Directory for undofiles specified
set undofile				" Persistent undo enabled

set foldmethod=syntax		" Automatic fold creation from syntax
set foldlevel=2				" Auto fold anything lvl2 and beyond with ^ method

set scroll=1				" vertical scroll by 1s
set scrolloff=8				" vertical scroll offset at 8
set sidescroll=1			" horizontal scroll by 1s
set sidescrolloff=15		" horizontal scroll offset at 15

" Mapping spacebar to (recursively if needed) toggle folds encountered
nnoremap <silent><space> za

set incsearch				" Enable incremental searching (substrings)
set hlsearch				" Enable search highlighting

" Ctrl-L adding clear highlighting functionality on top of screen redraw
nnoremap <C-L> :nohl <CR><C-L>

" Drawing much inspiration from GNU screen, the wombo combo of tabs + windows
" make for a pretty god-tier editing environment with the right hotkeys;
" This is my personal setup
" =============================================================================
" Opening a new tab made easy with a mapping to Ctrl-A Ctrl-N (like GNU screen)
" Switching between opened vim tabs mapped to Ctrl-J/Ctrl-K
nnoremap <C-A><C-N> :tabe 
nnoremap <C-K> :tabn <CR>
nnoremap <C-J> :tabp <CR>

" Splitting vim windows mapped with Ctrl-A key combos (like GNU screen!)
" Need to remap substitute line and Ex-Mode to <Nop> for these
nnoremap <C-A>\| :vs <CR>
nnoremap <S-S> <Nop>
nnoremap <C-A><S-S> :sp<CR>
nnoremap <S-Q> <Nop>
nnoremap <C-A><S-Q> :on<CR>

" Moving around split screens with Ctrl-A Ctrl-HJKL (again like GNU screen!)
nnoremap <C-A><C-H> :wincmd h<CR>
nnoremap <C-A><C-L> :wincmd l<CR>
nnoremap <C-A><C-J> :wincmd j<CR>
nnoremap <C-A><C-K> :wincmd k<CR>
" =============================================================================
" ^^ Alongside YouCompleteMe, vim is best IDE
