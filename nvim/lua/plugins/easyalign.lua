local package = 'junegunn/vim-easy-align'

local config = function ()
  local map = vim.api.nvim_set_keymap

  map('v', '<Enter>', '<Plug>(EasyAlign)', {})
  map('n', 'ga', '<Plug>(EasyAlign)', {})
end

local M = {}

function M.init(use)
  use {
    package,
    config = config
  }
end

return M
