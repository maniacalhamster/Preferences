" Personal Preferences for vim on Windows 10 + Ubuntu Servers (VMs and school)
" Tue July 6, 2021

set rtp+=~/.vim                     " Add .vim directory to runtime path
set encoding=utf-8                  " Set vim to use utf-8 encoding

" Required for Vundle =========================================================
set nocompatible                    " No strict compatibility w/ vi (cool stuff)
filetype off                        " Temporary?        -Required for Vundle
set rtp+=~/.vim/bundle/Vundle.vim

call vundle#begin('~/.vim/bundle')  " Add plugins between Vundle# begin and end

" Vundle Plugin Manager installed using Vundle          -Required for Vundle
" Onedark Color/Theme   installed using Vundle
" pscript syntax plugin installed using Vundle
" YouCompleteMe Plugin  installed using Vundle
" LaTeX plugin          installed using Vundle
Plugin 'VundleVim/Vundle.vim'  
Plugin 'joshdick/onedark.vim'
Plugin 'pprovost/vim-ps1'
Plugin 'ycm-core/YouCompleteMe'
Plugin 'lervag/vimtex'

call vundle#end()
filetype plugin indent on           " Turn on plugin?   - Required for Vundle

" Brief help
" :PluginList  - lists configured plugins
" :PluginInstall - installs plugins; append '!' to do (:Plugin Update)
" :PluginSearch foo - searches for foo; append '!' to refresh local cache
" :PluginClean  - confirms unused plugins removed; '!' auto approves
"
" :h Vundle for more details
" End of Vundle Requirements ==================================================

" Border info options (e.g. Gutter, Info bar, ColorColumn)
set colorcolumn=80                  " Colored column guideline at col 80
set number                          " Line numbering on
set ruler                           " Shows which line, col position
set showmode                        " Show mode (Ins, Rep, Vis, etc.)

" Indentation options
set autoindent                      " Autoindent on
set cindent                         " Support for C autoindenting
set formatoptions+=r                " Support continuing * in C block comments

" Tab options
set tabstop=4                       " affects TAB symbols (manual Tabs)
set shiftwidth=4                    " affects reindent (<< >>) and C autoindent
set expandtab                       " Replace tabs with spaces - universal supp

" Line wrapping options
set nowrap                          " No line wrapping - ugly w/ line numbering

" set wrap                          
" nmap j gj                         " Mappings for more natural line movement
" nmap k gk                         " In the odd chance I do want line wrapping

" Coloring options
syntax on                           " Syntax highlighting on
color onedark                       " preferred colorscheme here

" Spelling options
" set spell                           " Spellcheck on
" set spelllang=en_us                 " Specify language as English (US)
" set spellfile=~/.vim/spell/en.utf-8.add     " Specify location of 'dictionary'

" Adding autocorrect last spelling error to Ctrl-L on top of screen redraw in 
" Insert mode. Will return to editing afterwards (and undo-able with u)
" inoremap <C-l> <c-g>u<Esc>[s1z=<C-o>$a<c-g>u

" File backup options
set noswapfile                      " Got version control for that
" set directory=~/.vim/.swp//         " Directory for swap files specified (if wwanted)
set undodir=~/.vim/undodir          " Directory for undofiles specified
set undofile                        " Persistent undo enabled

" Scroll options
set scroll=1                        " vertical scroll by 1s
set scrolloff=8                     " vertical scroll offset at 8
set sidescroll=1                    " horizontal scroll by 1s
set sidescrolloff=15                " horizontal scroll offset at 15

" Fold options
set foldmethod=syntax               " Automatic fold creation from syntax
set foldlevel=2                     " Auto fold lvl 2 and beyond with ^ method
" Mapping spacebar to (recursively if needed) toggle folds encountered
nnoremap <silent><space> za
" nnoremap <Tab> zajzA                " For JSON: close fold and open next fold
" nnoremap <S-Tab> zakzA              " For JSON: close fold and open prev fold

" For JSON: define macro for pretty-fying current (JSON) file
let @p=':%!python -m json.tool'

" Highlighting options
set incsearch                       " Enable incremental searching (substrings)
set hlsearch                        " Enable search highlighting

" Adding clear highlighting functionality to Ctrl-L on top of screen redraw
nnoremap <C-L> :nohl <CR><C-L>


" Misc options
set backspace=indent,eol,start      " Makes backspace work like normal
set showmatch                       " Shows matching delims () {} []j
set nojoinspaces                    " No whitespaces after .?! using (J)oin

" Setup YouCompleteMe support for Vimtex
" if !exists('g:ycm_semantic_triggers')
"     let g:ycm_semantic_triggers = {}
" endif
" au VimEnter * let g:ycm_semantic_triggers.tex=g:vimtex#re#youcompleteme

" Set Vimtex viewer to sumatrapdf and set options
" let g:vimtex_view_general_viewer='SumatraPDF'
" let g:vimtex_view_general_options
"             \ = '-reuse-instane -forward-search @tex @line @pdf'
" let g:vimtex_view_general_options_latexmk='-reuse-instance'

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
nnoremap <C-A>\| :rightb vs
nnoremap <S-S> <Nop>
nnoremap <C-A><S-S> :bel sp
nnoremap <S-Q> <Nop>
nnoremap <C-A><S-Q> :on<CR>

" Window navigation with Ctrl-A HJKL (again like GNU screen!)
" Also allows for various other <C-W> initiated key bindings (e.g. w resizing)
nnoremap <C-A> <C-W>
nnoremap <C-A><C-A> <C-W><C-W>

" Window navigation from side-opened terminal for consistency with the rest ^
set termwinkey=<C-A>
" =============================================================================
