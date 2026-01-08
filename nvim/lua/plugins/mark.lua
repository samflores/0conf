return {
  {
    src = 'https://github.com/chentoast/marks.nvim',
    name = 'marks.nvim',
    data = {
      keys = {
        { lhs = 'm,' },
        { lhs = 'm;' },
        { lhs = 'dm-' },
        { lhs = 'dm<space>' },
        { lhs = 'm]' },
        { lhs = 'm[' },
        { lhs = 'm:' },
        { lhs = 'm[0-9]' },
        { lhs = 'dm[0-9]' },
        { lhs = 'm}' },
        { lhs = 'm{' },
        { lhs = 'dm=' },
      },
      after = function()
        require('marks').setup({
          builtin_marks = { '.', '<', '>', '^' },
        })
      end,
    },
  },
}
