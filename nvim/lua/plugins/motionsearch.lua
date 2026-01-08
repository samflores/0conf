return {
  {
    src = 'https://github.com/folke/flash.nvim',
    name = 'flash.nvim',
    data = {
      keys = {
      { lhs = "'",  mode = { 'n', 'x', 'o' }, rhs = function() require('flash').jump() end,       desc = 'Flash', },
      { lhs = '"', mode = { 'n', 'o', 'x' }, rhs = function() require('flash').treesitter() end, desc = 'Flash Treesitter', },
        { lhs = 'r',  mode = 'o',               rhs = function() require('flash').remote() end,     desc = 'Remote Flash', },
      },
      after = function()
        require('flash').setup({})
      end,
    },
  },
}
