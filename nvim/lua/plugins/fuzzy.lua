local config = function()
  local actions = require("telescope.actions")
  -- local trouble = require("trouble.providers.telescope")
  local trouble = require("trouble.sources.telescope")
  local action_layout = require("telescope.actions.layout")
  require("telescope").setup {
    defaults = {
      mappings = {
        n = {
          ["<M-S-p>"] = action_layout.toggle_preview,
          ["<M-t>"] = trouble.open,
          ["<C-S-q>"] = actions.send_to_qflist + actions.open_qflist,
          ["<M-S-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
        },
        i = {
          ["<M-S-p>"] = action_layout.toggle_preview,
          ["<esc>"] = actions.close,
          ["<M-t>"] = trouble.open,
        },
      },
    },
    border = {
      prompt = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
    },
    pickers = {
      find_files = {
        previewer = false,
        theme = 'ivy',
        prompt_prefix = ' ',
      },
      git_files = {
        previewer = false,
        theme = 'ivy',
        prompt_prefix = ' ',
      },
      git_status = {
        previewer = false,
        theme = 'ivy',
        prompt_prefix = ' ',
      },
      git_branches = {
        previewer = false,
        theme = 'ivy',
        prompt_prefix = ' ',
      },
      buffers = {
        previewer = false,
        theme = 'ivy',
        prompt_prefix = ' ',
      },
      oldfiles = {
        previewer = false,
        theme = 'ivy',
        prompt_prefix = '󰪺 ',
      },
      live_grep = {
        theme = 'ivy',
        prompt_prefix = '󰍉 ',
      },
      grep_string = {
        theme = 'ivy',
        prompt_prefix = '󰍉 ',
      },
      lsp_references = {
        theme = 'ivy',
        prompt_prefix = '󰈇 ',
      },
      lsp_definitions = {
        theme = 'ivy',
        prompt_prefix = '󰈇 ',
      },
      lsp_document_symbols = {
        theme = 'ivy',
        prompt_prefix = '󰈇 ',
      },
      lsp_dynamic_workspace_symbols = {
        theme = 'ivy',
        prompt_prefix = '󰈇 ',
      },
      spell_suggest = {
        theme = 'ivy',
        prompt_prefix = '󰓆 ',
      }
    },
    extensions = {
      file_browser = {
        theme = 'ivy',
        layout_config = {
          preview_width = 0.7,
        },
      },
      ["ui-select"] = {
        require("telescope.themes").get_ivy {}
      }
    }
  }
  require('telescope').load_extension('dap')
  require('telescope').load_extension('file_browser')
  require('telescope').load_extension('fzy_native')
  require("telescope").load_extension('ui-select')
  require('telescope').load_extension('lazy')
end

return {
  'nvim-telescope/telescope.nvim',
  event = { "VeryLazy" },
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope-dap.nvim',
    'nvim-telescope/telescope-file-browser.nvim',
    'BurntSushi/ripgrep',
    'nvim-telescope/telescope-fzy-native.nvim',
    'nvim-telescope/telescope-ui-select.nvim',
    'tsakirist/telescope-lazy.nvim',
    'axkirillov/easypick.nvim',
  },
  keys = {
    {
      'z=',
      function()
        require('telescope.builtin')
            .spell_suggest()
      end,
      noremap = true,
      silent = true,
    },
    {
      '<leader>oo',
      function()
        require('telescope.builtin')
            .find_files()
      end,
      noremap = true,
      silent = true,
      desc = "Find files"
    },
    {
      '<leader>o.',
      function()
        require('telescope.builtin')
            .find_files({ cwd = '%:p:h' })
      end,
      noremap = true,
      silent = true,
      desc = "Find files in current file's directory"
    },
    {
      '<leader>ov',
      function()
        require('telescope.builtin')
            .find_files({ cwd = '~/.config/nvim/', prompt_prefix = ' ' })
      end,
      noremap = true,
      silent = true,
      desc = "Find vim config files"
    },
    {
      '<leader>og',
      function()
        require('telescope.builtin')
            .git_files()
      end,
      noremap = true,
      silent = true,
      desc = "Find Git files"
    },
    {
      '<leader>ob',
      function()
        require('telescope.builtin')
            .buffers(
              {
                attach_mappings = function(prompt_bufnr, map)
                  local delete_buf = function()
                    local selection = require('telescope.actions.state').get_selected_entry()
                    require('telescope.actions').close(prompt_bufnr)
                    vim.api.nvim_buf_delete(selection.bufnr, { force = true })
                  end

                  map('i', '<c-u>', delete_buf)

                  return true
                end
              }
            )
      end,
      noremap = true,
      silent = true,
      desc = "Find open buffer"
    },
    {
      '<leader>oh',
      function()
        require('telescope.builtin')
            .oldfiles({ cwd_only = true })
      end,
      noremap = true,
      silent = true,
      desc = "Find in project history"
    },
    {
      '<leader>oH',
      function()
        require('telescope.builtin')
            .oldfiles()
      end,
      noremap = true,
      silent = true,
      desc = "Find in all history"
    },
    {
      '<leader>ss',
      function()
        require('telescope.builtin')
            .live_grep()
      end,
      noremap = true,
      silent = true,
      desc = "Live grep"
    },
    {
      '<leader>s.',
      function()
        require('telescope.builtin')
            .grep_string()
      end,
      noremap = true,
      silent = true,
      desc = "Grep word under cursor"
    },
    {
      '<leader>lr',
      function()
        require('telescope.builtin')
            .lsp_references()
      end,
      noremap = true,
      silent = true,
      desc = "Find LSP references"
    },
    {
      '<leader>ld',
      function()
        require('telescope.builtin')
            .lsp_definitions()
      end,
      noremap = true,
      silent = true,
      desc = "Find LSP definitions"
    },
    {
      '<leader>le',
      function()
        require('telescope.builtin')
            .diagnostics()
      end,
      noremap = true,
      silent = true,
      desc = "Find LSP diagnostics"
    },
    {
      '<leader>ls',
      function()
        require('telescope.builtin')
            .lsp_document_symbols()
      end,
      noremap = true,
      silent = true,
      desc = "Find LSP document symbols"
    },
    {
      '<leader>lS',
      function()
        require('telescope.builtin')
            .lsp_dynamic_workspace_symbols()
      end,
      noremap = true,
      silent = true,
      desc = "Find LSP workspace symbols"
    },
    {
      '<leader>gs',
      function()
        require('telescope.builtin')
            .git_status()
      end,
      noremap = true,
      silent = true,
      desc = "Git status"
    },
    {
      '<leader>gb',
      function()
        require('telescope.builtin')
            .git_branches()
      end,
      noremap = true,
      silent = true,
      desc = "Git brances"
    },
    {
      '<leader>tS',
      function()
        require('telescope.builtin')
            .treesitter()
      end,
      noremap = true,
      silent = true,
      desc = "Find treesitter symbols"
    },
    {
      '<leader>BB',
      function()
        require('telescope')
            .extensions
            .file_browser.file_browser({ grouped = true, prompt_prefix = ' ' })
      end,
      noremap = true,
      silent = true,
      desc = "Browse project"
    },
    {
      '<leader>B.',
      function()
        require('telescope')
            .extensions
            .file_browser.file_browser({ path = '%:p:h', grouped = true, prompt_prefix = ' ' })
      end,
      noremap = true,
      silent = true,
      desc = "Browse current file's directory"
    },
  },
  config = config,
  cmd = 'Telescope',
}
