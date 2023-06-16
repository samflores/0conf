return {
  {
    'levouh/tint.nvim',
    opts = {
      tint = -80,
    },
    event = 'UiEnter',
  },
  {
    'beauwilliams/focus.nvim',
    event = 'UiEnter',
    opts = {
      cursorline = false,
      excluded_buftypes = { 'nofile', 'nowrite', 'prompt', 'popup', 'quickfix' }
    }
  }
}
