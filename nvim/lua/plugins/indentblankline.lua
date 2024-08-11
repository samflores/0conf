return {
	'lukas-reineke/indent-blankline.nvim',
	main = "ibl",
	opts = {
		indent = {
			tab_char = "▏",
			char = "▏",
			-- exclude = { 'help' }
		},
		scope = {
			char = "▏",
		},
	},
	event = 'UiEnter',
}
