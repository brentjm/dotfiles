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
" colorschemes
Plugin 'altercation/vim-colors-solarized'
Plugin 'jnurmine/Zenburn'
"Plugin 'KevinGoodsell/vim-csexact' "Only works if vim compiled with +gui

" general
Plugin 'ctrlpvim/ctrlp.vim' "Fuzzy searching
Plugin 'tpope/vim-surround' "Insert surrounding characters on text (ysiw, cs)
Plugin 'fholgado/minibufexpl.vim' "List buffers
Plugin 'scrooloose/nerdtree' "File tree
Plugin 'majutsushi/tagbar' "Generate tags for files (uses exuberant ctags)
Plugin 'powerline/powerline' ", {'rtp': 'powerline/bindings/vim/'} added below
Plugin 'wesQ3/vim-windowswap' "Window positioner

" programming
Plugin 'Valloric/YouCompleteMe' "Requires a compiled component (see GitHub page)
Plugin 'vim-syntastic/syntastic' "Syntax checking
Plugin 'ternjs/tern_for_vim' "Tern based JavaScript editing support
"Plugin 'wilywampa/vim-ipython' "Only worked vim compiles with sampe python
"
" python
Plugin 'tmhedberg/SimpylFold' "Better folding for Python
Plugin 'julienr/vim-cellmode' "Works in a tmux with window and session name 'ipython'
Plugin 'klen/python-mode' "
"Plugin 'vim-scripts/indentpython.vim' "Not needed?
"Plugin 'davidhalter/jedi-vim' "Not needed with YouCompleteMe
"
" latex
Plugin 'vim-latex/vim-latex' "Notes: compile-\ll, fold-\rf, insert ref F5 inside []
Plugin 'vim-scripts/VOoM' "Latex outliner

" git
Plugin 'tpope/vim-fugitive' "Notes: edit commit-:Gedit, see diff-:Gdiff

" tmux
"Plugin 'benmills/vimux' "Interact with tmux (vim-cellmode is more current)

call vundle#end()

filetype plugin indent on

let mapleader=","

" Silvers searcher Ag
let g:ackprg = 'ag --nogroup --nocolor --column'

"""****** Window swapping *****
let g:windowswap_map_keys = 0 "prevent default bindings
nnoremap <silent> <leader>yw :call WindowSwap#MarkWindowSwap()<CR>
nnoremap <silent> <leader>pw :call WindowSwap#DoWindowSwap()<CR>
nnoremap <silent> <leader>ww :call WindowSwap#EasyWindowSwap()<CR>

"""**** Python-Mode Configuration ******
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
let g:pymode_rope = 0

" Documentation
let g:pymode_doc = 1
let g:pymode_doc_key = 'K'

"Linting
let g:pymode_lint = 1
"let g:pymode_python = 'python3'
let g:pymode_lint_checker = ["pylint", "pyflakes", "pep8"]
" Auto check on save
let g:pymode_lint_write = 1
" Ignore some errors
"let g:pymode_lint_select = "E501,W0011,W430"

" Support virtualenv
let g:pymode_virtualenv = 1
let g:pymode_virtualenv_path = $VIRTUAL_ENV

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

"******* Syntastic ********
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_ignore_files = ['\.py$']

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

"******* Jedi-Vim *********
"let g:jedi#completions_enabled = 1

"****** CtrlP ***********
let g:ctrlp_match_window = 'bottom,order:ttb'
let g:ctrlp_switch_buffer = 0
let g:ctrlp_working_path_mode = 0
let g:ctrlp_user_command = 'ag %s -l --nocolor --hidden -g ""'

"****** Powerline setup *********
set rtp+=~/.vim/bundle/powerline/powerline/bindings/vim/

" Always show statusline
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

augroup GeneralFiles
  set tabstop=4
  set softtabstop=4
  set shiftwidth=4
  set expandtab
  set autoindent
  augroup END

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
    au BufNewFile,BufRead *.js,*.html,*.css
        \ set tabstop=2 |
        \ set softtabstop=2 |
        \ set shiftwidth=2 |
        \ set expandtab |
        \ set autoindent |
        \ set foldmethod=indent |
    augroup END
   
"split navigations
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

"***** Colors ************
if has('gui_running')
  let g:solarized_termcolors=256
  set background=light
  colorscheme solarized
  set guifont=DejaVu\ Sans\ Mono\ 10
else
  "colorscheme zenburn
  let g:solarized_termcolors=256
  set background=light
  colorscheme solarized
  " Use 256 colours (Use this setting only if your terminal supports 256 colours)
  set t_Co=256
  set guifont=DejaVu\ Sans\ Mono\ for\ Powerline\ 9
endif

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
