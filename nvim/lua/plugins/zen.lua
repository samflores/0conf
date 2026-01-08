return {
  {
    src = 'https://github.com/folke/zen-mode.nvim',
    name = 'zen-mode.nvim',
    data = {
      cmd = 'ZenMode',
      after = function()
        require('zen-mode').setup({

        })
      end,
    },
  },
}
