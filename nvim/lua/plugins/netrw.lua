return {
  {
    src = 'https://github.com/prichrd/netrw.nvim',
    name = 'netrw.nvim',
    data = {
      ft = 'netrw',
      after = function()
        require('netrw').setup()
      end,
    },
  },
}
