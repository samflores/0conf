call plug#begin('~/.vim/plugged')

Plug 'ajh17/VimCompletesMe'
Plug 'cespare/vim-toml'
Plug 'guns/vim-clojure-static'
Plug 'hail2u/vim-css3-syntax'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': 'yes \| ./install' }
Plug 'junegunn/vim-oblique'
Plug 'junegunn/vim-pseudocl'
Plug 'mustache/vim-mustache-handlebars'
Plug 'psql.vim'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-sleuth'
Plug 'wting/rust.vim'

Plug 'JavaScript-Indent', { 'for': ['html', 'javascript'] }
Plug 'guns/vim-sexp', { 'for': 'clojure' }
Plug 'junegunn/vim-easy-align', { 'on': ['EasyAlign'] }
Plug 'raymond-w-ko/vim-niji', { 'for': 'clojure' }
Plug 'tpope/vim-commentary', { 'on': ['Commentary', 'CommentaryLine'] }
Plug 'tpope/vim-dispatch', { 'on': [ 'Start', 'Dispatch' ] }
Plug 'tpope/vim-eunuch', { 'on': ['Mkdir', 'Unlink', 'Move'] }
Plug 'tpope/vim-fireplace', { 'for': 'clojure' }
Plug 'tpope/vim-jdaddy', { 'for': 'json' }
Plug 'tpope/vim-scriptease', { 'for': 'vim' }
Plug 'tpope/vim-sexp-mappings-for-regular-people', { 'for': 'clojure' }
Plug 'tpope/vim-surround', { 'on': ['Csurround', 'Dsurround', 'Ysurround'] }
Plug 'venantius/vim-cljfmt', { 'for': 'clojure' }

call plug#end()

set shortmess=atI
set noshowmode
set nonumber
set norelativenumber
set mouse=a
set undofile
set undoreload=10000
set list
set listchars=tab:▸\ ,eol:¬,extends:❯,precedes:❮
set lazyredraw
set matchtime=3
set showbreak=↪
set splitbelow
set splitright
set autowrite
set autoread
set shiftround
set title
set linebreak
set synmaxcol=800
set complete=.,w,b,u,t
set completeopt=longest,menuone,preview
set nowrap
set textwidth=80
set formatoptions=qrn1j
set wildmenu
set wildmode=list:longest
set backup                        " enable backups
set noswapfile                    " it's 2013, Vim.
set undodir=~/.vim/undos//        " undo files
set backupdir=~/.vim/backups//    " backups
set directory=~/.vim/swaps//      " swap files

set ignorecase
set smartcase
set incsearch
set showmatch
set hlsearch
set gdefault

set scrolloff=3
set sidescroll=1
set sidescrolloff=10

set laststatus=1
" set statusline=%f\ %{fugitive#statusline()}%=%l,%c\ %P

set virtualedit+=block
set wildignore+=.hg,.git,.svn                    " Version control
set wildignore+=*.aux,*.out,*.toc                " LaTeX intermediate files
set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg   " binary images
set wildignore+=*.o,*.obj,*.exe,*.dll,*.manifest " compiled object files
set wildignore+=*.spl                            " compiled spelling word lists
set wildignore+=*.sw?                            " Vim swap files
set wildignore+=*.DS_Store                       " OSX bullshit
set wildignore+=*.luac                           " Lua byte code
set wildignore+=migrations                       " Django migrations
set wildignore+=*.pyc                            " Python byte code
set wildignore+=*.orig                           " Merge resolution files
set wildignore+=classes                          " Clojure/Leiningen
set wildignore+=lib

" Leader
let mapleader = ","
let maplocalleader = "\\"

" Spelling
set spell
set spelllang=pt_br,en_us
nnoremap zG 2zg

set fillchars=diff:⣿,vert:│

set grepprg=ag\ --nogroup\ --nocolor\ --column

" Save when losing focus
au FocusLost * :silent! wall

" Resize splits when the window is resized
au VimResized * :wincmd =

