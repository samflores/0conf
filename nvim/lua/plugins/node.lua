return {
	{
		src = 'https://github.com/MunifTanjim/nui.nvim',
	},
	{
		src = 'https://github.com/vuki656/package-info.nvim',
		name = 'package-info.nvim',
		data = {
			ft = 'json',
			keys = {
			{
				lhs = '<space>ns',
				rhs = function()
					require('package-info').toggle()
				end,
				silent = true,
				noremap = true
			},
			{
				lhs = '<space>nu',
				rhs = function()
					require('package-info').update()
				end,
				silent = true,
				noremap = true
			},
			{
				lhs = '<space>nd',
				rhs = function()
					require('package-info').delete()
				end,
				silent = true,
				noremap = true
			},
			{
				lhs = '<space>ni',
				rhs = function()
					require('package-info').install()
				end,
				silent = true,
				noremap = true
			},
			{
				lhs = '<space>nc',
				rhs = function()
					require('package-info').change_version()
				end,
					silent = true,
					noremap = true
				}
			},
      before = function()
        vim.cmd.packadd('nui.nvim')
      end,
			after = function()
				require('package-info').setup()
			end,
		},
	},
}
