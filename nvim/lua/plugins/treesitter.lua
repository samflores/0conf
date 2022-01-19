local package = 'nvim-treesitter/nvim-treesitter'
local dependencies = {
  'nvim-treesitter/playground',
  'nvim-treesitter/nvim-treesitter-textobjects'
}
local run = ':TSUpdate'

local config = function()
  require'nvim-treesitter.configs'.setup {
    ensure_installed = {
      "css",
      "html",
      "javascript",
      "lua",
      "ruby",
      "rust",
      "svelte",
      "typescript",
    },
    highlight = {
      enable = true
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "gnn",
        node_incremental = "<C-right>",
        scope_incremental = "<C-up>",
        node_decremental = "<C-down>",
      },
    },
    indent = {
      enable = true
    },
    query_linter = {
      enable = true,
      use_virtual_text = true,
      lint_events = {"BufWrite", "CursorHold"},
    },
  }

  require'nvim-treesitter.configs'.setup {
    textobjects = {
      select = {
        enable = true,
        lookahead = true,
        keymaps = {
          ["af"] = "@function.outer",
          ["if"] = "@function.inner",
          ["ac"] = "@class.outer",
          ["ic"] = "@class.inner",
        },
      },
      swap = {
        enable = true,
        swap_next = {
          ["<leader>a"] = "@parameter.inner",
        },
        swap_previous = {
          ["<leader>A"] = "@parameter.inner",
        },
      },
      move = {
        enable = true,
        set_jumps = true,
        goto_next_start = {
          ["]m"] = "@function.outer",
          ["]]"] = "@class.outer",
        },
        goto_next_end = {
          ["]M"] = "@function.outer",
          ["]["] = "@class.outer",
        },
        goto_previous_start = {
          ["[m"] = "@function.outer",
          ["[["] = "@class.outer",
        },
        goto_previous_end = {
          ["[M"] = "@function.outer",
          ["[]"] = "@class.outer",
        },
      },
    },
  }
  vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
end

local M = {}

function M.init(use)
  use {
    package,
    requires = dependencies,
    run = run,
    config = config
  }
end

return M

