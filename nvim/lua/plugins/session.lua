return {
  {
    src = 'https://github.com/echasnovski/mini.sessions',
    name = 'mini.sessions',
    data = {
      -- event = 'VimEnter',
      after = function()
        require('mini.sessions').setup({
          autoread = true,
        })
      end,
    },
  },
}
