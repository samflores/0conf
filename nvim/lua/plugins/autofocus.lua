local package = 'beauwilliams/focus.nvim'

local M = {}

local config = function()
  require("focus").setup({
    cursorline = false,
    excluded_buftypes = {'nofile', 'nowrite', 'prompt', 'popup', 'quickfix'}
  })
end

function M.init(use)
  use {
    package,
    config = config
  }
end

return M
