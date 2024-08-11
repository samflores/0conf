local set              = vim.opt
local g                = vim.g
local api              = vim.api

set.autoread           = true
set.autowrite          = true
set.backup             = true
set.backupdir          = '/home/samflores/.config/nvim/backups/'
set.clipboard          = 'unnamedplus'
set.completeopt        = 'menu,menuone,noselect'
set.conceallevel       = 3
set.cmdheight          = 2
set.cursorline         = false
set.equalalways        = false
set.expandtab          = true
set.fillchars          = {
  eob = ' ',
  fold = ' ',
  foldopen = '',
  foldsep = ' ',
  foldclose = '',
  diff = '⣿',
  vert = '│'
}
set.foldcolumn         = '1'
set.foldenable         = true
set.foldlevel          = 99
set.foldlevelstart     = 99
set.formatoptions      = 'qrn1j'
set.gdefault           = true
set.grepprg            = 'rg --vimgrep'
set.hidden             = true
set.hlsearch           = true
set.ignorecase         = true
set.incsearch          = true
set.laststatus         = 3
set.lazyredraw         = false
set.linebreak          = true
set.list               = true
set.listchars          = { tab = '  ', eol = '↵', trail = '', extends = '>', precedes = '<', nbsp = '•' }
set.matchtime          = 2
set.mouse              = 'a'
set.number             = true
set.relativenumber     = true
set.scrolloff          = 3
set.shiftround         = true
set.shiftwidth         = 2
-- set.shortmess          = 'atIc'
set.shortmess          = 'IW'
set.showbreak          = '└'
set.showmatch          = true
set.showmode           = false
set.sidescrolloff      = 10
set.signcolumn         = 'yes'
set.smartcase          = true
set.softtabstop        = -1
set.spell              = false
set.spelllang          = 'pt_br,en_us'
set.splitbelow         = true
set.splitright         = true
set.swapfile           = false
set.synmaxcol          = 800
set.syntax             = 'on'
set.tabstop            = 2
set.exrc               = true
set.termguicolors      = true
set.textwidth          = 120
set.timeoutlen         = 1000
set.title              = true
set.ttimeoutlen        = 0
set.undodir            = '/home/samflores/.config/nvim/undos/'
set.undofile           = true
set.undofile           = true
set.undoreload         = 10000
set.wildmenu           = true
set.wildmode           = 'full:list:longest'
set.winfixheight       = true
set.wrap               = false
set.writebackup        = true

g.mapleader            = ','
g.maplocalleader       = '\\'
g.netrw_special_syntax = 1
g.netrw_banner         = false
g.sessionoptions       = 'blank,buffers,curdir,folds,help,tabpages'

api.nvim_exec2([[
  match ErrorMsg '^\\(<\\|=\\|>\\)\\{7\\}\\([^=].\\+\\)\\?$'
]], {})

vim.filetype.add({
  extension = {
    http = 'http',
    ll = 'llvm',
    rustpreg = 'rust',
  },
  filename = {
    ['storage.rules'] = 'firestore',
  }
})

g.clap_layout = {
  relative = 'editor',
  width = '100%',
  height = '33%',
  row = '70%',
  col = '33%',
}
