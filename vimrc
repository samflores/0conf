call plug#begin('~/.vim/plugged')

Plug 'kchmck/vim-coffee-script'
Plug 'othree/html5.vim'
Plug 'csscomb/vim-csscomb', { 'for': ['css', 'scss'] }
Plug 'mattn/emmet-vim', { 'for': ['html', 'eruby', 'css', 'scss'] }
Plug 'niquola/vim-pg'
Plug 'hail2u/vim-css3-syntax'
Plug 'mxw/vim-jsx'
Plug 'pangloss/vim-javascript'
Plug 'tpope/vim-jdaddy', { 'for': 'json' }
Plug 'vim-scripts/django.vim', { 'for': ['python'] }
Plug 'hynek/vim-python-pep8-indent', { 'for': ['python'] }
Plug 'terryma/vim-multiple-cursors'

Plug 'vim-scripts/dbext.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': 'yes \| ./install' }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-projectionist'
Plug 'tpope/vim-dispatch'
Plug 'junegunn/vim-easy-align'
Plug 'tpope/vim-eunuch', { 'on': ['Mkdir', 'Unlink', 'Move'] }
Plug 'rbgrouleff/bclose.vim'

Plug 'kshenoy/vim-signature'
Plug 'tpope/vim-salve'

Plug 'tpope/vim-fireplace', { 'for': 'clojure' }
Plug 'guns/vim-sexp', { 'for': 'clojure' }
Plug 'tpope/vim-sexp-mappings-for-regular-people', { 'for': 'clojure' }

if has('nvim')
  Plug 'roxma/nvim-completion-manager'
  Plug 'neovim/node-host', { 'tag': 'v0.0.1' }
  Plug 'snoe/clj-refactor.nvim', { 'for': 'clojure' }
  Plug 'clojure-vim/acid.nvim', { 'do': ':UpdateRemotePlugins' }
  Plug 'clojure-vim/async-clj-omni', { 'for': 'clojure' }
endif
Plug 'sirver/ultisnips'
Plug 'honza/vim-snippets'
Plug 'bhurlow/vim-parinfer'


Plug 'w0rp/ale'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-scriptease', { 'for': 'vim' }

Plug 'tpope/vim-rails'
Plug 'sunaku/vim-ruby-minitest'
Plug 'rizzatti/dash.vim'
Plug 'janko-m/vim-test'
Plug 'jgdavey/vim-blockle'

Plug 'rhysd/vim-crystal'
Plug 'Superbil/llvm.vim'
Plug 'cespare/vim-toml'
Plug 'wting/rust.vim'
Plug 'mustache/vim-mustache-handlebars'
Plug 'rhysd/vim-rustpeg'
Plug 'racer-rust/vim-racer'
Plug 'roxma/nvim-cm-racer'

" colorscheme
Plug 'chriskempson/base16-vim'
Plug 'itchyny/lightline.vim'

call plug#end()

set shortmess=atI
set shiftwidth=2
set expandtab
set noshowmode
set nonumber
set norelativenumber
set mouse=a
set undofile
set undoreload=10000
set list
set listchars=tab:▸\ ,eol:¬,extends:❯,precedes:❮,space:·
set lazyredraw
set matchtime=2
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
set textwidth=120
set formatoptions=qrn1j
set wildmenu
" set wildmode=list:longest
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

