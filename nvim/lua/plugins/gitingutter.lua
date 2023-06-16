local config = function()
  require('gitsigns').setup {
    signcolumn                        = true,  -- Toggle with `:Gitsigns toggle_signs`
    numhl                             = false, -- Toggle with `:Gitsigns toggle_numhl`
    linehl                            = false, -- Toggle with `:Gitsigns toggle_linehl`
    word_diff                         = false, -- Toggle with `:Gitsigns toggle_word_diff`
    watch_gitdir                      = {
      interval = 1000,
      follow_files = true
    },
    attach_to_untracked               = true,
    current_line_blame                = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
    current_line_blame_opts           = {
      virt_text = true,
      virt_text_pos = 'right_align', -- 'eol' | 'overlay' | 'right_align'
      delay = 3000,
    },
    current_line_blame_formatter_opts = {
      relative_time = false
    },
  }
end

return {
  'lewis6991/gitsigns.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim'
  },
  event = 'UiEnter',
  config = config
}
