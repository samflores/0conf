local config = function()
  vim.api.nvim_exec([[
    imap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
    smap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
    imap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
    smap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
  ]], false)
end

return {
  'hrsh7th/vim-vsnip',
  dependencies = {
    'hrsh7th/vim-vsnip-integ',
    'rafamadriz/friendly-snippets'
  },
  event = 'UiEnter',
  config = config
}
