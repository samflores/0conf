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
        })
        vim.cmd([[colorscheme gypsum]])
      end,
    },
  },
}
