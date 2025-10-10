return {
  {
    'yetone/avante.nvim',
    event = 'VeryLazy',
    version = false,
    cmd = { 'Avante', 'AvanteChat', 'AvanteChatNew' },
    opts = {
      provider = 'copilot',
      providers = {
        claude = {
          endpoint = 'https://api.anthropic.com',
          model = 'claude-sonnet-4-20250514',
          timeout = 30000,
          extra_request_body = {
            temperature = 0.75,
            max_tokens = 20480,
          },
        },
        openai = {
          endpoint = 'https://api.openai.com/v1',
          model = 'gpt-4o', -- your desired model
          extra_request_body = {
            -- timeout = 30000,              -- Timeout in milliseconds, increase this for reasoning models
            -- temperature = 0.75,
            -- max_completion_tokens = 8192, -- Increase this to include reasoning tokens
            --reasoning_effort = "medium", -- low|medium|high, only used for reasoning models
          },
        },
      },
    },
    build = 'make',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'stevearc/dressing.nvim',
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim',
      --- The below dependencies are optional,
      'ibhagwan/fzf-lua',
      -- 'hrsh7th/nvim-cmp',
      'nvim-tree/nvim-web-devicons',
      'zbirenbaum/copilot.lua',
      {
        'HakonHarnes/img-clip.nvim',
        event = 'VeryLazy',
        opts = {
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            use_absolute_path = true,
          },
        },
      },
      {
        'MeanderingProgrammer/render-markdown.nvim',
        opts = {
          file_types = { 'markdown', 'Avante' },
        },
        ft = { 'markdown', 'Avante' },
      },
    },
  },
  {
    'ravitemer/mcphub.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    build = 'bundled_build.lua',
    cmd = { 'MCPHub' },
    config = function()
      require('mcphub').setup({
        use_bundled_binary = true,
      })
    end,
  }
}
