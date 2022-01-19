local package = 'lukas-reineke/indent-blankline.nvim'

local M = {}

local config = function()
  vim.api.nvim_exec([[
    let g:indent_blankline_filetype_exclude = ['help', 'alpha']
  ]], false)

  require("indent_blankline").setup {
    space_char_blankline = " ",
    show_current_context = true,
    show_current_context_start = true,
  }
end

function M.init(use)
  use {
    package,
    config = config
  }
end

return M
