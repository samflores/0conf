return {
  'gbprod/yanky.nvim',
  config = true,
  keys = {
    { 'p',     '<Plug>(YankyPutAfter)',      desc = 'Put after',     mode = { 'n', 'x' } },
    { 'P',     '<Plug>(YankyPutBefore)',     desc = 'Put before',    mode = { 'n', 'x' } },
    { 'gp',    '<Plug>(YankyGPutAfter)',     desc = 'GPut after',    mode = { 'n', 'x' } },
    { 'gP',    '<Plug>(YankyGPutBefore)',    desc = 'GPut before',   mode = { 'n', 'x' } },
    { '<C-p>', '<Plug>(YankyPreviousEntry)', desc = 'Previous entry' },
    { '<C-n>', '<Plug>(YankyNextEntry)',     desc = 'Next entry' },
  },
}
