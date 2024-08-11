return {
  "folke/flash.nvim",
  event = "VeryLazy",
  ---@type Flash.Config
  opts = {},
  keys = {
    { "'",  mode = { "n", "x", "o" }, function() require("flash").jump() end,       desc = "Flash", },
    { "\"", mode = { "n", "o", "x" }, function() require("flash").treesitter() end, desc = "Flash Treesitter", },
    { "r",  mode = "o",               function() require("flash").remote() end,     desc = "Remote Flash", },
  },
}
