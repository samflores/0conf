local config = function()
  require 'nvim-treesitter.configs'.setup {
    ensure_installed = {
      "css",
      "html",
      "javascript",
      "lua",
      "ruby",
      "rust",
      "svelte",
      "typescript",
      "markdown",
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
      enable = true,
      disable = { 'ruby' }
    },
    query_linter = {
      enable = true,
      use_virtual_text = true,
      lint_events = { "BufWrite", "CursorHold" },
    },
    matchup = {
      enable = true
    },
  }

  require 'nvim-treesitter.configs'.setup {
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
          ["]f"] = "@function.outer",
          ["]]"] = "@class.outer",
        },
        goto_next_end = {
          ["]F"] = "@function.outer",
          ["]["] = "@class.outer",
        },
        goto_previous_start = {
          ["[f"] = "@function.outer",
          ["[["] = "@class.outer",
        },
        goto_previous_end = {
          ["[F"] = "@function.outer",
          ["[]"] = "@class.outer",
        },
      },
    },
  }

  require 'nvim-treesitter.configs'.setup {
    context_commentstring = {
      enable = true
    }
  }

  vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
end

return {
  'nvim-treesitter/nvim-treesitter',
  dependencies = {
    'nvim-treesitter/playground',
    'nvim-treesitter/nvim-treesitter-textobjects',
    'JoosepAlviste/nvim-ts-context-commentstring',
  },
  config = config,
  build = function()
    require('nvim-treesitter.install').update({ with_sync = true })
  end,
  event = 'UiEnter',
  ft = {
    "css",
    "html",
    "javascript",
    "lua",
    "ruby",
    "rust",
    "svelte",
    "typescript",
    "markdown",
  }
}
