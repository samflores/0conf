call plug#begin('~/.vim/plugged')

Plug 'othree/html5.vim'
Plug 'mattn/emmet-vim', { 'for': ['vue', 'html', 'eruby', 'css', 'scss'] }
Plug 'niquola/vim-pg'
Plug 'hail2u/vim-css3-syntax'
Plug 'stephenway/postcss.vim'
Plug 'pangloss/vim-javascript'
Plug 'tpope/vim-jdaddy', { 'for': 'json' }
" Plug 'b4b4r07/vim-sqlfmt'
Plug 'junegunn/goyo.vim'
Plug 'jparise/vim-graphql'
Plug 'mtth/scratch.vim'
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }

Plug 'MaxMEllon/vim-jsx-pretty'

Plug 'kchmck/vim-coffee-script'
" Plug 'csscomb/vim-csscomb', { 'for': ['css', 'scss'] }
" Plug 'vim-scripts/django.vim', { 'for': ['python'] }
" Plug 'hynek/vim-python-pep8-indent', { 'for': ['python'] }

Plug 'vim-scripts/dbext.vim'
Plug 'junegunn/vim-easy-align'
Plug 'tpope/vim-eunuch', { 'on': ['Mkdir', 'Unlink', 'Move'] }
Plug 'rbgrouleff/bclose.vim'
Plug 'justinmk/vim-sneak'

Plug 'airblade/vim-gitgutter'
Plug 'kshenoy/vim-signature'
" Plug 'tpope/vim-salve'
Plug 'tpope/vim-abolish'
Plug 'haya14busa/incsearch.vim'
Plug 'haya14busa/incsearch-fuzzy.vim'

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'Shougo/neosnippet.vim'
Plug 'Shougo/neosnippet-snippets'
Plug 'sirver/ultisnips'
Plug 'honza/vim-snippets'
Plug 'w0rp/ale'
Plug 'posva/vim-vue'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-scriptease', { 'for': 'vim' }
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-projectionist'
Plug 'c-brenn/fuzzy-projectionist.vim'
Plug 'radenling/vim-dispatch-neovim'

Plug 'guns/vim-sexp', { 'for': 'clojure' }
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fireplace', { 'for': 'clojure' }
Plug 'tpope/vim-sexp-mappings-for-regular-people', { 'for': 'clojure' }
Plug 'bhurlow/vim-parinfer'

Plug 'sunaku/vim-ruby-minitest'
Plug 'janko-m/vim-test'
Plug 'jgdavey/vim-blockle'
Plug 'tpope/vim-rails'
"
Plug 'rhysd/vim-crystal'

" Plug 'cespare/vim-toml'
" Plug 'Superbil/llvm.vim'
" Plug 'rust-lang/rust.vim'
" Plug 'rhysd/vim-rustpeg'

" colorscheme
Plug 'chriskempson/base16-vim'
Plug 'vheon/vim-cursormode'
" Plug 'owickstrom/vim-colors-paramount'
Plug 'samflores/vim-colors-paramount', { 'branch': 'lightline-colorscheme' }
Plug 'itchyny/lightline.vim'

call plug#end()

let g:sneak#s_next = 1
let g:LanguageClient_serverCommands = {
    \ 'ruby': ['tcp://localhost:7658'],
    \ 'vue': ['vls'],
    \ 'javascript': ['vls']
    \ }

let g:LanguageClient_autoStop = 0

autocmd FileType ruby setlocal omnifunc=LanguageClient#complete


nnoremap <F5> :call LanguageClient_contextMenu()<CR>
" Or map each action separately
nnoremap <silent> M :call LanguageClient#textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
nnoremap <silent> <F2> :call LanguageClient#textDocument_rename()<CR>

let g:acid_log_messages=1
let g:sql_type_default='pgsql'
let b:sql_type_override='pgsql'

set shortmess=atIc
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
set matchtime=2 timeoutlen=1000 ttimeoutlen=0
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
set cursorline
set clipboard=unnamedplus
set backupcopy=yes

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
" set statusline=%f\ %{fugitive#statusline()}%=%l,%c\ %P

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
let g:tmuxline_powerline_separators = 0

