local config = function()
  vim.g.tmux_navigator_save_on_switch = 2
  vim.g.tmux_navigator_preserve_zoom = 1
  -- vim.g.tmux_navigator_disable_when_zoomed = 1
end

return {
  'christoomey/vim-tmux-navigator',
  config = config,
  cmd = {
    'TmuxNavigateLeft',
    'TmuxNavigateDown',
    'TmuxNavigateUp',
    'TmuxNavigateRight',
    'TmuxNavigatePrevious',
  },
  keys = {
    { '<c-h>',  '<cmd><C-U>TmuxNavigateLeft<cr>' },
    { '<c-j>',  '<cmd><C-U>TmuxNavigateDown<cr>' },
    { '<c-k>',  '<cmd><C-U>TmuxNavigateUp<cr>' },
    { '<c-l>',  '<cmd><C-U>TmuxNavigateRight<cr>' },
    { '<c-\\>', '<cmd><C-U>TmuxNavigatePrevious<cr>' },
  },
}
