local noremap_opt = { noremap = true }

return {
  {
    src = 'https://github.com/kazhala/close-buffers.nvim',
    name = 'close-buffers.nvim',
    data = {
      keys = {
      {
        lhs = '<leader>kk',
        rhs = function() require('close_buffers').delete({ type = 'this' }) end,
      },
      {
        lhs = '<leader>ku',
        rhs = function() require('close_buffers').delete({ type = 'nameless' }) end,
      },
      {
        lhs = '<leader>kh',
        rhs = function() require('close_buffers').delete({ type = 'nameless' }) end,
      },
      {
        lhs = '<leader>ko',
        rhs = function() require('close_buffers').delete({ type = 'other' }) end,
      },
      {
        lhs = '<leader>ka',
        rhs = function() require('close_buffers').delete({ type = 'all' }) end,
      },
      },
      after = function()
        require('close_buffers').setup()
      end,
    },
  },
}