augroup term
  au!
  autocmd BufNew,BufNewFile,BufRead term://* set nospell nolist
augroup END

augroup clojure
  au!
  au BufNewFile,BufRead build.boot setf clojure
  autocmd FileType clojure let b:vcm_tab_complete = 'user'
augroup END

augroup cline
  au!
  au WinLeave,InsertEnter * set nocursorline
  au WinEnter,InsertLeave * set cursorline
augroup END

augroup trailing
  au!
  au InsertEnter * :set listchars-=trail:⌴
  au InsertLeave * :set listchars+=trail:⌴
augroup END

augroup line_return
  au!
  au BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \     execute 'normal! g`"zvzz' |
        \ endif
augroup END

augroup edit_vimrc
  au!
  au BufWritePost .?vimrc source %
augroup END

if !isdirectory(expand(&undodir))
  call mkdir(expand(&undodir), "p")
endif
if !isdirectory(expand(&backupdir))
  call mkdir(expand(&backupdir), "p")
endif
if !isdirectory(expand(&directory))
  call mkdir(expand(&directory), "p")
endif

syntax on
set background=dark
colorscheme onedark
highlight Normal guibg=#282c35
highlight VertSplit guibg=#282c35 guifg=#2c323d
highlight CursorLine guibg=#2c323d
highlight TabLine guibg=#2c323d guifg=#5f6b85
highlight TabLineFill guibg=#2c323d
highlight TabLineSel guibg=#282c35 guifg=#9098a0 gui=NONE
highlight StatusLine guibg=#282c35 guifg=#5f6b85
highlight StatusLineNC guibg=#282c35 guifg=#2c323d
highlight Comment gui=italic
highlight String gui=italic
highlight Define gui=bold
highlight SpellBad guibg=#282c35 gui=undercurl guisp=#ff0000
highlight NonText guifg=#2c323d

" Highlight VCS conflict markers
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'

" Kill window
nnoremap K :q<cr>

" Man
nnoremap M K

" Toggle line numbers
nnoremap <leader>n :setlocal number!<cr>

" Sort lines
nnoremap <leader>s vip:!sort<cr>
vnoremap <leader>s :!sort<cr>

" Tabs
nnoremap <leader>( :tabprev<cr>
nnoremap <leader>) :tabnext<cr>

" Wrap
nnoremap <leader>W :set wrap!<cr>

" Clean trailing whitespace
nnoremap <leader>ww mz:%s/\s\+$//<cr>:let @/=''<cr>`z

" "Uppercase word" mapping.
inoremap <C-u> <esc>mzgUiw`za

" Panic Button
nnoremap <f9> mzggg?G`z

" Formatting, TextMate-style
nnoremap Q gqip
vnoremap Q gq

" Reformat line.
nnoremap ql gqq

" Keep the cursor in place while joining lines
nnoremap J mzJ`z

" Join an entire paragraph.
nnoremap <leader>J mzvipJ`z

" Split line (sister to [J]oin lines)
nnoremap S i<cr><esc>^mwgk:silent! s/\v +$//<cr>:noh<cr>`w

" Select (charwise) the contents of the current line, excluding indentation.
nnoremap vv ^vg_

" Sudo to write
cnoremap w!! w !sudo tee % >/dev/null

" Toggle [i]nvisible characters
nnoremap <leader>i :set list!<cr>

" Toggle spell
nnoremap <leader>z :set spell!<cr>

" Unfuck my screen
nnoremap U :syntax sync fromstart<cr>:redraw!<cr>

" Quick editing
nnoremap <leader>ev :vsplit $MYVIMRC\|set bufhidden=wipe<cr>
nnoremap <leader>ed :vsplit ~/.vim/custom-dictionary.utf-8.add\|set bufhidden=wipe<cr>
nnoremap <leader>eg :vsplit ~/.gitconfig\|set bufhidden=wipe<cr>
nnoremap <leader>ez :vsplit ~/.zshrc\|set bufhidden=wipe<cr>
nnoremap <leader>et :vsplit ~/.tmux.conf\|set bufhidden=wipe<cr>

