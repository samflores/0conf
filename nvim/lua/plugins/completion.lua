return {
  {
    'saghen/blink.cmp',
    dependencies = {
      'Kaiser-Yang/blink-cmp-avante',
      -- { 'L3MON4D3/LuaSnip', version = 'v2.*' },
      'rafamadriz/friendly-snippets',
      'fang2hou/blink-copilot'
    },

    version = '*',

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
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
    },
    opts_extend = { 'sources.default' }
  },
}
