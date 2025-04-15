local config_lsp = function()
  local config = require('lspconfig')
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  -- capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())
  capabilities = require('blink.cmp').get_lsp_capabilities(capabilities)
  -- local lspconfig = require('lspconfig')
  --
  -- lspconfig['lua-ls'].setup({ capabilities = capabilities })

  local servers = {
    lemminx = {},
    -- steep = {},
    arduino_language_server = {},
    yamlls = {},
    dockerls = {},
    docker_compose_language_service = {},
    pylsp = {},
    bashls = {},
    clangd = {},
    clojure_lsp = {},
    cssls = {},
    -- fish_lsp = {},
    graphql = {},
    html = {},
    jsonls = {},
    jdtls = {},
    ruby_lsp = {},
    sqlls = {},
    svelte = {},
    taplo = {},
    emmet_ls = {
      filetypes = { 'css', 'eruby', 'html', 'javascript', 'javascriptreact', 'less', 'sass', 'scss', 'svelte', 'pug', 'typescriptreact', 'vue' },
      init_options = {
        html = {
          options = { ['bem.enabled'] = true, },
        },
      }
    },
    lua_ls = {
      settings = {
        Lua = {
          hint = {
            enable = true,
            arrayIndex = 'Disable',
            setType = true,
          },
          runtime = {
            version = 'LuaJIT',
            path = vim.split(package.path, ';'),
          },
          diagnostics = {
            globals = { 'vim' },
          },
          workspace = {
            library = {
              [vim.fn.expand('$VIMRUNTIME/lua')] = true,
              [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
              [vim.fn.stdpath('data') .. '/lazy'] = true,
            },
          },
        }
      }
    },
    ts_ls = {
      root_dir = config.util.root_pattern('package.json'),
      settings = {
        javascript = {
          inlayHints = {
            includeInlayEnumMemberValueHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayParameterNameHints = 'all', -- 'none' | 'literals' | 'all';
            includeInlayParameterNameHintsWhenArgumentMatchesName = true,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayVariableTypeHints = true,
          },
        },
        typescript = {
          inlayHints = {
            includeInlayEnumMemberValueHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayParameterNameHints = 'all', -- 'none' | 'literals' | 'all';
            includeInlayParameterNameHintsWhenArgumentMatchesName = true,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayVariableTypeHints = true,
          },
        },
      },
    },
    eslint = {
      on_attach = function(client, bufnr)
        vim.api.nvim_create_autocmd('BufWritePre', {
          buffer = bufnr,
          command = 'EslintFixAll',
        })
      end,
    }
  }

  require('mason').setup({
    ui = {
      icons = {
        package_installed = '',
        package_pending = '',
        package_uninstalled = '',
      },
    }
  })

  local ensure_installed = vim.tbl_keys(servers or {})

  require('mason-lspconfig').setup {
    ensure_installed = ensure_installed,
    handlers = {
      function(server_name)
        local server = servers[server_name] or {}
        server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
        require('lspconfig')[server_name].setup(server)
      end,
    },
  }
end

return {
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
    'neovim/nvim-lspconfig',
    config = config_lsp,
    opts = {
      inlay_hints = true,
    },
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      -- 'hrsh7th/cmp-nvim-lsp',
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
