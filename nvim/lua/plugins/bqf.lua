local package = 'kevinhwang91/nvim-bqf'

local M = {}

local config = function()
  require('bqf').setup({
    auto_resize_height = false,
    magic_window = false
  })
end

function M.init(use)
  use {
    package,
    ft = 'qf',
    config = config
  }
end

return M
