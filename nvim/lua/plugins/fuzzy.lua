local package = 'nvim-telescope/telescope.nvim'
local dependencies = {
  'nvim-lua/plenary.nvim',
  'nvim-telescope/telescope-dap.nvim',
  'nvim-telescope/telescope-file-browser.nvim',
  'BurntSushi/ripgrep',
  'nvim-telescope/telescope-fzy-native.nvim',
  'nvim-telescope/telescope-ui-select.nvim',
}

local config = function()
  local actions = require("telescope.actions")
  -- local trouble = require("trouble.providers.telescope")
  local action_layout = require("telescope.actions.layout")
  require("telescope").setup {
    defaults = {
      mappings = {
        n = {
          ["<M-p>"] = action_layout.toggle_preview,
          -- ["<c-t>"] = trouble.open_with_trouble,
        },
        i = {
          ["<M-p>"] = action_layout.toggle_preview,
          ["<esc>"] = actions.close,
          -- ["<c-t>"] = trouble.open_with_trouble,
        },
      },
    },
    extensions = {
      file_browser = {
        layout_config = { preview_width = 0.7 },
      },
      ["ui-select"] = {
        require("telescope.themes").get_dropdown {}
      }
    }
  }
  -- require('telescope').load_extension('dap')
  require('telescope').load_extension('file_browser')
  require('telescope').load_extension('fzy_native')
  require("telescope").load_extension("ui-select")

  local map = vim.api.nvim_set_keymap
  local opt = { noremap = true }

  map('n', '<leader>oo', '<cmd>Telescope find_files<CR>', opt)
  map('n', '<leader>o.', '<cmd>Telescope find_files cwd=%:p:h<CR>', opt)
  map('n', '<leader>ov', '<cmd>Telescope find_files cwd=~/.config/nvim/<CR>', opt)
  map('n', '<leader>og', '<cmd>Telescope git_files<CR>', opt)
  map('n', '<leader>ob', '<cmd>Telescope buffers<CR>', opt)
  map('n', '<leader>oh', '<cmd>Telescope oldfiles cwd_only=true<CR>', opt)
  map('n', '<leader>oH', '<cmd>Telescope oldfiles<CR>', opt)

  map('n', '<leader>bb', '<cmd>Telescope file_browser grouped=true<CR>', opt)
  map('n', '<leader>b.', '<cmd>Telescope file_browser path=%:p:h grouped=true<CR>', opt)

  map('n', '<leader>ss', '<cmd>Telescope live_grep<CR>', opt)
  map('n', '<leader>s.', '<cmd>Telescope grep_string<CR>', opt)

  map('n', '<leader>lr', '<cmd>Telescope lsp_references<CR>', opt)
  map('n', '<leader>la', '<cmd>Telescope lsp_code_actions<CR>', opt)

  map('n', '<leader>gs', '<cmd>Telescope git_status<CR>', opt)
  map('n', '<leader>gb', '<cmd>Telescope git_branches<CR>', opt)

  map('n', '<leader>tS', '<cmd>Telescope treesitter<CR>', opt)
end

local M = {}

function M.init(use)
  use {
    package,
    requires = dependencies,
    config = config
  }
end

return M
