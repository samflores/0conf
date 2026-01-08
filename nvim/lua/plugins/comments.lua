return {
  {
    src = 'https://github.com/JoosepAlviste/nvim-ts-context-commentstring',
    name = 'nvim-ts-context-commentstring',
    data = {
      dep_of = 'mini.comment',
      after = function()
        require('ts_context_commentstring').setup {}
      end
    },
  },
  {
    src = 'https://github.com/echasnovski/mini.comment',
    name = 'mini.comment',
    data = {
      event = 'BufReadPost',
      after = function()
        require('mini.comment').setup({
          options = {
            custom_commentstring = function()
              return require('ts_context_commentstring').calculate_commentstring() or vim.bo.commentstring
            end,
          },
        })
      end,
    },
  },
  {
    src = 'https://github.com/nvim-lua/plenary.nvim',
  },
  {
    src = 'https://github.com/folke/todo-comments.nvim',
    name = 'todo-comments.nvim',
    data = {
      event = 'BufReadPost',
      keys = {
        {
          lhs = ']t',
          rhs = function() require('todo-comments').jump_next() end,
          desc = 'Next todo comment'
        },
        {
          lhs = '[t',
          rhs = function() require('todo-comments').jump_prev() end,
          desc = 'Previous todo comment'
        },
        {
          lhs = '<leader>TT',
          rhs = function() require('todo-comments.fzf').todo() end,
          noremap = true,
          silent = true,
        },
      },
      after = function()
        require('todo-comments').setup({})
      end,
    },
  },
}
