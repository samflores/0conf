local package = 'editorconfig/editorconfig-vim'

local config = function()
  -- vim.api.nvim_exec([[
  --   let g:EditorConfig_exclude_patterns = ['fugitive://.*']
  -- ]], false)
  vim.g.EditorConfig_exclude_patterns = { 'fugitive://.*' }
end

local M = {}

function M.init(use)
  use {
    package,
    config = config
  }
end

return M
