local set = vim.opt
local g = vim.g
local api = vim.api

set.autoread = true
set.autowrite = true
set.backup = true
set.writebackup = true
set.backupdir = '/home/samflores/.config/nvim/backups/'
set.clipboard = 'unnamedplus'
set.completeopt = 'menu,menuone,noselect'
set.equalalways = false
set.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:,diff:⣿,vert:│]]
set.listchars = 'tab:│ ,eol:↵,trail:~,extends:>,precedes:<,nbsp:•'
set.gdefault = true
set.grepprg = 'rg --vimgrep'
set.hidden = true
set.hlsearch = true
set.ignorecase = true
set.incsearch = true
set.lazyredraw = true
set.matchtime = 2
set.mouse = 'a'
set.scrolloff = 3
set.shiftround = true
set.shortmess = 'atIc'
set.showbreak = '└'
set.showmatch = true
set.showmode = false
set.sidescrolloff = 10
set.smartcase = true
set.splitbelow = true
set.splitright = true
set.swapfile = false
set.termguicolors = true
set.timeoutlen = 1000
set.title = true
set.ttimeoutlen = 0
set.undodir = '/home/samflores/.config/nvim/undos/'
set.undoreload = 10000
set.wildmenu = true
set.wildmode = 'full:list:longest'
set.laststatus = 3

set.expandtab = true
set.shiftwidth = 2
set.softtabstop = -1
set.tabstop = 2
set.formatoptions = 'qrn1j'
set.spelllang = 'pt_br,en_us'
set.synmaxcol = 800
set.syntax = 'on'
set.textwidth = 120
set.undofile = true
set.undofile = true

set.cursorline = false
set.foldcolumn = '1'
set.foldlevel = 99
set.foldlevelstart = 99
set.foldenable = true
set.linebreak = true
set.list = true
set.number = true
set.relativenumber = true
set.signcolumn = 'yes'
set.spell = false
set.winfixheight = true
set.wrap = false

g.mapleader = ","
g.maplocalleader = [[\]]

g.netrw_special_syntax = 1

api.nvim_exec([[
  match ErrorMsg '^\\(<\\|=\\|>\\)\\{7\\}\\([^=].\\+\\)\\?$'
]], false)
