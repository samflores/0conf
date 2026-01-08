return {
  {
    src = 'https://github.com/chrisgrieser/nvim-various-textobjs',
    name = 'nvim-various-textobjs',
    data = {
      event = 'DeferredUIEnter',
      after = function()
        require('various-textobjs').setup({
          keymaps = {
            useDefaults = true
          }
        })
      end,
    },
  },
  {
    src = 'https://github.com/echasnovski/mini.ai',
    name = 'mini.ai',
    data = {
      event = 'DeferredUIEnter',
    },
  },
}
