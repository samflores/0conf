return {
  {
    src = 'https://github.com/MunifTanjim/nui.nvim',
    name = 'nui.nvim'
  },
  {
    src = 'https://github.com/kndndrj/nvim-dbee',
    name = 'nvim-dbee',
    data = {
      cmd = {
        'Dbee'
      },
      keys = {
        { lhs = '<leader>D', rhs = function() require('dbee').toggle() end }
      },
      before = function()
        vim.cmd.packadd('nui.nvim')
      end,
      after = function()
        require('dbee').setup({
          drawer = {
            disable_help = false
          }
        })
      end,
    },
  },
}
