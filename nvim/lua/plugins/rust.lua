vim.g.rustaceanvim = {
  server = {
    cmd = function()
      local mason_registry = require('mason-registry')
      local ra_binary = mason_registry.is_installed('rust-analyzer')
          and mason_registry.get_package('rust-analyzer'):get_install_path() .. '/rust-analyzer'
          or 'rust-analyzer'
      return { ra_binary }
    end,
  },
}

return {
  {
    'mrcjkb/rustaceanvim',
    version = '^5',
    ft = { 'rust' },
    keys = {
      { '<leader>rD', function() vim.cmd.RustLsp('debug') end },
      { '<leader>rd', function() vim.cmd.RustLsp({ 'debug', bang = true }) end },
      { '<leader>rR', function() vim.cmd.RustLsp('run') end },
      { '<leader>rr', function() vim.cmd.RustLsp({ 'run', bang = true }) end },
    },
    init = function()
      vim.g.rustaceanvim = {
        server = {
          settings = {
            ['rust-analyzer'] = {
              procMacro = {
                ignored = {
                  leptos_macro = {
                    -- optional: --
                    -- "component",
                    'server',
                  },
                },
              },
              rustfmt = {
                extraArgs = { '+nightly', '--unstable-features' },
              },
            },
          },
        },
      }
    end,
  },
  {
    'cordx56/rustowl',
    dependencies = { 'neovim/nvim-lspconfig' },
    opts = {
      trigger = {
        hover = true,
      }
    },
    keys = {
      { '<leader>rf', function() require('rustowl').rustowl_cursor() end },
    },
  },
  {
    'https://github.com/ron-rs/ron.vim.git'
  }
}
