-- vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
--   vim.lsp.handlers.hover, { focusable = false }
-- )
--
-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system({ 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
      { out,                            'WarningMsg' },
      { '\nPress any key to exit...' },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

-- Setup lazy.nvim

local combined_hover = function()
  local util = require 'vim.lsp.util'
  local params = util.make_position_params()
  vim.lsp.buf_request_all(0, 'textDocument/hover', params, function(responses)
    local value = ''
    for _, response in pairs(responses) do
      local result = response.result
      if result and result.contents and result.contents.value then
        if value ~= '' then
          value = value .. '___'
        end
        value = value .. result.contents.value
      end
    end

    if value ~= '' then
      return util.open_floating_preview(
        vim.split(value, '\n', true),
        'markdown',
        {}
      )
    end
  end)
end


local config_lsp = function()
  local config = require('lspconfig')

  config.solargraph.setup {}
  config.sorbet.setup {}

  local ms = require('vim.lsp.protocol').Methods
  vim.keymap.set('n', 'K', combined_hover)
end

local ts_config = function()
  require 'nvim-treesitter.configs'.setup {
    ensure_installed = {
      'markdown',
      'ruby'
    },
    highlight = {
      enable = true
    }
  }
end

require('lazy').setup({
  spec = {
    {
      'williamboman/mason.nvim',
      priority = 50,
      opts = {
        ui = {
          icons = {
            package_installed = '',
            package_pending = '',
            package_uninstalled = '',
          },
        }
      }
    },
    {
      'williamboman/mason-lspconfig.nvim',
      priority = 60,
      config = true
    },
    {
      'neovim/nvim-lspconfig',
      priority = 70,
      config = config_lsp,
      lazy = false,
      opts = {
        inlay_hints = true
      },
    },
    {
      'nvim-treesitter/nvim-treesitter',
      config = ts_config,
      build = function()
        require('nvim-treesitter.install').update({ with_sync = true })
      end,
      ft = {
        'ruby',
        'markdown'
      }
    }
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { 'habamax' } },
  -- automatically check for plugin updates
  checker = { enabled = true },
})
