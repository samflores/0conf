return {
	'vuki656/package-info.nvim',
	dependencies = {
		'MunifTanjim/nui.nvim',
	},
	ft = 'json',
	config = true,
	keys = {
		{
			'<space>ns',
			function()
				require('package-info').toggle()
			end,
			silent = true,
			noremap = true
		},
		{
			'<space>nu',
			function()
				require('package-info').update()
			end,
			silent = true,
			noremap = true
		},
		{
			'<space>nd',
			function()
				require('package-info').delete()
			end,
			silent = true,
			noremap = true
		},
		{
			'<space>ni',
			function()
				require('package-info').install()
			end,
			silent = true,
			noremap = true
		},
		{
			'<space>nc',
			function()
				require('package-info').change_version()
			end,
			silent = true,
			noremap = true
		}
	}
}
