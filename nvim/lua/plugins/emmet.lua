local package = 'mattn/emmet-vim'
local filetypes = {
  'css',
  'eruby',
  'hbs',
  'html',
  'scss',
  'svelte',
  'vue',
}

local M = {}

function M.init(use)
  use {
    package ,
    ft = filetypes
  }
end

return M
