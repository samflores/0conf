return {
  {
    src = 'https://github.com/nvim-treesitter/nvim-treesitter',
  },
  {
    src = 'https://github.com/Wansmer/treesj',
    name = 'treesj',
    data = {
      keys = {
        { lhs = '<space>m' },
        { lhs = '<space>j' },
        { lhs = '<space>s' },
      },
      after = function()
        require('treesj').setup()
      end,
    },
  },
}
