local package = 'hrsh7th/nvim-cmp'
local dependencies = {
  'hrsh7th/cmp-nvim-lsp',
  'hrsh7th/cmp-vsnip',
  'hrsh7th/cmp-buffer',
  'hrsh7th/cmp-path',
  'hrsh7th/cmp-calc',
  'hrsh7th/cmp-cmdline',
  'hrsh7th/cmp-emoji',
  'petertriho/cmp-git',
  'onsails/lspkind-nvim',
}

local config = function()
  local lspkind = require('lspkind')
  lspkind.init({})
  local cmp = require 'cmp'

  cmp.setup({
    snippet = {
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body)
      end,
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
      ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
      ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
      ['<C-e>'] = cmp.mapping({
        i = cmp.mapping.abort(),
        c = cmp.mapping.close(),
      }),
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'vsnip' },
      { name = 'buffer' },
      { name = 'calc' },
      { name = 'path' },
      { name = 'emoji' },
      { name = 'cmp_git' },
    }, {
      { name = 'buffer' },
    }),
    formatting = {
      format = lspkind.cmp_format {
        with_text = true,
      },
    },
    experimental = {
      ghost_text = true,
    }
  })
  cmp.setup.cmdline(':', {
    sources = {
      { name = 'cmdline' }
    }
  })
  cmp.setup.cmdline('/', {
    sources = {
      { name = 'buffer' }
    }
  })
  local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
  require('lspconfig')['svelte'].setup { capabilities = capabilities }
end

local M = {}

function M.init(use)
  use {
    package,
    requires = dependencies,
    config = config,
  }
end

return M
