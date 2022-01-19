local package = 'tpope/vim-eunuch'
local commands = { 'Mkdir', 'Unlink', 'Move' }

local M = {}

function M.init(use)
  use { package, cmd = commands }
end

return M
