local config = function()
  vim.g.floaterm_width = 0.9
  vim.g.floaterm_height = 0.85
  vim.g.floaterm_keymap_toggle = '<Leader>ft'
end

return {
  'voldikss/vim-floaterm',
  config = config,
  keys = { '<leader>ft' }
}
