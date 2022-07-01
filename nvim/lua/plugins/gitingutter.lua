local package = 'lewis6991/gitsigns.nvim'
local dependencies = {
  'nvim-lua/plenary.nvim'
}

local M = {}

local config = function()
  require('gitsigns').setup {
    signcolumn                        = true, -- Toggle with `:Gitsigns toggle_signs`
    numhl                             = false, -- Toggle with `:Gitsigns toggle_numhl`
    linehl                            = false, -- Toggle with `:Gitsigns toggle_linehl`
    word_diff                         = false, -- Toggle with `:Gitsigns toggle_word_diff`
    watch_index                       = {
      interval = 1000,
      follow_files = true
    },
    attach_to_untracked               = true,
    current_line_blame                = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
    current_line_blame_opts           = {
      virt_text = true,
      virt_text_pos = 'right_align', -- 'eol' | 'overlay' | 'right_align'
      delay = 150,
    },
    current_line_blame_formatter_opts = {
      relative_time = false
    },
  }
end

function M.init(use)
  use {
    package,
    requires = dependencies,
    config = config
  }
end

return M
