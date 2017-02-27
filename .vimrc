"***** vundle ***********
set nocompatible
filetype off

"set rtp+=~/.vim/bundle/Vundle.vim/
set rtp+=~/.vim/bundle/vundle/
"call vundle#rc()
call vundle#begin()

" let Vundle manage Vundle
" required!
Plugin 'gmarik/vundle'

" The bundles you install will be listed here

Plugin 'klen/python-mode'
Plugin 'tmhedberg/SimpylFold'
Plugin 'vim-scripts/indentpython.vim'
Plugin 'Valloric/YouCompleteMe' "Requires a compiled component (see GitHub page)
Plugin 'davidhalter/jedi-vim'
Plugin 'Lokaltog/powerline', {'rtp': 'powerline/bindings/vim/'}
Plugin 'tpope/vim-fugitive'
Plugin 'scrooloose/nerdtree'
Plugin 'benmills/vimux'
Plugin 'majutsushi/tagbar'
Plugin 'vim-latex/vim-latex'
Plugin 'vim-scripts/VOoM'
"Plugin 'wilywampa/vim-ipython' "Only worked vim compiles with sampe python
Plugin 'julienr/vim-cellmode' "Works in a tmux with window and session name 'ipython'
Plugin 'altercation/vim-colors-solarized'
Plugin 'jnurmine/Zenburn'
"Plugin 'KevinGoodsell/vim-csexact' "Only works if vim compiled with +gui
Plugin 'kien/ctrlp.vim'
Plugin 'tpope/vim-surround'
Plugin 'fholgado/minibufexpl.vim'

call vundle#end()

filetype plugin indent on

""**** Python-Mode Configuration ******
" Activate rope
" Keys:
" K             Show python docs
" <Ctrl-Space>  Rope autocomplete
" <Ctrl-c>g     Rope goto definition
" <Ctrl-c>d     Rope show documentation
" <Ctrl-c>f     Rope find occurrences
" <Leader>b     Set, unset breakpoint (g:pymode_breakpoint enabled)
" [[            Jump on previous class or function (normal, visual, operator modes)
" ]]            Jump on next class or function (normal, visual, operator modes)
" [M            Jump on previous class or method (normal, visual, operator modes)
" ]M            Jump on next class or method (normal, visual, operator modes)
let g:pymode_rope = 0

" Documentation
let g:pymode_doc = 1
let g:pymode_doc_key = 'K'

"Linting
let g:pymode_lint = 1
let g:pymode_lint_checker = "pyflakes,pylint,pep8"
" Auto check on save
let g:pymode_lint_write = 1

" Support virtualenv
let g:pymode_virtualenv = 1

" Enable breakpoints plugin
let g:pymode_breakpoint = 1
let g:pymode_breakpoint_bind = '<leader>b'

" Enable running code
"let g:pymode_run = 1
"let g:pymode_run_bind = '<leader>r'

" syntax highlighting
let g:pymode_syntax = 1
let g:pymode_syntax_all = 1
let g:pymode_syntax_indent_errors = g:pymode_syntax_all
let g:pymode_syntax_space_errors = g:pymode_syntax_all

" Don't autofold code
let g:pymode_folding = 0

"******* Jedi-Vim *********
let g:jedi#completions_enabled = 1

"****** CtrlP ***********
let g:ctrlp_match_window = 'bottom,order:ttb'
let g:ctrlp_switch_buffer = 0
let g:ctrlp_working_path_mode = 0
let g:ctrlp_user_command = 'ag %s -l --nocolor --hidden -g ""'

"****** Powerline setup *********
set guifont=DejaVu\ Sans\ Mono\ for\ Powerline\ 9
set laststatus=2

"****** NERDTree mapping ***********
map <F2> :NERDTreeToggle<CR>

"****** Tagbar ***********
nmap <F8> :TagbarToggle<CR>

"******** General configuration ************

set history=700     " set command history
set autoread        " autoread when a file is changed from outside
set showmode        " show current mode
set mouse=a         " use mouse
set number
set encoding=utf-8
syntax on

set listchars=eol:$,tab:>-,trail:.,extends:>,precedes:<,nbsp:_
" Use <leader>l to toggle display of whitespace
nmap <leader>l :set list!<CR>

"" Python PEP-008
augroup PythonFiles
    autocmd!
    autocmd FileType python set nowrap
    au BufNewFile,BufRead *.py
        \ set tabstop=4 |
        \ set softtabstop=4 |
        \ set shiftwidth=4 |
        \ set expandtab |
        \ set autoindent |
        \ set fileformats=unix,dos |
    augroup END

" JS, HTML format
augroup JSFiles
    autocmd!
    autocmd BufNewFile,BufRead *.js, *.html, *.css
        \ set tabstop=2
        \ set softtabstop=2
        \ set shiftwidth=2
        \ set expandtab
        \ set autoindent
    augroup END
   
"split navigations
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

"***** Colors ************
if has('gui_running')
  set background=dark
  colorscheme solarized
else
  colorscheme zenburn
endif

let g:solarized_termcolors=256

" more subtle popup colors
if has ('gui_running')
    highlight Pmenu guibg=#cccccc gui=bold
endif

" Highligh long lines
augroup vimrc_autocmds
    autocmd!
    " highlight characters past column 80
    autocmd FileType python highlight Excess ctermbg=red guibg=red
    autocmd FileType python match Excess /\%80v.*/
    " hightlight spaces at end of line
    autocmd FileType python highlight BadWhitespace ctermbg=red guibg=red
    autocmd FileType python  match BadWhitespace /\s\+$/
    augroup END
