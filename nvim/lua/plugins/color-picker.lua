return {
  "uga-rosa/ccc.nvim",
  opts = {
    highlighter = {
      auto_enable = true,
      lsp = true,
    },
  },
  cmd = { "CccPick", "CccConvert", "CccHighlighterEnable", "CccHighlighterDisable", "CccHighlighterToggle" },
  keys = {
    { "<leader>cp", "<cmd>CccPick<cr>",              desc = "Pick" },
    { "<leader>cc", "<cmd>CccConvert<cr>",           desc = "Convert" },
    { "<leader>ch", "<cmd>CccHighlighterToggle<cr>", desc = "Toggle Highlighter" },
  },
}
