return {
  {
    src = 'https://github.com/nvim-lua/plenary.nvim',
  },
  {
    src = 'https://github.com/jiaoshijie/undotree',
    name = 'undotree',
    data = {
      keys = {
        { lhs = '<leader>u', rhs = function() require('undotree').toggle() end },
      },
      after = function()
        require('undotree').setup()
      end,
    },
  },
}
