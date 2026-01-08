return {
  {
    src = 'https://github.com/nvim-treesitter/nvim-treesitter',
  },
  {
    src = 'https://github.com/stevearc/dressing.nvim',
    data = {
      dep_of = "avante.nvim",
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
      dep_of = "avante.nvim",
      cmd = 'Copilot',
      event = 'DeferredUIEnter',
      after = function()
        require('copilot').setup({})
      end,
    },
  },
  {
    src = 'https://github.com/yetone/avante.nvim',
    name = 'avante.nvim',
    data = {
      'avante.nvim',
      -- event = 'DeferredUIEnter',
      cmd = { 'Avante', 'AvanteChat', 'AvanteChatNew' },
      before = function()
        vim.cmd.packadd('nui.nvim')
      end,
      after = function()
        require('avante').setup({
          provider = 'claude',
          providers = {
            ollama = {
              endpoint = 'http://127.0.0.1:11434',
              model = 'qwen3-coder',
            },
            claude = {
              endpoint = 'https://api.anthropic.com',
              model = 'claude-sonnet-4-5-20250929',
              extra_request_body = {
                temperature = 0.75,
                max_tokens = 4096,
              },
            },
            openai = {
              endpoint = 'https://api.openai.com/v1',
              model = 'gpt-4o',
              extra_request_body = {
                -- timeout = 30000,
                -- temperature = 0.75,
                -- max_completion_tokens = 8192,
                -- reasoning_effort = "medium",
              },
            },
          },
        })
      end,
    },
  },
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
    src = 'https://github.com/MeanderingProgrammer/render-markdown.nvim',
    name = 'render-markdown.nvim',
    data = {
      dep_of = "avante.nvim",
      ft = { 'markdown', 'Avante' },
      after = function()
        require('render-markdown').setup({
          file_types = { 'markdown', 'Avante' },
        })
      end,
    },
  },
  {
    src = 'https://github.com/ravitemer/mcphub.nvim.git',
    name = 'mcphub.nvim',
    data = {
      dep_of = "avante.nvim",
      cmd = { 'MCPHub' },
      after = function()
        require('mcphub').setup(
          -- { use_bundled_binary = true, }
        )
      end,
    },
  },
}
