local package = 'catppuccin/nvim'

local config = function()
  vim.cmd([[
    colorscheme catppuccin

    hi StatusFilenameSeparator guifg=#dadae8 guibg=#1e1e29
    hi StatusFilenameText guifg=#1e1e29 guibg=#dadae8
  ]])
end

local M = {}

function M.init(use)
  -- use {
  --   package,
  --   as = "catppuccin",
  --   config = config
  -- }
  vim.cmd([[
    set rtp+=$HOME/Code/nvim-highlite/"
    colorscheme tswal
  ]])
end

return M
