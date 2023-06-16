local opt = { noremap = true }

return {
  'tpope/vim-fugitive',
  dependencies = {
    'tpope/vim-rhubarb'
  },
  keys = {
    { 'gws', ':Git<CR>',                         opt },
    { 'gia', ':Gwrite<CR>',                      opt },
    { 'gco', ':Gread<CR>',                       opt },
    { 'gwd', ':vert :Gdiffsplit<CR>',            opt },
    { 'gcm', ':Git commit<CR>',                  opt },
    { 'gca', ':Gcommit --amend<CR>',             opt },
    { 'gpf', ':Git push --force-with-lease<CR>', opt },
    { 'gpp', ':Git push<CR>',                    opt },
    { 'grc', ':Git rebase --continue<CR>',       opt },
    { 'gra', ':Git rebase --abobrt<CR>',         opt },
  },
  cmd = { 'Git' },
}
