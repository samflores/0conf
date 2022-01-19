local package = 'onsails/diaglist.nvim'
local filetypes = { 'rust', 'svelte' }

local M = {}

function M.init(use)
  use {
    package,
    ft = filetypes
  }
end

return M
