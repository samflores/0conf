local package = 'camspiers/snap'
local rocks = { 'fzy' }

local config = function()
  local has_snap = pcall(require, "snap")

  if not has_snap then
    return
  end

  local snap = require"snap"
  local config = snap.config
  local M = {}

  local fd_args = { '-t', 'f' }

  local custom_mappings = {
    ["view-toggle-hide"] = {"?"}
  }

  local defaults = {
    prompt = " >",
    suffix = "",
    consumer = "fzy",
    mappings = custom_mappings,
    preview_min_width = 80
  }

  local function file(opts)
    local options = vim.tbl_extend("force", defaults, opts or {})

    return config.file:with(options)
  end

  local vimgrep =
    config.vimgrep:with(
      vim.tbl_extend(
        "force",
        defaults,
        {
          prompt = " /",
          -- filter_with = "cword",
          limit = 50000
        }
      )
    )

  function M.setup()
    snap.maps {
      { "<leader>oo", file() {args = fd_args, try = { "fd.file" } }, {command = "files"} },
      { "<leader>og", file() {producer = "git.file"}, {command = "git.files"} },
      { "<leader>ob", file() {producer = "vim.buffer"}, {command = "buffers"} },
      { "<leader>gg", vimgrep {}, {command = "grep"} },
      { "<leader>oh", file() {producer = "vim.oldfile"}, {command = "oldfiles"} },
      { "<leader>oH", file() {combine = {"vim.buffer", "vim.oldfile"}} }
    }

    snap.register.map(
      {"n"},
      {"<leader>h"},
      function()
        snap.run {
          reverse = true,
          prompt = "?",
          producer = snap.get "consumer.fzy"(snap.get "producer.vim.help"),
          select = snap.get "select.help".select,
          views = {snap.get "preview.help"},
          mappings = custom_mappings
        }
      end
    )

    snap.register.map(
      {"n"},
      {"<leader>o."},
      function()
        snap.run(vim.tbl_extend("force", defaults, {
          producer = snap.get'consumer.fzy'(
            snap.get'producer.ripgrep.file'.args(
              {},
              vim.fn.fnamemodify(vim.fn.bufname(), ":p:.:h")
            )
          ),
          select = snap.get'select.file'.select,
          multiselect = snap.get'select.file'.multiselect,
          views = {snap.get'preview.file'}
        }))
      end
    )

    snap.register.map(
      {"n"},
      {"<leader>ov"},
      function()
        snap.run(vim.tbl_extend("force", defaults, {
          producer = snap.get'consumer.fzy'(
            snap.get'producer.ripgrep.file'.args(
              { cwd = "/home/samflores/.config/nvim" },
              "/home/samflores/.config/nvim"
            )
          ),
          select = snap.get'select.file'.select,
          multiselect = snap.get'select.file'.multiselect,
          views = {snap.get'preview.file'}
        }))
      end
    )
  end

  M.setup()
end

local M = {}

function M.init(use)
  use {
    package,
    rocks = rocks,
    config = config
  }
end

return M
