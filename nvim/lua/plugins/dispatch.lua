local package = 'tpope/vim-dispatch'
local commands = {'Dispatch', 'Make', 'Focus', 'Start'}

local M = {}

function M.init(use)
  use { package, cmd = commands }
end

return M
