local package = 'voldikss/vim-floaterm'

local config = function()
  -- vim.api.nvim_exec([[
  --   let g:floaterm_width = 0.9
  --   let g:floaterm_height = 0.85
  -- ]], false)

  vim.g.floaterm_width = 0.9
  vim.g.floaterm_height = 0.85
end

local M = {}

function M.init(use)
  use {
    package,
    config = config,
  }
end

return M
