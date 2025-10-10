return {
  {
    'nvim-neorg/neorg',
    dependencies = {
      {
        'vhyrro/luarocks.nvim',
        -- priority = 1000,
        config = true,
      },
    },
    version = '*',
    cmd = 'Neorg',
    -- config = true
    config = function()
      require('neorg').setup {
        load = {
          ['core.defaults'] = {},
          ['core.concealer'] = {
            config = {
              icon_preset = 'diamond',
            },
          },
          ['core.dirman'] = {
            config = {
              workspaces = {
                personal = '~/notes/personal',
                work = '~/notes/work',
              },
              default_workspace = 'personal',
            },
          },
          -- ['core.completion'] = {
          -- 	config = {
          -- 		engine = 'nvim-cmp',
          -- 	},
          -- },
          -- ['core.itero'] = {},
          -- ['core.promo'] = {},
          -- ['core.keybinds'] = {},
          -- ['core.summary'] = {},
        },
      }
      local neorg_callbacks = require('neorg.core.callbacks')

      neorg_callbacks.on_event('core.keybinds.events.enable_keybinds', function(_, keybinds)
        -- Map all the below keybinds only when the 'norg' mode is active
        keybinds.map_event_to_mode('norg', {
          --
        }, {
          silent = true,
          noremap = true,
        })
      end)
    end,
  },
}
