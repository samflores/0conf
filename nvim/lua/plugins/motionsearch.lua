return {
  'ggandor/leap.nvim',
  dependencies = {
    'tpope/vim-repeat',
  },
  keys = {
    { '\'', '<Plug>(leap-forward)' },
    { '"',  '<Plug>(leap-backward)' },
  },
}
