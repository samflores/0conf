return {
  {
    src = 'https://github.com/night0721/ccc.nvim.git',
    name = 'ccc',
    data = {
      cmd = { 'CccPick', 'CccConvert', 'CccHighlighterEnable', 'CccHighlighterDisable', 'CccHighlighterToggle' },
      keys = {
        { lhs = '<leader>cp', rhs = '<cmd>CccPick<cr>',              desc = 'Pick' },
        { lhs = '<leader>cc', rhs = '<cmd>CccConvert<cr>',           desc = 'Convert' },
        { lhs = '<leader>ch', rhs = '<cmd>CccHighlighterToggle<cr>', desc = 'Toggle Highlighter' },
      },
      after = function()
        require('ccc').setup({
          highlighter = {
            auto_enable = true,
            lsp = true,
          },
        })
      end,
    }
  },
}
