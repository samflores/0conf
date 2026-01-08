return {
  {
    src = 'https://github.com/echasnovski/mini.align',
    name = 'mini.align',
    data = {
      event = 'BufReadPost',
      after = function()
        require('mini.align').setup()
      end,
    },
  },
}
