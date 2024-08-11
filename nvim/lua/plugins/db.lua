return {
  "kndndrj/nvim-dbee",
  dependencies = {
    "MunifTanjim/nui.nvim",
  },
  cmd = {
    'Dbee'
  },
  keys = {
    { '<leader>D', function() require("dbee").toggle() end, noremap = true, silent = true, desc = "Toggle DBEE" }
  },
  build = function()
    require("dbee").install()
  end,
  opts = {
    drawer = {
      disable_help = false
    }
  },
}
