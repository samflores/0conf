local package = 'iamcco/markdown-preview.nvim'

local config = function()
  local map = vim.api.nvim_set_keymap
  local opt = { silent = true, noremap = true }

  map("n", "<leader>md", ":MarkdownPreview<CR>", opt)
end

local M = {}

function M.init(use)
  use {
    package,
    config = config
  }
end

return M
