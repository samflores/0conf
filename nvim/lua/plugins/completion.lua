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
}

local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
  local col = vim.fn.col('.') - 1
  return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s')
end

local config = function()
  local cmp = require'cmp'

  cmp.setup({
    snippet = {
      expand = function(args)
        -- For `vsnip` user.
        vim.fn["vsnip#anonymous"](args.body)

        -- For `luasnip` user.
        -- require('luasnip').lsp_expand(args.body)

        -- For `ultisnips` user.
        -- vim.fn["UltiSnips#Anon"](args.body)
      end,
    },
    mapping = {
      ['<C-d>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.close(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
      ['<Tab>'] = function(fallback)
        if vim.fn.pumvisible() == 1 then
          return cmp.select_next_item()
        elseif vim.fn["vsnip#jumpable"](1) then
          t('<Plug>(vsnip-expand-or-jump)')
        elseif check_back_space() then
          print("3")
          fallback()
        else
          print("4")
          fallback()
        end
      end
      -- , { 'i', 's' }),
    },
    sources = {
      { name = 'nvim_lsp' },
      { name = 'vsnip' },
      { name = 'buffer' },
      { name = 'calc' },
      { name = 'path' },
      { name = 'emoji' },
      { name = 'cmp_git' },
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
