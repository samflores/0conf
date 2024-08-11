return {
  {
    "vhyrro/luarocks.nvim",
    priority = 1000,
    config = true,
    opts = {
      rocks = { "lua-curl", "nvim-nio", "mimetypes", "xml2lua" }
    }
  },
  {
    "rest-nvim/rest.nvim",
    ft = "http",
    dependencies = { "luarocks.nvim" },
    config = true,
    keys = {
      { '<leader>hh', '<Plug>RestNvim' },
      { '<leader>hu', '<Plug>RestNvimPreview' },
      { '<leader>hl', '<Plug>RestNvimLast' },
    },
  }
}
