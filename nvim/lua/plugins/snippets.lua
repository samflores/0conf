local package = 'hrsh7th/vim-vsnip'
local dependencies = {
  'hrsh7th/vim-vsnip-integ',
  'rafamadriz/friendly-snippets'
}

local M = {}

function M.init(use)
  use {
    package,
    requires = dependencies,
  }
end

return M
