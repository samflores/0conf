return {
  {
    'williamboman/mason.nvim',
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
    'folke/lazydev.nvim',
    ft = 'lua',
    dependencies = {
      'saghen/blink.cmp',
      { 'Bilal2453/luvit-meta', lazy = true },
    },
    opts = {
      library = {
        { path = 'luvit-meta/library', words = { 'vim%.uv' } },
      },
    },
  },
  {
    'folke/trouble.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {},
    keys = {
      { '<leader>xx', function() require('trouble').toggle('diagnostics') end },
      { '<leader>xw', function() require('trouble').toggle('workspace_diagnostics') end },
      { '<leader>xd', function() require('trouble').toggle('document_diagnostics') end },
      { '<leader>xq', function() require('trouble').toggle('quickfix') end },
      { '<leader>xl', function() require('trouble').toggle('loclist') end },
      { 'gR',         function() require('trouble').toggle('lsp_references') end },
    }
  },
  {
    'smjonas/inc-rename.nvim',
    config = true,
    keys = {
      { '<leader>rn', ':IncRename ' }
    }
  },
}
