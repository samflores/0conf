local package = 'tpope/vim-fugitive'

local config = function ()
  local map = vim.api.nvim_set_keymap
  local opt = { noremap = true }

  map('n', 'gws', ':Git<CR>', opt)
  map('n', 'gia', ':Gwrite<CR>', opt)
  map('n', 'gco', ':Gread<CR>', opt)
  map('n', 'gwd', ':vert :Gdiffsplit<CR>', opt)
  map('n', 'gcm', ':Git commit<CR>', opt)
  map('n', 'gca', ':Gcommit --amend<CR>', opt)
  map('n', 'gpf', ':Git push --force-with-lease<CR>', opt)
  map('n', 'gpp', ':Git push<CR>', opt)
  map('n', 'grc', ':Git rebase --continue<CR>', opt)
  map('n', 'gra', ':Git rebase --abobrt<CR>', opt)
end

local M = {}

function M.init(use)
  use {
    package,
    config = config
  }
end

return M
