local package = 'tpope/vim-jdaddy'
local filetypes = { 'json' }

local M = {}

function M.init(use)
  use { package, ft = filetypes }
end

return M
