local package = 'hood/popui.nvim'
local dependencies = {
  'RishabhRD/popfix'
}

local M = {}

local config = function()
  vim.ui.select = require'popui.ui-overrider'
end

function M.init(use)
  use {
    package,
    config = config,
    requires = dependencies
  }
end

return M

