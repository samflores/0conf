local package = 'tpope/vim-fireplace'
local filetypes = { 'clojure' }
local dependencies = {
  'guns/vim-sexp',
  'tpope/vim-sexp-mappings-for-regular-people',
  'eraserhd/parinfer-rust',
}

local M = {}

function M.init(use)
  use {
    package,
    ft = filetypes,
    requires = dependencies
  }
end

return M
