local set              = vim.opt
local g                = vim.g
local api              = vim.api

set.winwidth           = 10
set.winminwidth        = 10
set.equalalways        = false

set.autoread           = true
set.autowrite          = true
set.backup             = true
set.backupdir          = vim.fn.stdpath('config') .. '/backups/'
set.clipboard          = 'unnamedplus'
set.completeopt        = 'menu,menuone,noselect'
set.conceallevel       = 3
set.cmdheight          = 1
set.cursorline         = false
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
vim.wo.foldexpr        = 'v:lua.vim.treesitter.foldexpr()'
vim.bo.indentexpr      = "v:lua.require'nvim-treesitter'.indentexpr()"
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
set.undodir            = vim.fn.stdpath('config') .. '/undos/'
set.undofile           = true
set.undoreload         = 10000
set.wildmenu           = true
set.wildmode           = 'full:list:longest'
set.winborder          = 'rounded'
set.winfixheight       = true
set.wrap               = false
set.writebackup        = true

g.mapleader            = ','
g.maplocalleader       = ' '
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

vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = ' ',
      [vim.diagnostic.severity.WARN] = ' ',
      [vim.diagnostic.severity.HINT] = ' ',
      [vim.diagnostic.severity.INFO] = ' ',
    },
    linehl = {
      [vim.diagnostic.severity.ERROR] = 'DiagnosticSignError',
      [vim.diagnostic.severity.WARN] = 'DiagnosticSignWarn',
      [vim.diagnostic.severity.HINT] = 'DiagnosticSignHint',
      [vim.diagnostic.severity.INFO] = 'DiagnosticSignInfo',
    },
    numhl = {
      [vim.diagnostic.severity.ERROR] = '',
      [vim.diagnostic.severity.WARN] = '',
      [vim.diagnostic.severity.HINT] = '',
      [vim.diagnostic.severity.INFO] = '',
    },
  },
})

-- LSP inline completion is opt-in; toggle in normal mode with <leader>ic.
vim.g.inline_completion_enabled = false
