return {
  {
    src = 'https://github.com/alexghergh/nvim-tmux-navigation',
    name = 'nvim-tmux-navigation',
    data = {
      after = function()
        require('nvim-tmux-navigation').setup({
          disable_when_zoomed = true,
        })
      end,
      event = 'DeferredUIEnter',
      keys = {
        { lhs = '<c-h>',     rhs = function() require('nvim-tmux-navigation').NvimTmuxNavigateLeft() end },
        { lhs = '<c-j>',     rhs = function() require('nvim-tmux-navigation').NvimTmuxNavigateDown() end },
        { lhs = '<c-k>',     rhs = function() require('nvim-tmux-navigation').NvimTmuxNavigateUp() end },
        { lhs = '<c-l>',     rhs = function() require('nvim-tmux-navigation').NvimTmuxNavigateRight() end },
        { lhs = '<c-\\>',    rhs = function() require('nvim-tmux-navigation').NvimTmuxNavigateLastActive() end },
        { lhs = '<c-space>', rhs = function() require('nvim-tmux-navigation').NvimTmuxNavigateNext() end },
      },
    },
  },
}
