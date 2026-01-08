return {
  {
    src = 'https://github.com/kevinhwang91/nvim-bqf',
    name = 'nvim-bqf',
    data = {
      ft = 'qf',
      after = function()
        require('bqf').setup({
          auto_resize_height = false,
          magic_window = false
        })
      end,
    },
  },
}
