local package = 'voldikss/vim-floaterm'

local config = function()
  vim.g.floaterm_width = 0.9
  vim.g.floaterm_height = 0.85
  vim.g.floaterm_keymap_toggle = '<Leader>ft'
end

local M = {}

function M.init(use)
  use {
    package,
    config = config,
  }
end

return M
