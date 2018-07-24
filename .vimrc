set rtp+=~/.local/share/nvim/site/autoload/
call plug#begin()
Plug 'altercation/vim-colors-solarized'
Plug 'davidhalter/jedi-vim'
Plug 'ternjs/tern_for_vim'
Plug 'https://github.com/neomake/neomake'
call plug#end()

filetype plugin indent on

let mapleader=","

"******* basic settings *********
set wildmenu

let g:neomake_open_list = 2
let g:neomake_serialize = 1
let g:neomake_serialize_abort_on_error = 1
call neomake#configure#automake('rw', 1000)

"******* Jedi-Vim *********
let g:jedi#completions_enabled = 1

" Always show statusline
set laststatus=2

"***** netrw *********
let g:netrw_banner = 0
let g:netrw_liststyle = 3
"let g:netrw_browse_split = 4
"let g:netrw_altv = 1
"let g:netrw_winsize = 20
"map <F2> :Lexplore<CR>
"augroup ProjectDrawer
"  autocmd!
"  autocmd VimEnter * :Vexplore
"augroup END

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
    au BufNewFile,BufRead *.js,*.html,*.css,*.jsx
        \ set tabstop=4 |
        \ set softtabstop=4 |
        \ set shiftwidth=4 |
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
