local noremap_opt = { noremap = true }

return {
  'kazhala/close-buffers.nvim',
  keys = {
    {
      '<leader>kk',
      function() require('close_buffers').delete({ type = 'this' }) end,
      noremap_opt
    },
    {
      '<leader>ku',
      function() require('close_buffers').delete({ type = 'nameless' }) end,
      noremap_opt
    },
    {
      '<leader>kh',
      function() require('close_buffers').delete({ type = 'nameless' }) end,
      noremap_opt
    },
    {
      '<leader>ko',
      function() require('close_buffers').delete({ type = 'other' }) end,
      noremap_opt
    },
    {
      '<leader>ka',
      function() require('close_buffers').delete({ type = 'all' }) end,
      noremap_opt
    },
  },
  config = true,
}
