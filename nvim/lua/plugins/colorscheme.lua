return {
  {
    src = 'git@github.com:samflores/gypsum.nvim.git',
    name = 'gypsum',
    data = {
      event = 'VimEnter',
      after = function()
        vim.o.background = 'light'
        require('gypsum').setup({
          bg = true,
          italic_strings = false,
        })
        vim.cmd([[colorscheme gypsum]])
      end,
    },
  },
}
