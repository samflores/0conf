local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
  execute('packadd packer.nvim')
end

return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'

  local plugins = {
    'filetype',
    'dashboard',

    'completion',
    -- 'debugger',
    'fuzzy',
    'lsp',
    'snippets',
    'treesitter',

    'abolish',
    'autofocus',
    'bqf',
    'bufclose',
    'colorscheme',
    'commentary',
    'crease',
    'dadbod',
    'devdocs',
    'diaglist',
    'dispatch',
    'easyalign',
    'editorconfig',
    'eunuch',
    'floaterm',
    'fugitive',
    'gitingutter',
    'hlslens',
    'indentblankline',
    'matchup',
    'motionsearch',
    -- 'popups',
    'projectionist',
    'repeat',
    'rhubarb',
    'session',
    'surround',
    'test',
    'truezen',

    'clojure',
    'coffeescript',
    'emmet',
    'json',
    'markdown',
    'ruby',

    'statusline',
  }

  for _, plugin in ipairs(plugins) do
    require('plugins.' .. plugin).init(use)
  end
end)
