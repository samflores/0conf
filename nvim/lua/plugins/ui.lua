return {
  {
    src = 'https://github.com/j-hui/fidget.nvim',
    name = 'fidget.nvim',
    data = {
      event = 'VimEnter',
      after = function()
        require('fidget').setup({
          -- options
        })
      end,
    },
  },
  {
    src = 'https://github.com/echasnovski/mini.files',
    name = 'mini.files',
    data = {
      keys = {
        { lhs = '<leader>bb', rhs = function() require('mini.files').open() end },
        { lhs = '<leader>b.', rhs = function() require('mini.files').open(vim.api.nvim_buf_get_name(0)) end },
      },
      after = function()
        require('mini.files').setup({
          windows = {
            preview = true,
            width_preview = 55,
          },
        })
      end,
    },
  },
}
