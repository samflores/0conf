return {
  {
    src = 'https://github.com/williamboman/mason.nvim',
    name = 'mason.nvim',
    data = {
      cmd = { 'Mason', 'MasonInstall', 'MasonUninstall', 'MasonUpdate' },
      after = function()
        require('mason').setup({
          ui = {
            icons = {
              package_installed = '',
              package_pending = '',
              package_uninstalled = '',
            },
          }
        })
      end,
    },
  },
  {
    src = 'https://github.com/Bilal2453/luvit-meta',
    name = 'luvit-meta',
    data = {
      dep_of = 'lazydev.nvim',
    },
  },
  {
    src = 'https://github.com/folke/lazydev.nvim',
    name = 'lazydev.nvim',
    data = {
      ft = 'lua',
      after = function()
        require('lazydev').setup({
          library = {
            { path = 'luvit-meta/library', words = { 'vim%.uv' } },
          },
        })
      end,
    },
  },
  {
    src = 'https://github.com/folke/trouble.nvim',
    name = 'trouble.nvim',
    data = {
      keys = {
        { lhs = '<leader>xx', rhs = function() require('trouble').toggle('diagnostics') end },
        { lhs = '<leader>xw', rhs = function() require('trouble').toggle('workspace_diagnostics') end },
        { lhs = '<leader>xd', rhs = function() require('trouble').toggle('document_diagnostics') end },
        { lhs = '<leader>xq', rhs = function() require('trouble').toggle('quickfix') end },
        { lhs = '<leader>xl', rhs = function() require('trouble').toggle('loclist') end },
        { lhs = 'gR',         rhs = function() require('trouble').toggle('lsp_references') end },
      },
      after = function()
        require('trouble').setup()
      end,
    },
  },
  {
    src = 'https://github.com/smjonas/inc-rename.nvim',
    name = 'inc-rename.nvim',
    data = {
      keys = {
        { lhs = '<leader>rn', rhs = ':IncRename ' }
      },
      after = function()
        require('inc_rename').setup()
      end,
    },
  },
}
