local config = function()
  vim.g.indent_blankline_filetype_exclude = { 'help', 'alpha' }
  vim.g.indent_blankline_char = '▎'

  require("indent_blankline").setup {
    char = "▎",
    context_char = "▎",
    space_char_blankline = " ",
    show_current_context = true,
    show_current_context_start = true,
  }
end

return {
  'lukas-reineke/indent-blankline.nvim',
  config = config,
  event = 'UiEnter',
}
