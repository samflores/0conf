return {
  'rest-nvim/rest.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  keys = {
    { '<leader>hh', '<Plug>RestNvim' },
    { '<leader>hu', '<Plug>RestNvimPreview' },
    { '<leader>hl', '<Plug>RestNvimLast' },
  },
  config = true
}
