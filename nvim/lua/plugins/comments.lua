return {
  {
    'echasnovski/mini.comment',
    config = true,
    event = 'BufReadPost',
    opts = {
      options = {
        custom_commentstring = function()
          return require('ts_context_commentstring').calculate_commentstring() or vim.bo.commentstring
        end,
      },
    },
    dependencies = {
      'JoosepAlviste/nvim-ts-context-commentstring',
    },
  },
  {
    'folke/todo-comments.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    event = 'BufReadPost',
    opts = {},
    keys = {
      {
        ']t',
        function() require('todo-comments').jump_next() end,
        desc = 'Next todo comment'
      },
      {
        '[t',
        function() require('todo-comments').jump_prev() end,
        desc = 'Previous todo comment'
      },
      {
        '<leader>TT',
        function() require('todo-comments.fzf').todo() end,
        noremap = true,
        silent = true,
      },
    }
  }
}
