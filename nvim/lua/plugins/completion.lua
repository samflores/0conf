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
    window = {
      completion = {
        winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
        col_offset = -3,
        side_padding = 0,
      },
    },
    formatting = {
      fields = { "kind", "abbr", "menu" },
      format = function(entry, vim_item)
        local kind = require("lspkind").cmp_format({ mode = "symbol_text", maxwidth = 50 })(entry, vim_item)
        local strings = vim.split(kind.kind, "%s", { trimempty = true })
        kind.kind = " " .. (strings[1] or "") .. " "
        kind.menu = "    (" .. (strings[2] or "") .. ")"

        return kind
      end,
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
  -- local capabilities = require('cmp_nvim_lsp').default_capabilities();
  -- require('lspconfig')['svelte'].setup { capabilities = capabilities }
  -- require('lspconfig')['clangd'].setup { capabilities = capabilities }
end

return {
  'hrsh7th/nvim-cmp',
  dependencies = {
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-vsnip',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-calc',
    'hrsh7th/cmp-cmdline',
    'hrsh7th/cmp-emoji',
    'petertriho/cmp-git',
    'onsails/lspkind.nvim'
  },
  config = config,
  event = "InsertEnter",
}