" Leader
let mapleader = ","
let maplocalleader = "\\"

" Incsearch
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)
map z/ <Plug>(incsearch-fuzzy-/)
map z? <Plug>(incsearch-fuzzy-?)
map zg/ <Plug>(incsearch-fuzzy-stay)

" Spelling
set nospell
set spelllang=pt_br,en_us
nnoremap zG 2zg

set fillchars=diff:⣿,vert:│

" rg > ag > grep
set grepprg=rg\ --vimgrep
command! -nargs=+ Grep
      \   execute 'silent grep <args>'
      \ | redraw!
      \ | copen
" nnoremap <leader>G :silent execute "grep! ". shellescape(expand("<cword>")). "."<cr>:copen<cr>
" set grepprg="rg --color=never --column --no-heading --glob !node_modules/* --vimgrep"
command! -bang -nargs=*
      \ Find call fzf#vim#grep(
      \ 'rg --vimgrep --column --line-number --no-heading --fixed-strings
      \ --ignore-case --no-ignore --hidden --follow
      \ --glob "!.git/*" --glob "!node_modules/*"
      \ --glob "!*.lock" --glob "!*.log"
      \ --color "always" '.shellescape(<q-args>), 1, <bang>0)
nnoremap <leader>g :silent execute "grep! ". shellescape(expand("<cword>")). " app"<cr>:copen<cr>
nnoremap <leader>G :execute "Find ". expand("<cword>")<cr>

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
  au InsertEnter * set nocursorline
  au InsertLeave * set cursorline
augroup END

augroup trailing
  au!
  au WinLeave,InsertEnter * set listchars-=trail:⌴
  au WinEnter,InsertLeave * set listchars+=trail:⌴
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
  au BufWritePost .vimrc source %
  au BufWritePost init.vim source %
augroup END

augroup VimCSS3Syntax
  au!
  autocmd FileType css,vue setlocal iskeyword+=-
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

" UltiSnips
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"
let g:UltiSnipsEditSplit="vertical"
let g:UltiSnipsSnippetDirectories=[$HOME.'/.vim/UltiSnips']

let g:jsx_ext_required = 0
let g:ale_sign_column_always=0

let g:ale_fix_on_save=1

nnoremap <silent> <leader>q :call <sid>ToggleBG()<cr>

" Highlight VCS conflict markers
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'

" Kill window
nnoremap K :Bclose<cr>
nnoremap X :q<cr>
nnoremap ,X :on<cr>
nnoremap QQ :wqa

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
nnoremap <silent> <leader>ww mz:silent! %s/\s\+$//<cr>:let @/=''<cr>`zmz
" :%s/[^\s]\zs\s\+\ze\.//<cr>

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

cnoremap <C-A> <Home>

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

highlight link ALEError    Underlined
highlight link ALEWarning  Underlined
set colorcolumn=+1,+2,+3,+4,+5,+6,+7,+8,+9,+10
      \,+11,+12,+13,+14,+15,+16,+17,+18,+19,+20
      \,+21,+22,+23,+24,+25,+26,+27,+28,+29,+30
      \,+31,+32,+33,+34,+35,+36,+37,+38,+39,+40

if has('nvim')
  tnoremap <Esc> <C-\><C-n>
endif

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
nnoremap <leader>o  <Nop>
nnoremap <leader>oo :Files<cr>
nnoremap <leader>og :GFiles<cr>
nnoremap <leader>oh :History<cr>
nnoremap <leader>ob :Buffers<cr>
nnoremap <leader>o. :exec "Files ". expand('%:h')<cr>
nnoremap <leader>o? :call fuzzy_projectionist#choose_projection()<cr>
nnoremap <leader>oc :call fuzzy_projectionist#projection_for_type('controller')<cr>
nnoremap <leader>od :call fuzzy_projectionist#projection_for_type('decorator')<cr>
nnoremap <leader>ov :call fuzzy_projectionist#projection_for_type('view')<cr>
nnoremap <leader>om :call fuzzy_projectionist#projection_for_type('model')<cr>
nnoremap <leader>of :call fuzzy_projectionist#projection_for_type('factory')<cr>
nnoremap <leader>oF :call fuzzy_projectionist#projection_for_type('feature')<cr>
nnoremap <leader>oj :call fuzzy_projectionist#projection_for_type('javascript')<cr>
nnoremap <leader>os :call fuzzy_projectionist#projection_for_type('stylesheet')<cr>
nnoremap <leader>ow :call fuzzy_projectionist#projection_for_type('worker')<cr>
nnoremap <leader>ol :call fuzzy_projectionist#projection_for_type('locale')<cr>

au! FileType FZF set nospell

" Rspec mappings

nnoremap <leader>tt :TestNearest<CR>
nnoremap <leader>tf :TestFile<CR>
nnoremap <leader>ta :TestSuite<CR>
nnoremap <leader>tl :TestLast<CR>
nnoremap <leader>tg :TestVisit<CR>

augroup runNearestTest
  autocmd!
  autocmd BufNew,BufNewFile,BufReadPost *_spec.rb nnoremap <buffer> <Enter> :TestNearest<CR>
  autocmd BufNew,BufNewFile,BufReadPost *_test.rb nnoremap <buffer> <Enter> :TestNearest<CR>
augroup END


let g:test#runner_commands = []
let test#strategy = 'dispatch'
let test#ruby#rspec#options = {
  \ 'nearest': '-I.',
  \}
" let test#ruby#minitest#file_pattern = '_spec\.rb'

let g:rspec_command = "compiler rspec | set makeprg=zeus | Make rspec {spec}"

autocmd FileType clojure inoremap <buffer> / /<ESC>:silent! CMagicRequires<CR>a

nnoremap <F10> :echo "hi<". synIDattr(synID(line("."),col("."),1),"name"). '> trans<'
      \ . synIDattr(synID(line("."),col("."),0),"name"). "> lo<"
      \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name"). ">"<CR>

" dbext profiles
" let g:dbext_default_profile_adapt_prod  = 'type=pgsql:user=uv73be4b6kij0:dbname=de84slt1iucctv:host=ec2-34-197-121-79.compute-1.amazonaws.com:port=5432'
" let g:dbext_default_profile_adapt_stag  = 'type=pgsql:user=ua0ggkfa521ijv:dbname=d9rdavk05hh2aq:host=ec2-23-21-48-149.compute-1.amazonaws.com:port=5512'
" let g:dbext_default_profile_adapt_pbus  = 'type=pgsql:user=oorkwbpbnnioyo:dbname=de2smmai3pniu4:host=ec2-23-21-220-23.compute-1.amazonaws.com:port=5432'
" let g:dbext_default_profile_adapt_sbus  = 'type=pgsql:host=ec2-54-83-205-71.compute-1.amazonaws.com:port=5432:dbname=d5odu03us86v8r:user=gvkzhnfjcytezz'
" let g:dbext_default_profile_adapt_local = 'type=pgsql:user=samflores:dbname=adaptativa-elearning_development:host=localhost:port=5432'
" let g:dbext_default_profile_tuned_prod  = 'type=pgsql:user=root:dbname=modexp:host=modexp-pg.civvlbuhbgn1.sa-east-1.rds.amazonaws.com:port=5432'
" let g:dbext_default_profile_tuned_pbus  = 'type=pgsql:user=tuneduc:dbname=xpenem_bus:host=modwhite.civvlbuhbgn1.sa-east-1.rds.amazonaws.com:port=5432'
" let g:dbext_default_profile_tuned_local = 'type=pgsql:user=samflores:dbname=modexp:host=localhost:port=5432'
" let g:dbext_default_profile_smart_local = 'type=pgsql:user=samflores:dbname=smartnex_dev:host=localhost:port=5432'
" let g:dbext_default_profile_smart_test = 'type=pgsql:user=samflores:dbname=smartnex_tst:host=localhost:port=5432'
let g:dbext_default_profile_edvera_local = 'type=pgsql:user=samflores:dbname=edvera_development:host=localhost:port=5432'
let g:dbext_default_profile_blog_local = 'type=pgsql:user=samflores:dbname=blog_test_dev:host=localhost:port=5432'
let g:dbext_default_profile_stack_local = 'type=MYSQL:user=stacksocial:passwd=stacksocial:dbname=stacksocial_development:host=mysql:port=3306'
let g:dbext_default_profile_stack_test_local = 'type=MYSQL:user=stacksocial:passwd=stacksocial:dbname=stacksocial_test:host=mysql:port=3306'
let g:dbext_default_profile='edvera_local'
let g:sqlfmt_command = 'sqlfmt'
let g:sqlfmt_options = '-u'

" Completion and snippets
let g:UltiSnipsExpandTrigger="<Plug>(ultisnips_expand)"
let g:UltiSnipsJumpForwardTrigger='<tab>'
let g:UltiSnipsJumpBackwardTrigger='<s-tab>'
let g:deoplete#enable_at_startup = 1
let g:deoplete#keyword_patterns = {}
let g:deoplete#keyword_patterns.clojure = '[\w!$%&*+/:<=>?@\^_~\-\.#]*'

vmap <leader>p <Plug>(coc-format-selected)
nmap <leader>p <Plug>(coc-format-selected)

" inoremap <silent> <c-u> <c-r>=cm#sources#ultisnips#trigger_or_popup("\<Plug>(ultisnips_expand)")<cr>
" inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
" inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
" imap <expr> <Plug>(expand_or_nl) (has_key(v:completed_item,'snippet')?"\<C-U>":"\<CR>")
" imap <expr> <CR>  (pumvisible() ?  "\<c-y>\<Plug>(cm_inject_snippet)\<Plug>(expand_or_nl)" : "\<CR>")

let g:ale_sign_error = '!'
let g:ale_sign_warning = '?'
nmap <silent> <leader>J <Plug>(ale_previous_wrap)
nmap <silent> <leader>K <Plug>(ale_next_wrap)

autocmd FileType scss noremap <buffer> <leader>bc :CSScomb<CR>

" node plugins
" call remote#host#RegisterPlugin('node', '/Users/samflores/.0conf/vim/plugged/nvim-parinfer.js/rplugin/node/nvim-parinfer.js', [
"       \ {'sync': v:true, 'name': 'ParinferIndent', 'type': 'function', 'opts': {'eval': '[getpos(''.''), bufnr(''.''), getline(1,line(''$'')), g:parinfer_mode, g:parinfer_preview_cursor_scope, v:operator, -strlen(@-)]'}},
"       \ {'sync': v:true, 'name': 'ParinferShift', 'type': 'function', 'opts': {'eval': '[getline(1,line(''$''))]'}},
"      \ ])

" let &t_Cs = "\e[4:3m"
" let &t_Ce = "\e[4:0m"
function! s:base16_customize() abort
  " call Base16hi("ALEErrorLine", "", "", "", "", "", "")
  " call Base16hi("ALEWarningLine", "", "", "", "", "", "")
  call Base16hi("ALEError",     "",             "",             "",               "",               "undercurl", "")
  call Base16hi("ALEWarning",   "",             "",             "",               "",               "undercurl", "")
  call Base16hi("ALEErrorSign", "",             "",             "",               "",               "bold",      "")
  call Base16hi("String",       "",             "",             "",               "",               "italic",    "")
  call Base16hi("Number",       "",             "",             "",               "",               "bold",      "")
  call Base16hi("Comment",      "",             "",             "",               "",               "italic",    "")
  call Base16hi("NonText",      g:base16_gui02, "",             g:base16_cterm02, "",               "",          "")
  call Base16hi("SpecialKey",   g:base16_gui02, "",             g:base16_cterm02, "",               "",          "")
  call Base16hi("ColorColumn",  "",             g:base16_gui01, "",               g:base16_cterm01, "",          "")
  call Base16hi("VertSplit",    "",             "",             g:base16_cterm02, g:base16_cterm00, "",          "")
endfunction

function! s:typewriter_customize() abort
  " General
  hi String cterm=italic
  hi Statement cterm=bold
  hi Comment cterm=italic ctermfg=249
  hi PreProc ctermfg=249
  hi CursorLine cterm=NONE ctermbg=254 ctermfg=NONE
  hi NonText ctermfg=252
  " Rust
  hi rustAttribute  cterm=italic ctermfg=249
endfunction

function! s:paramount_customize() abort
  hi ColorColumn ctermbg=255
  hi SpecialKey ctermfg=255
  hi VertSplit ctermfg=255 ctermbg=256
  hi String ctermfg=134 cterm=italic
  hi Comment ctermfg=248 cterm=italic
  hi Error cterm=undercurl ctermbg=NONE ctermfg=9
  hi ALEError cterm=undercurl ctermbg=NONE ctermfg=9
  hi ALEWarning cterm=undercurl ctermbg=NONE ctermfg=9
  hi ALEErrorSign cterm=bold ctermbg=NONE ctermfg=9
endfunction

let cursormode_color_map = {
      \   "n":      "#000000",
      \   "i":      "#000000",
      \   "v":      "#000000",
      \   "V":      "#000000",
      \   "\<C-V>": "#000000",
      \ }

augroup on_change_colorschema
  autocmd!
  autocmd ColorScheme base16-* call s:base16_customize()
  autocmd ColorScheme typewriter call s:typewriter_customize()
  autocmd ColorScheme paramount call s:paramount_customize()
augroup END

" Colors
syntax on
set t_Co=256
set background=light
hi clear
" if filereadable(expand("~/.vimrc_background"))
  " let base16colorspace=256
  " source ~/.vimrc_background
" endif
colorscheme paramount

function! s:ToggleBG()
  let &background = ( &background == "dark"? "light" : "dark" )
  if exists("g:colors_name")
    exe "colorscheme ". g:colors_name
  endif
endfunction

let g:ale_fixers = {
\   'javascript': ['eslint'],
\   'css':        ['eslint'],
\   'vue':        ['eslint'],
\   'ruby':       ['rubocop'],
\}
let g:ale_sign_error='🔴'
let g:ale_sign_warning='🔶'
let g:ale_sign_info='🔵'

let g:lightline = {
      \   'colorscheme': 'paramount',
      \   'active': {
      \     'left': [ [ 'filename' ], [ 'linter' ] ],
      \     'right': [ [ 'fileencoding' ], [ 'filetype' ], [ 'gitbranch' ] ]
      \   },
      \   'inactive': {
      \     'left': [ [ 'filename' ], [ 'linter' ] ],
      \     'right': [ [ 'gitbranch' ] ]
      \   },
      \   'component_function': {
      \     'linter': 'WizErrors',
      \     'gitbranch': 'fugitive#head'
      \   }
      \ }

function! WizErrors() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:errors = l:counts.error == 0 ? '' : printf('%s %d', g:ale_sign_error, l:counts.error)
  let l:serrors = l:counts.style_error == 0 ? '' : printf(' [%s] %d', g:ale_sign_error, l:counts.style_error)
  let l:warnings = l:counts.warning == 0 ? '' : printf(' %s %d', g:ale_sign_warning, l:counts.warning)
  let l:swarnings = l:counts.style_warning == 0 ? '' : printf(' [%s] %d', g:ale_sign_warning, l:counts.style_warning)
  return l:errors . l:serrors . l:warnings . l:swarnings
endfunction

augroup alestatus
  au!
  autocmd User ALELint call lightline#update()
augroup end

augroup jscinoptions
  au!
  autocmd BufRead,BufNewFile *.js set cino=(1s
augroup end

" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

let g:neosnippet#enable_snipmate_compatibility = 1
