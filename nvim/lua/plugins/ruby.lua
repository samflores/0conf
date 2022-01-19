local package = 'tpope/vim-rails'
local filetypes = { 'ruby', 'eruby', 'slim', 'yml', 'yaml' }
local dependencies = {
  'jgdavey/vim-blockle',
  'sunaku/vim-ruby-minitest',
  'slim-template/vim-slim'
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
