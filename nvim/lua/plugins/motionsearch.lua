local package = 'rlane/pounce.nvim'

local config = function()
  require('pounce').setup({
    accept_keys = "JFKDLSAHGNUVRBYTMICEOXWPQZ",
    debug = false,
  })
  local map = vim.api.nvim_set_keymap
  local opt = { silent = true, noremap = true }

  map('n', '<leader>/', "<cmd>Pounce<CR>", opt)
end

local M = {}

function M.init(use)
  use {
    package,
    config = config
  }
end

return M
