local config = function()
  vim.g.tmux_navigator_save_on_switch = 2
  vim.g.tmux_navigator_disable_when_zoomed = 1
end

return {
  'christoomey/vim-tmux-navigator',
  config = config,
  event = 'UiEnter',
}