set laststatus=2
set statusline=%f\ %{fugitive#statusline()}%=%l,%c\ %P

set virtualedit+=block
set wildignore+=.hg,.git,.svn                    " Version control
set wildignore+=*.aux,*.out,*.toc                " LaTeX intermediate files
set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg   " binary images
set wildignore+=*.o,*.obj,*.exe,*.dll,*.manifest " compiled object files
set wildignore+=*.sw?                            " Vim swap files
set wildignore+=*.DS_Store                       " OSX bullshit
set wildignore+=*.luac                           " Lua byte code
set wildignore+=*.orig                           " Merge resolution files
set wildignore+=classes                          " Clojure/Leiningen
set wildignore+=lib
set path+=**

" Leader
let mapleader = ","
let maplocalleader = "\\"

" Spelling
set nospell
set spelllang=pt_br,en_us
nnoremap zG 2zg

set fillchars=diff:⣿,vert:│

" ag > grep
set grepprg=ag\ --nogroup\ --nocolor\ --column

" Save when losing focus
au FocusLost * :silent! wall

" Resize splits when the window is resized
au VimResized * :wincmd =

if has('nvim')
  let g:cm_refresh_default_min_word_len=2
  let g:cm_smart_enable=1
endif

augroup filetype
  au!
  autocmd BufRead,BufNewFile *.ll set filetype=llvm
augroup END

augroup term
  au!
  autocmd BufNew,BufNewFile,BufRead term://* set nospell nolist
augroup END

augroup rustpeg
  au!
  au BufNewFile,BufRead *.rustpeg setf rust
augroup END

augroup clojure
  au!
  au BufNewFile,BufRead build.boot setf clojure
  au FileType clojure setlocal lw+=match,go,go-loop,
augroup END

augroup cline
  au!
  au WinLeave,InsertEnter * set nocursorline
  au WinEnter,InsertLeave * set cursorline
augroup END

augroup trailing
  au!
  au InsertEnter * set listchars-=trail:⌴
  au InsertLeave * set listchars+=trail:⌴
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
  au BufWritePost init.vim source %
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
hi clear
colorscheme base16-grayscale-dark
set guifont=Operator\ Mono:h18

function! s:ToggleBG()
  let &background = ( &background == "dark"? "light" : "dark" )
  if exists("g:colors_name")
    exe "colorscheme " . g:colors_name
    if exists("g:loaded_niji")
      call niji#highlight()
    endif
  endif
endfunction

let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

nnoremap <silent> <leader>q :call <sid>ToggleBG()<cr>

" Highlight VCS conflict markers
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'

" Kill window
nnoremap K :Bclose<cr>
nnoremap X :q<cr>

" Man
nnoremap  M K
nmap     ,M <Plug>DashSearch

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

" Clear trailing whitespace
nnoremap <silent> <leader>ww mz:%s/\s\+$//<cr>:let @/=''<cr>`zmz

" Clear searches
nnoremap <silent> <leader>k :nohlsearch<cr>

" 'Uppercase word' mapping.
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

" [U]nfuck my screen
nnoremap U :syntax sync fromstart<cr>:redraw!<cr>

" Quick editing
nnoremap <leader>vv :vsplit $MYVIMRC\|set bufhidden=wipe<cr>
nnoremap <leader>vd :vsplit ~/.vim/custom-dictionary.utf-8.add\|set bufhidden=wipe<cr>
nnoremap <leader>vg :vsplit ~/.gitconfig\|set bufhidden=wipe<cr>
nnoremap <leader>vz :vsplit ~/.zshrc\|set bufhidden=wipe<cr>
nnoremap <leader>vt :vsplit ~/.tmux.conf\|set bufhidden=wipe<cr>

" Keep search matches in the middle of the window.
nnoremap n nzzzv
nnoremap N Nzzzv

" Same when jumping around
nnoremap g; g;zz
nnoremap g, g,zz
nnoremap <c-o> <c-o>zz

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

" Expand to current path on command mode
cnoremap %% <c-r>=expand('%:h').'/'<CR>

" Yeah, I'm that lazy
nnoremap ; :
nnoremap : ;
vnoremap ; :
vnoremap : ;

" I prefer block selection
nnoremap v <C-V>
nnoremap <C-V> v
vnoremap v <C-V>
vnoremap <C-V> v

" Easier to type
nnoremap <Leader><Leader> <c-^>

" Most of the time I want to ignore the indentation
nnoremap 0 ^
nnoremap <Leader>0 0

" Fugitive mappings
nnoremap gws :Gstatus<CR>
nnoremap gia :Gwrite<CR>
nnoremap gco :Gread<CR>
nnoremap gwd :Gvdiff<CR>
nnoremap gcm :Gcommit<CR>
nnoremap gca :Gcommit --amend<CR>

" EasyAlign
vmap <Enter> <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

highlight ColorColumn ctermfg=15 ctermbg=1 guifg=#d3ebe9 guibg=#c23127
call matchadd('ColorColumn', '\%121v', 100)

if has('nvim')
  tnoremap <Esc> <C-\><C-n>
endif

let g:niji_dark_colours = [
      \ ["LightCyan","#c6b6ee"],
      \ ["LightCyan","#8fbfdc"],
      \ ["Grey","#5f6b85"],
      \ ["Yellow","#fad07a"],
      \ ["Green","#799d6a"],
      \ ["DarkBlue","#b27ecd"],
      \ ]
let g:niji_light_colours = g:niji_dark_colours

command! Bufonly call s:CloseHiddenBuffers()
function! s:CloseHiddenBuffers()
  let open_buffers = []

  for i in range(tabpagenr('$'))
    call extend(open_buffers, tabpagebuflist(i + 1))
  endfor

  for num in range(1, bufnr("$") + 1)
    if buflisted(num) && index(open_buffers, num) == -1
      exec "bdelete ".num
    endif
  endfor
endfunction

" FUZZY FINDER STUFF
nnoremap <leader>oo :Files<cr>
nnoremap <leader>og :GFiles<cr>
nnoremap <leader>oc :Files app/controllers<cr>
nnoremap <leader>oC :Files spec/controllers<cr>
nnoremap <leader>od :Files app/decorators<cr>
nnoremap <leader>oD :Files spec/decorators<cr>
nnoremap <leader>ov :Files app/views<cr>
nnoremap <leader>om :Files app/models<cr>
nnoremap <leader>oM :Files spec/models<cr>
nnoremap <leader>of :Files spec/fixtures<cr>
nnoremap <leader>oF :Files spec/features<cr>
nnoremap <leader>oj :Files app/assets/javascripts<cr>
nnoremap <leader>os :Files app/assets/stylesheets<cr>
nnoremap <leader>ow :Files app/workers<cr>
nnoremap <leader>oa :Files app/admin<cr>
nnoremap <leader>ol :Files config/locales<cr>
nnoremap <leader>o  <Nop>
nnoremap <leader>bb :Buffers<cr>

au! FileType FZF set nospell

" Rspec mappings
nnoremap <leader>tt :TestNearest<CR>
nnoremap <leader>tf :TestFile<CR>
nnoremap <leader>ta :TestSuite<CR>
nnoremap <leader>tl :TestLast<CR>
nnoremap <leader>tg :TestVisit<CR>

let g:test#runner_commands = []
let test#strategy = "neovim"
" let test#ruby#minitest#file_pattern = '_spec\.rb'

let g:rspec_command = "compiler rspec | set makeprg=zeus | Make rspec {spec}"

autocmd FileType clojure inoremap <buffer> / /<ESC>:silent! CMagicRequires<CR>a

" nnoremap <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
" \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
" \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

" dbext profiles
let g:dbext_default_profile_adapt_prod  = 'type=pgsql:user=uv73be4b6kij0:dbname=de84slt1iucctv:host=ec2-34-197-121-79.compute-1.amazonaws.com:port=5432'
let g:dbext_default_profile_adapt_stag  = 'type=pgsql:user=ua0ggkfa521ijv:dbname=d9rdavk05hh2aq:host=ec2-23-21-48-149.compute-1.amazonaws.com:port=5512'
let g:dbext_default_profile_adapt_pbus  = 'type=pgsql:user=oorkwbpbnnioyo:dbname=de2smmai3pniu4:host=ec2-23-21-220-23.compute-1.amazonaws.com:port=5432'
let g:dbext_default_profile_adapt_sbus  = 'type=pgsql:host=ec2-54-83-205-71.compute-1.amazonaws.com:port=5432:dbname=d5odu03us86v8r:user=gvkzhnfjcytezz'
let g:dbext_default_profile_adapt_local = 'type=pgsql:user=samflores:dbname=adaptativa-elearning_development:host=localhost:port=5432'
let g:dbext_default_profile_tuned_prod  = 'type=pgsql:user=root:dbname=modexp:host=modexp-pg.civvlbuhbgn1.sa-east-1.rds.amazonaws.com:port=5432'
let g:dbext_default_profile_tuned_pbus  = 'type=pgsql:user=tuneduc:dbname=xpenem_bus:host=modwhite.civvlbuhbgn1.sa-east-1.rds.amazonaws.com:port=5432'
let g:dbext_default_profile_tuned_local = 'type=pgsql:user=samflores:dbname=modexp:host=localhost:port=5432'
let g:dbext_default_profile='adapt_prod'

" Completion and snippets
let g:UltiSnipsExpandTrigger="<Plug>(ultisnips_expand)"
let g:UltiSnipsJumpForwardTrigger='<tab>'
let g:UltiSnipsJumpBackwardTrigger='<s-tab>'

inoremap <silent> <c-u> <c-r>=cm#sources#ultisnips#trigger_or_popup("\<Plug>(ultisnips_expand)")<cr>
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
imap <expr> <Plug>(expand_or_nl) (has_key(v:completed_item,'snippet')?"\<C-U>":"\<CR>")
imap <expr> <CR>  (pumvisible() ?  "\<c-y>\<Plug>(cm_inject_snippet)\<Plug>(expand_or_nl)" : "\<CR>")

let g:ale_sign_error = '!'
let g:ale_sign_warning = '?'
nmap <silent> <leader>j <Plug>(ale_previous_wrap)
nmap <silent> <leader>k <Plug>(ale_next_wrap)

autocmd FileType scss noremap <buffer> <leader>bc :CSScomb<CR>

" node plugins
" call remote#host#RegisterPlugin('node', '/Users/samflores/.0conf/vim/plugged/nvim-parinfer.js/rplugin/node/nvim-parinfer.js', [
"       \ {'sync': v:true, 'name': 'ParinferIndent', 'type': 'function', 'opts': {'eval': '[getpos(''.''), bufnr(''.''), getline(1,line(''$'')), g:parinfer_mode, g:parinfer_preview_cursor_scope, v:operator, -strlen(@-)]'}},
"       \ {'sync': v:true, 'name': 'ParinferShift', 'type': 'function', 'opts': {'eval': '[getline(1,line(''$''))]'}},
"      \ ])

let g:test#python#djangotest#executable = 'envdir .env python manage.py test'

:highlight ALEError ctermbg=none cterm=underline

let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ 'active': {
      \   'left': [ [ 'filename' ], [ 'linter',  'gitbranch' ] ],
      \   'right': [ [ 'percent', 'lineinfo' ], [ 'fileencoding', 'filetype' ] ]
      \ },
      \ 'component_expand': { 'linter': 'WizErrors', },
      \ }

function! WizErrors() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:errors = l:counts.error == 0 ? '' : printf('!%d', l:counts.error)
  let l:serrors = l:counts.style_error == 0 ? '' : printf(' ¡%d', l:counts.style_error)
  let l:warnings = l:counts.warning == 0 ? '' : printf(' ?%d', l:counts.warning)
  let l:swarnings = l:counts.style_warning == 0 ? '' : printf(' ¿%d', l:counts.style_warning)
  return l:errors . l:serrors . l:warnings . l:swarnings
endfunction

augroup alestatus
  au!
  autocmd User ALELint call lightline#update()
augroup end
