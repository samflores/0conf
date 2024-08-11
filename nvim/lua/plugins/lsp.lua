local config_lsp = function()
  local config = require('lspconfig')
  local snippet_capabilities = vim.lsp.protocol.make_client_capabilities()
  snippet_capabilities.textDocument.completion.completionItem.snippetSupport = true

  config.lemminx.setup {}
  config.steep.setup {}
  config.arduino_language_server.setup {}
  config.yamlls.setup {}
  config.dockerls.setup {}
  config.docker_compose_language_service.setup {}
  config.pylsp.setup {}
  config.bashls.setup {}
  config.clangd.setup {}
  config.clojure_lsp.setup {}
  config.cssls.setup {
    capabilities = snippet_capabilities
  }
  config.denols.setup {
    root_dir = config.util.root_pattern("deno.json", "deno.jsonc"),
  }
  -- config.emmet_ls.setup({
  --   capabilities = snippet_capabilities,
  --   filetypes = { "css", "eruby", "html", "javascript", "javascriptreact", "less", "sass", "scss", "svelte", "pug", "typescriptreact", "vue" },
  --   init_options = {
  --     html = {
  --       options = {
  --         -- For possible options, see: https://github.com/emmetio/emmet/blob/master/src/config.ts#L79-L267
  --         ["bem.enabled"] = true,
  --       },
  --     },
  --   }
  -- })
  config.graphql.setup {}
  config.html.setup {}
  config.jsonls.setup {}
  config.jdtls.setup {}
  config.lua_ls.setup {
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
          },
        },
      }
    }
  }
  config.ruby_lsp.setup {}
  -- config.standardrb.setup {}
  config.sqlls.setup {
    root_dir = function() return vim.fn.getcwd() end,
  }
  config.svelte.setup {}
  config.taplo.setup {}
  config.tsserver.setup {
    root_dir = config.util.root_pattern("package.json"),
    settings = {
      javascript = {
        inlayHints = {
          includeInlayEnumMemberValueHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
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
          includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
          includeInlayParameterNameHintsWhenArgumentMatchesName = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayVariableTypeHints = true,
        },
      },
    },
  }
end

return {
  {
    'williamboman/mason.nvim',
    priority = 50,
    event = 'UiEnter',
    opts = {
      ui = {
        icons = {
          package_installed = "",
          package_pending = "",
          package_uninstalled = "",
        },
      }
    }
  },
  {
    'williamboman/mason-lspconfig.nvim',
    priority = 60,
    event = 'UiEnter',
    config = true,
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
    },
  },
  {
    'neovim/nvim-lspconfig',
    priority = 70,
    config = config_lsp,
    lazy = false,
    event = 'UiEnter',
    opts = {
      inlay_hints = true
    },
  },
  {
    'folke/trouble.nvim',
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {},
    keys = {
      { "<leader>xx", function() require("trouble").toggle("diagnostics") end },
      { "<leader>xw", function() require("trouble").toggle("workspace_diagnostics") end },
      { "<leader>xd", function() require("trouble").toggle("document_diagnostics") end },
      { "<leader>xq", function() require("trouble").toggle("quickfix") end },
      { "<leader>xl", function() require("trouble").toggle("loclist") end },
      { "gR",         function() require("trouble").toggle("lsp_references") end },
    }
  },
  {
    "smjonas/inc-rename.nvim",
    config = true,
    keys = {
      { "<leader>rn", ":IncRename " }
    }
  },
}
