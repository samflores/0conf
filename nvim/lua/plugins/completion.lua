local config = function()
	local cmp = require 'cmp'
	local lspkind = require('lspkind')

	lspkind.init({ symbol_map = { Copilot = "" } })
	vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })

	cmp.setup({
		snippet = {
			expand = function(args)
				vim.snippet.expand(args.body)
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
			['<Tab>'] = cmp.mapping(function(fallback)
				if vim.snippet.active({ direction = 1 }) then
					vim.snippet.jump(1)
				else
					fallback()
				end
			end, { 'i', 's' }),
			['<S-Tab>'] = cmp.mapping(function(fallback)
				if vim.snippet.active({ direction = -1 }) then
					vim.snippet.jump(-1)
				else
					fallback()
				end
			end, { 'i', 's' }),
		}),
		sources = cmp.config.sources(
			{
				{ name = 'nvim_lsp' },
				{ name = 'vsnip' },
				{ name = 'nvim_lsp_signature_help' },
				-- { name = 'neorg' },
				{ name = 'calc' },
				{ name = 'path' },
				{ name = 'emoji' },
				-- { name = 'copilot' },
			},
			{
				{ name = 'buffer' },
			}
		),
		window = {
			completion = {
				winhighlight = 'Normal:ColorColum,FloatBorder:ColorColum,Search:CurSearch',
				col_offset = -3,
				side_padding = 0,
			},
		},
		formatting = {
			fields = { "kind", "abbr", "menu" },

			format = function(entry, vim_item)
				local kind = require("lspkind").cmp_format({
					mode = "symbol_text",
					maxwidth = 50
				})(entry, vim_item)

				local strings = vim.split(kind.kind, "%s", { trimempty = true })
				kind.kind = " " .. (strings[1] or "") .. " "
				kind.menu = "    " .. (({
					nvim_lsp = "[LSP]",
					vsnip = "[Snippet]",
					nvim_lsp_signature_help = "[signature]",
					calc = "[Calc]",
					path = "[Path]",
					copilot = "[Copilot]",
					buffer = "[Buffer]",
				})[entry.source.name] or "")

				return kind
			end,
		},
		-- experimental = { ghost_text = true, }
	})

	require('cmp-dbee').setup({})
	cmp.setup.filetype('sql', {
		sources = cmp.config.sources({
			{ name = 'cmp-dbee' },
		}, {
			{ name = 'buffer' },
		})
	})

	cmp.setup.filetype('gitcommit', {
		sources = cmp.config.sources({
			{ name = 'git' },
		}, {
			{ name = 'buffer' },
		})
	})

	cmp.setup.cmdline({ '/', '?' }, {
		mapping = cmp.mapping.preset.cmdline(),
		sources = {
			{ name = 'buffer' }
		}
	})

	cmp.setup.cmdline(':', {
		mapping = cmp.mapping.preset.cmdline(),
		sources = cmp.config.sources({
			{ name = 'path' }
		}, {
			{ name = 'cmdline' }
		})
	})
end

return {
	{
		'hrsh7th/nvim-cmp',
		dependencies = {
			'hrsh7th/cmp-vsnip',
			'hrsh7th/cmp-buffer',
			'hrsh7th/cmp-path',
			'hrsh7th/cmp-calc',
			'hrsh7th/cmp-nvim-lsp-signature-help',
			'hrsh7th/cmp-cmdline',
			'hrsh7th/cmp-emoji',
			'petertriho/cmp-git',
			'onsails/lspkind.nvim',
			{
				"MattiasMTS/cmp-dbee",
				dependencies = {
					{ "kndndrj/nvim-dbee" }
				},
				ft = "sql",
				opts = {},
			},
		},
		config = config,
		event = "InsertEnter",
	},
}
