return {
  {
    src = 'https://github.com/nvim-treesitter/nvim-treesitter',
  },
  {
    src = 'https://github.com/stevearc/dressing.nvim',
    data = {
      dep_of = 'avante.nvim',
    },
  },
  {
    src = 'https://github.com/MunifTanjim/nui.nvim',
  },
  {
    src = 'https://github.com/nvim-tree/nvim-web-devicons',
  },
  {
    src = 'https://github.com/zbirenbaum/copilot.lua',
    name = 'copilot.lua',
    data = {
      dep_of = 'avante.nvim',
      cmd = 'Copilot',
      event = 'DeferredUIEnter',
      after = function()
        require('copilot').setup({})
      end,
    },
  },
  {
    src = 'https://github.com/coder/claudecode.nvim.git',
    data = {
      after = function()
        require('claudecode').setup({})
      end,
      keys = {
        { lhs = '<leader>a',  nil },
        { lhs = '<leader>ac', rhs = '<cmd>ClaudeCode<cr>' },
        { lhs = '<leader>af', rhs = '<cmd>ClaudeCodeFocus<cr>' },
        { lhs = '<leader>ar', rhs = '<cmd>ClaudeCode --resume<cr>' },
        { lhs = '<leader>aC', rhs = '<cmd>ClaudeCode --continue<cr>' },
        { lhs = '<leader>am', rhs = '<cmd>ClaudeCodeSelectModel<cr>' },
        { lhs = '<leader>ab', rhs = '<cmd>ClaudeCodeAdd %<cr>' },
        -- { lhs = "<leader>as", rhs = "<cmd>ClaudeCodeSend<cr>", mode = "v" },
        { lhs = '<leader>as', rhs = '<cmd>ClaudeCodeTreeAdd<cr>' },
        -- Diff management
        { lhs = '<leader>aa', rhs = '<cmd>ClaudeCodeDiffAccept<cr>' },
        { lhs = '<leader>ad', rhs = '<cmd>ClaudeCodeDiffDeny<cr>' }
      }
    }
  },
  {
    src = 'https://github.com/folke/snacks.nvim.git'
  },
  -- {
  --   src =  "https://github.com/nickjvandyke/opencode.nvim.git",
  --   name = 'opencode',
  --   data = {
  --     after = function()
  --       ---@type opencode.Opts
  --       vim.g.opencode_opts = {
  --         -- Your configuration, if any — see `lua/opencode/config.lua`, or "goto definition" on the type or field.
  --       }
  --
  --       -- Required for `opts.events.reload`.
  --       vim.o.autoread = true
  --
  --       -- Recommended/example keymaps.
  --       vim.keymap.set({ "n", "x" }, "<leader>aa", function() require("opencode").ask("@this: ", { submit = true }) end,   { desc = "Ask opencode…" })
  --
  --       vim.keymap.set({ "n", "x" }, "<leader>ax", function() require("opencode").select() end,                            { desc = "Execute opencode action…" })
  --       vim.keymap.set({ "n", "t" }, "<leader>at", function() require("opencode").toggle() end,                            { desc = "Toggle opencode" })
  --
  --       vim.keymap.set({ "n", "x" }, "<leader>go",    function() return require("opencode").operator("@this ") end,        { desc = "Add range to opencode", expr = true })
  --       vim.keymap.set({ "n" },      "<leader>goo",   function() return require("opencode").operator("@this ") .. "_" end, { desc = "Add line to opencode", expr = true })
  --
  --       vim.keymap.set({ "n" },      "<S-C-u>", function() require("opencode").command("session.half.page.up") end,                 { desc = "Scroll opencode up" })
  --       vim.keymap.set({ "n" },      "<S-C-d>", function() require("opencode").command("session.half.page.down") end,               { desc = "Scroll opencode down" })
  --
  --       -- You may want these if you stick with the opinionated "<C-a>" and "<C-x>" above — otherwise consider "<leader>o…".
  --       -- vim.keymap.set("n", "+", "<C-a>", { desc = "Increment under cursor", noremap = true })
  --       -- vim.keymap.set("n", "-", "<C-x>", { desc = "Decrement under cursor", noremap = true })
  --     end,
  --   }
  -- },
  -- {
  --   src = 'https://github.com/yetone/avante.nvim',
  --   name = 'avante.nvim',
  --   data = {
  --     'avante.nvim',
  --     -- event = 'DeferredUIEnter',
  --     cmd = { 'Avante', 'AvanteChat', 'AvanteChatNew' },
  --     before = function()
  --       vim.cmd.packadd('nui.nvim')
  --     end,
  --     after = function()
  --       require('avante').setup({
  --         provider = 'claude',
  --         providers = {
  --           ollama = {
  --             endpoint = 'http://127.0.0.1:11434',
  --             model = 'qwen3-coder',
  --           },
  --           claude = {
  --             endpoint = 'https://api.anthropic.com',
  --             model = 'claude-sonnet-4-5-20250929',
  --             extra_request_body = {
  --               temperature = 0.75,
  --               max_tokens = 4096,
  --             },
  --           },
  --           openai = {
  --             endpoint = 'https://api.openai.com/v1',
  --             model = 'gpt-4o',
  --             extra_request_body = {
  --               -- timeout = 30000,
  --               -- temperature = 0.75,
  --               -- max_completion_tokens = 8192,
  --               -- reasoning_effort = "medium",
  --             },
  --           },
  --         },
  --       })
  --     end,
  --   },
  -- },
  {
    src = 'https://github.com/nvim-lua/plenary.nvim',
  },
  {
    src = 'https://github.com/HakonHarnes/img-clip.nvim',
    name = 'img-clip.nvim',
    data = {
      'img-clip.nvim',
      event = 'DeferredUIEnter',
      after = function()
        require('img-clip').setup({
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            use_absolute_path = true,
          },
        })
      end,
    },
  },
  {
    src = 'https://github.com/ravitemer/mcphub.nvim.git',
    name = 'mcphub.nvim',
    data = {
      dep_of = 'avante.nvim',
      cmd = { 'MCPHub' },
      after = function()
        require('mcphub').setup(
        -- { use_bundled_binary = true, }
        )
      end,
    },
  },
}
