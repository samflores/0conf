return {
  {
    src = 'https://github.com/saghen/blink.cmp.git',
    name = 'blink.cmp',
    data = { 
      event = 'DeferredUIEnter',
      after = function()
        require('blink.cmp').setup({
          keymap = { preset = 'default' },
          -- snippets = { preset = 'luasnip' },

          appearance = {
            kind_icons = {
              Copilot = '',
            },
          },
          sources = {
            default = {
              'lsp',
              'path',
              'snippets',
              'buffer',
              'copilot',
              'avante',
            },
            providers = {
              avante = {
                module = 'blink-cmp-avante',
                name = 'Avante',
                opts = {
                  -- options for blink-cmp-avante
                }
              },
              copilot = {
                name = 'copilot',
                module = 'blink-copilot',
                score_offset = 100,
                async = true,
              },
            },
          },
          signature = { enabled = true }
        })
      end
      -- opts_extend = { 'sources.default' }
    },
  },
  {
    src = 'https://github.com/Kaiser-Yang/blink-cmp-avante.git',
    data = { dep_of = 'blink.cmp' }
  },
  { 
    src = 'https://github.com/rafamadriz/friendly-snippets.git',
    data = { dep_of = 'blink.cmp' }
  },
  { 
    src = 'https://github.com/fang2hou/blink-copilot.git',
    data = { dep_of = 'blink.cmp' }
  },
}
-- { 'L3MON4D3/LuaSnip', version = 'v2.*' },
