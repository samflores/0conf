return {
  'echasnovski/mini.comment',
  config = true,
  event = 'UiEnter',
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
}
