call plug#begin('~/.vim/plugged')

Plug 'Shougo/unite.vim'
Plug 'Shougo/vimproc.vim'
Plug 'guns/vim-clojure-static'
Plug 'guns/vim-sexp', { 'for': 'clojure' }
Plug 'junegunn/vim-easy-align', { 'on': ['EasyAlign'] }
Plug 'mustache/vim-mustache-handlebars'
Plug 'psql.vim'
Plug 'romainl/Apprentice'
Plug 'spinningarrow/vim-niji', { 'for': 'clojure' }
Plug 'tpope/vim-commentary', { 'on': ['Commentary', 'CommentaryLine'] }
Plug 'tpope/vim-dispatch', { 'on': [ 'Start', 'Dispatch' ] }
Plug 'tpope/vim-eunuch', { 'on': ['Mkdir', 'Unlink'] }
Plug 'tpope/vim-fireplace', { 'for': 'clojure' }
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-jdaddy', { 'for': 'json' }
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-scriptease', { 'for': 'vim' }
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-sexp-mappings-for-regular-people', { 'for': 'clojure' }
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-surround', { 'on': ['Csurround', 'Dsurround', 'Ysurround'] }
Plug 'wting/rust.vim'

call plug#end()

set nocompatible
set autowrite   
if exists('+breakindent')
  set breakindent showbreak=\ +
endif
set undofile undodir=~/.vim/undos
set directory=$HOME/.vim/tmp,.
set spell spelllang=pt_br,en_us
set number
set completeopt=menu,preview
set shortmess=atI
set clipboard=unnamed
set timeoutlen=300
set hidden nobackup
set nowrap
set ignorecase smartcase
set title splitbelow splitright
set viminfo=!,'1000,f1,<500,:100,@10
set laststatus=2 statusline=[%n]\ %<%.99f\ %h%w%m%r%{fugitive#statusline()}%y%=%-16(\ %l,%c%V\ %)%P
set grepprg=ag\ --nogroup\ --nocolor\ --column
set background=dark
set t_Co=256
colorscheme apprentice

" EasyAlign
vmap <Enter> <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

cnoremap %% <c-r>=expand('%:h').'/'<CR>
nnoremap ; :
nnoremap : ;
vnoremap ; :
vnoremap : ;
nnoremap v <C-V>
nnoremap <C-V> v
vnoremap v <C-V>
vnoremap <C-V> v
nnoremap <Leader><Leader> <c-^>
nnoremap <Leader>i :set list!<CR>
nnoremap <Leader>ch :CloseHiddenBuffers<CR>
nnoremap 0 ^
nnoremap <Leader>0 0
nnoremap <silent> <c-k> :noh<CR>
noremap <Up> <nop>
noremap <Down> <nop>
noremap <Left> <nop>
noremap <Right> <nop>

"" Fugitive mappings
nnoremap gws :Gstatus<CR>
nnoremap gia :Gwrite<CR>
nnoremap gco :Gread<CR>
nnoremap gwd :Gvdiff<CR>
nnoremap gcm :Gcommit<CR>
nnoremap gca :Gcommit --amend<CR>

"" Unite mappings
nnoremap <Leader>m :<c-u>Unite -no-split -buffer-name=mappings -start-insert mapping<CR>
nnoremap <Leader>t :<c-u>Unite -no-split -buffer-name=files    -start-insert file_rec<CR>
nnoremap <Leader>g :<c-u>Unite -no-split -buffer-name=files    -start-insert file_rec/git:--cached:--others:--exclude-standard<CR>
nnoremap <Leader>f :<c-u>Unite -no-split -buffer-name=files    -start-insert file<CR>
nnoremap <Leader>r :<c-u>Unite -no-split -buffer-name=mru      -start-insert file_mru<CR>
nnoremap <Leader>o :<c-u>Unite -no-split -buffer-name=outline  -start-insert outline<CR>
nnoremap <Leader>e :<c-u>Unite -no-split -buffer-name=buffer   -start-insert buffer<CR>
nnoremap <Leader>y :<c-u>Unite -no-split -buffer-name=yank     history/yank<CR>
" nnoremap <Leader>b :<c-u>Unite -no-split -buffer-name=build    build<CR>
nnoremap <Leader>x :<c-u>Unite -no-split -buffer-name=quickfix quickfix<CR>

let g:unite_source_history_yank_enable = 1
call unite#filters#matcher_default#use(['matcher_fuzzy'])
call unite#custom#source('file_rec', 'ignore_globs', [
            \ '_site/*',
            \ '_site/**/*',
            \ '_sass/*',
            \ '_includes/*',
            \ '_layouts/*',
            \ 'target/*',
            \ 'target/**/*',
            \ 'out/*',
            \ 'out/**/*',
            \ 'bower_components/**/*',
            \ 'resources/**/*',
            \ 'node_modules/**/*'
            \ ])

" Custom mappings for the unite buffer
autocmd FileType unite call s:unite_settings()
function! s:unite_settings()
  " Enable navigation with control-j and control-k in insert mode
  imap <buffer> <C-j>   <Plug>(unite_select_next_line)
  imap <buffer> <C-k>   <Plug>(unite_select_previous_line)
endfunction

" let &t_SI = "\<Esc>]50;CursorShape=1\x7"
" let &t_EI = "\<Esc>]50;CursorShape=0\x7"

let mapleader=","
set exrc secure