" Use sane regexes.
" nnoremap / /\v
" vnoremap / /\v
" nnoremap ? ?\v
" vnoremap ? ?\v

" Keep search matches in the middle of the window.
" nnoremap n nzzzv
" nnoremap N Nzzzv

" Same when jumping around
nnoremap g; g;zz
nnoremap g, g,zz
nnoremap <c-o> <c-o>zz

autocmd! User Oblique
autocmd! User ObliqueStar
autocmd! User ObliqueRepeat

autocmd User Oblique       normal! zz
autocmd User ObliqueStar   normal! zz
autocmd User ObliqueRepeat normal! zz

" Easier to type, and I never use the default behavior.
noremap H ^
noremap L $
vnoremap L g_

" Move around
noremap <silent> j gj
noremap <silent> k gk
noremap <silent> gj j
noremap <silent> gk k

" Easy buffer navigation
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l

" List navigation
nnoremap <left>  :cprev<cr>zvzz
nnoremap <right> :cnext<cr>zvzz
nnoremap <up>    :lprev<cr>zvzz
nnoremap <down>  :lnext<cr>zvzz

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
nnoremap 0 ^
nnoremap <Leader>0 0
nnoremap <silent> <c-k> :noh<CR>

"" Fugitive mappings
nnoremap gws :Gstatus<CR>
nnoremap gia :Gwrite<CR>
nnoremap gco :Gread<CR>
nnoremap gwd :Gvdiff<CR>
nnoremap gcm :Gcommit<CR>
nnoremap gca :Gcommit --amend<CR>

" EasyAlign
vmap <Enter> <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

highlight ColorColumn ctermbg=16
call matchadd('ColorColumn', '\%81v', 100)

" List of buffers
function! s:buflist()
  redir => ls
  silent ls
  redir END
  return split(ls, '\n')
endfunction

function! s:bufopen(e)
  execute 'buffer' matchstr(a:e, '^[ 0-9]*')
endfunction

function! s:bufdelete(e)
  execute 'bdelete' matchstr(a:e, '^[ 0-9]*')
endfunction

function! s:fuzzy_len()
  return min([15, 2 + substitute(system('ag -l -lg ""|wc -l'), '^\s*\(.\{-}\)\s*$', '\1', '')])
endfunction

nnoremap <silent> <Leader>\ :call fzf#run({
      \   'source':  <sid>buflist(),
      \   'sink':    function('<sid>bufdelete'),
      \   'options': '-m --tac',
      \   'down':    len(<sid>buflist()) + 2
      \ })<CR>

nnoremap <silent> <Leader><Enter> :call fzf#run({
      \   'source':  <sid>buflist(),
      \   'sink':    function('<sid>bufopen'),
      \   'options': '--tac',
      \   'down':    len(<sid>buflist()) + 2
      \ })<CR>

nnoremap <silent> <Leader>/ :call fzf#run({
      \   'source': v:oldfiles,
      \   'sink' : 'e ',
      \   'options' : '--tac',
      \   'down': 10
      \})<cr>

nnoremap <silent> <Leader>t :call fzf#run({
      \   'source': 'ag -l -g ""',
      \   'sink': 'e ',
      \   'options': '--tac',
      \   'down': <sid>fuzzy_len()
      \})<cr>

nnoremap <f10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<' . synIDattr(synID(line("."),col("."),0),"name") . "> lo<" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>
"
au FileType FZF set nospell

let g:niji_dark_colours = [
      \ ["LightCyan","#c6b6ee"],
      \ ["LightCyan","#8fbfdc"],
      \ ["Grey","#5f6b85"],
      \ ["Yellow","#fad07a"],
      \ ["Green","#799d6a"],
      \ ["DarkBlue","#b27ecd"],
      \ ]
let g:niji_light_colours = g:niji_dark_colours 

tnoremap <Esc> <C-\><C-n>
