return {
  {
    src = 'https://github.com/kylechui/nvim-surround',
    name = 'nvim-surround',
    data = {
      event = 'DeferredUIEnter',
      after = function()
        require('nvim-surround').setup({
          -- Configuration here, or leave empty to use defaults
        })
      end,
    },
  },
}
