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

"Plugin 'klen/python-mode'
Plugin 'tmhedberg/SimpylFold'
Plugin 'vim-scripts/indentpython.vim'
Plugin 'davidhalter/jedi-vim'
Plugin 'Lokaltog/powerline', {'rtp': 'powerline/bindings/vim/'}
Plugin 'tpope/vim-fugitive'
Plugin 'scrooloose/nerdtree'
Plugin 'benmills/vimux'
Plugin 'majutsushi/tagbar'
Plugin 'vim-latex/vim-latex'
Plugin 'vim-scripts/VOoM'
"Plugin 'wilywampa/vim-ipython' "Only worked vim compiles with sampe python
"Plugin 'julienr/vim-cellmode' "Only worked vim compiles with sampe python
Plugin 'altercation/vim-colors-solarized'
Plugin 'jnurmine/Zenburn'
"Plugin 'KevinGoodsell/vim-csexact' "Only works if vim compiled with +gui
Plugin 'kien/ctrlp.vim'

call vundle#end()

filetype plugin indent on

""**** Python-Mode Configuration ******
"" Activate rope
"" Keys:
"" K             Show python docs
"" <Ctrl-Space>  Rope autocomplete
"" <Ctrl-c>g     Rope goto definition
"" <Ctrl-c>d     Rope show documentation
"" <Ctrl-c>f     Rope find occurrences
"" <Leader>b     Set, unset breakpoint (g:pymode_breakpoint enabled)
"" [[            Jump on previous class or function (normal, visual, operator modes)
"" ]]            Jump on next class or function (normal, visual, operator modes)
"" [M            Jump on previous class or method (normal, visual, operator modes)
"" ]M            Jump on next class or method (normal, visual, operator modes)
"let g:pymode_rope = 1
"
"" Documentation
"let g:pymode_doc = 1
"let g:pymode_doc_key = 'K'
"
""Linting
"let g:pymode_lint = 1
"let g:pymode_lint_checker = "pyflakes,pep8"
"" Auto check on save
"let g:pymode_lint_write = 1
"
"" Support virtualenv
"let g:pymode_virtualenv = 1
"
"" Enable breakpoints plugin
"let g:pymode_breakpoint = 1
"let g:pymode_breakpoint_bind = '<leader>b'
"
"" syntax highlighting
"let g:pymode_syntax = 1
"let g:pymode_syntax_all = 1
"let g:pymode_syntax_indent_errors = g:pymode_syntax_all
"let g:pymode_syntax_space_errors = g:pymode_syntax_all
"
"" Don't autofold code
"let g:pymode_folding = 0


"****** Powerline setup *********
"set guifont=DejaVu\ Sans\ Mono\ for\ Powerline\ 9
set laststatus=2

"****** NERDTree mapping ***********
map <F2> :NERDTreeToggle<CR>

"****** Tagbar ***********
nmap <F8> :TagbarToggle<CR>

let g:solarized_termcolors=256

"******** General configuration ************

set history=700     " set command history
set autoread        " autoread when a file is changed from outside
set showmode        " show current mode
set mouse=a         " use mouse
set number
set encoding=utf-8
syntax on

" Replace tabs with spaces
au BufNewFile,BufRead *.py
    \ set tabstop=4
    \ set softtabstop=4
    \ set shiftwidth=4
    \ set expandtab
    \ set autoindent
    \ set fileformat=unix,dos

au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/

au BufNewFile,BufRead *.js, *.html, *.css
    \ set tabstop=2
    \ set softtabstop=2
    \ set shiftwidth=2
    
"split navigations
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Highligh long lines
augroup vimrc_autocmds
    autocmd!
    " highlight characters past column 120
    autocmd FileType python highlight Excess ctermbg=DarkGrey guibg=Black
    autocmd FileType python match Excess /\%120v.*/
    autocmd FileType python set nowrap
    augroup END

" Use <leader>l to toggle display of whitespace
nmap <leader>l :set list!<CR>
" automatically change window's cwd to file's dir
set autochdir

if has('gui_running')
  set background=dark
  colorscheme solarized
else
  colorscheme zenburn
endif

" more subtle popup colors
if has ('gui_running')
    highlight Pmenu guibg=#cccccc gui=bold
endif

