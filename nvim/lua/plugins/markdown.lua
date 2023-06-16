local opt = { silent = true, noremap = true }

return {
  'iamcco/markdown-preview.nvim',
  keys = {
    { "<leader>md", ":MarkdownPreview<CR>", opt }
  },
  ft = 'markdown',
  build = 'cd app && yarn install'
}
