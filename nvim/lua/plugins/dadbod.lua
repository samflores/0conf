local package = 'kristijanhusak/vim-dadbod-ui'
local dependencies = {
  'tpope/vim-dadbod'
}

local config = function()
  vim.api.nvim_exec([[
    let g:dbs = {
    \ }
  ]], false)
end

local M = {}

function M.init(use)
  use {
    package ,
    requires = dependencies,
    config = config
  }
end

return M
