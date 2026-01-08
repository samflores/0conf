return {
  {
    src = 'https://github.com/gbprod/yanky.nvim',
    name = 'yanky.nvim',
    data = {
      event = 'DeferredUIEnter',
      keys = {
        { lhs = 'p',     rhs = '<Plug>(YankyPutAfter)',      desc = 'Put after',     mode = { 'n', 'x' } },
        { lhs = 'P',     rhs = '<Plug>(YankyPutBefore)',     desc = 'Put before',    mode = { 'n', 'x' } },
        { lhs = 'gp',    rhs = '<Plug>(YankyGPutAfter)',     desc = 'GPut after',    mode = { 'n', 'x' } },
        { lhs = 'gP',    rhs = '<Plug>(YankyGPutBefore)',    desc = 'GPut before',   mode = { 'n', 'x' } },
        { lhs = '<C-p>', rhs = '<Plug>(YankyPreviousEntry)', desc = 'Previous entry' },
        { lhs = '<C-n>', rhs = '<Plug>(YankyNextEntry)',     desc = 'Next entry' },
      },
      after = function()
        require('yanky').setup()
      end,
    },
  },
}
