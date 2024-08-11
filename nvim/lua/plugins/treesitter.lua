local config = function()
  require 'nvim-treesitter.configs'.setup {
    ensure_installed = {
      "css",
      "haskell",
      "html",
      "javascript",
      "lua",
      "markdown",
      "ruby",
      "rust",
      "scss",
      "sql",
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
      enable = true,
      -- disable = { 'ruby' }
    },
    query_linter = {
      enable = true,
      use_virtual_text = true,
      lint_events = { "BufWrite", "CursorHold" },
    },
    matchup = {
      enable = true
    },
    textobjects = {
      select = {
        enable = true,
        lookahead = true,
        keymaps = {
          ["af"] = "@function.outer",
          ["if"] = "@function.inner",
          ["ac"] = "@class.outer",
          ["ic"] = "@class.inner",
          ["ia"] = "@parameter.inner",
          ["aa"] = "@parameter.outer",
          ["ib"] = "@block.inner",
          ["ab"] = "@block.outer",
          ["ae"] = "@element",
        },
      },
      swap = {
        enable = true,
        swap_next = {
          [">a"] = "@parameter.inner",
          [">e"] = "@element",
        },
        swap_previous = {
          ["<a"] = "@parameter.inner",
          ["<e"] = "@element",
        },
      },
      move = {
        enable = true,
        set_jumps = true,
        goto_next_start = {
          ["]f"] = "@function.outer",
          ["]c"] = "@class.outer",
          ["]a"] = "@parameter.inner",
        },
        goto_next_end = {

          ["]F"] = "@function.outer",
          ["]C"] = "@class.outer",
          ["]A"] = "@parameter.outer",
        },
        goto_previous_start = {
          ["[f"] = "@function.outer",
          ["[c"] = "@class.outer",
          ["[a"] = "@parameter.inner",
        },
        goto_previous_end = {
          ["[F"] = "@function.outer",
          ["[C"] = "@class.outer",
          ["[A"] = "@parameter.outer",
        },
      },
    },
  }

  vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
  require('ts_context_commentstring').setup {}
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
    "sql",
  }
}
