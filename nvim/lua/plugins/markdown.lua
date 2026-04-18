return {
  {
    src = 'https://github.com/brianhuster/live-preview.nvim',
    name = 'live-preview.nvim',
    data = {
      cmd = 'LivePreview',
    },
  },
  {
    src = 'https://github.com/OXY2DEV/markview.nvim.git',
    name = 'markview',
    data = {
      ft = { 'markdown' }
    }
  }
  -- {
  --   src = 'https://github.com/MeanderingProgrammer/render-markdown.nvim',
  --   name = 'render-markdown.nvim',
  --   data = {
  --     dep_of = 'avante.nvim',
  --     ft = { 'markdown', 'Avante' },
  --     after = function()
  --       require('render-markdown').setup({
  --         file_types = { 'markdown', 'Avante' },
  --       })
  --     end,
  --   },
  -- },
}
