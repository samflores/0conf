return {
  {
    src = 'https://github.com/nvim-lua/plenary.nvim',
  },
  {
    src = 'https://github.com/chrishrb/gx.nvim',
    name = 'gx.nvim',
    data = {
      keys = { { lhs = 'gx', rhs = '<cmd>Browse<cr>', mode = { 'n', 'x' } } },
      cmd = { 'Browse' },
      before = function()
        vim.g.netrw_nogx = 1
      end,
      after = function()
        require('gx').setup()
      end,
    },
  },
}
