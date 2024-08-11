return {
	{
		'vhyrro/luarocks.nvim',
		priority = 1000, -- We'd like this plugin to load first out of the rest
		config = true, -- This automatically runs `require('luarocks-nvim').setup()`
	},
	{
		'nvim-neorg/neorg',
		dependencies = { 'nvim-neorg/neorg-telescope' },
		lazy = false,
		version = '*',
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
					-- ['core.integrations.telescope'] = {},
				},
			}
			local neorg_callbacks = require('neorg.core.callbacks')

			neorg_callbacks.on_event('core.keybinds.events.enable_keybinds', function(_, keybinds)
				-- Map all the below keybinds only when the 'norg' mode is active
				keybinds.map_event_to_mode('norg', {
					n = { -- Bind keys in normal mode
						{ '<C-s>', 'core.integrations.telescope.find_linkable' },
					},

					i = { -- Bind in insert mode
						{ '<C-l>', 'core.integrations.telescope.insert_link' },
					},
				}, {
					silent = true,
					noremap = true,
				})
			end)
		end,
	}
}
