return {
  {
    'rest-nvim/rest.nvim',
    ft = 'http',
    dependencies = { 'luarocks.nvim' },
    config = true,
    keys = {
      { '<leader>hh', '<Plug>RestNvim' },
      { '<leader>hu', '<Plug>RestNvimPreview' },
      { '<leader>hl', '<Plug>RestNvimLast' },
    },
  }
}
