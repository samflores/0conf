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
  require("telescope").load_extension('ui-select')
  require('telescope').load_extension('media_files')
end

local opt = { noremap = true }

return {
  'nvim-telescope/telescope.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope-dap.nvim',
    'nvim-telescope/telescope-file-browser.nvim',
    'BurntSushi/ripgrep',
    'nvim-telescope/telescope-fzy-native.nvim',
    'nvim-telescope/telescope-ui-select.nvim',
    'nvim-telescope/telescope-media-files.nvim',
  },
  keys = {
    { '<leader>oo', '<cmd>Telescope find_files<CR>',                           opt },
    { '<leader>o.', '<cmd>Telescope find_files cwd=%:p:h<CR>',                 opt },
    { '<leader>ov', '<cmd>Telescope find_files cwd=~/.config/nvim/<CR>',       opt },
    { '<leader>og', '<cmd>Telescope git_files<CR>',                            opt },
    { '<leader>ob', '<cmd>Telescope buffers<CR>',                              opt },
    { '<leader>oh', '<cmd>Telescope oldfiles cwd_only=true<CR>',               opt },
    { '<leader>oH', '<cmd>Telescope oldfiles<CR>',                             opt },
    { '<leader>bb', '<cmd>Telescope file_browser grouped=true<CR>',            opt },
    { '<leader>b.', '<cmd>Telescope file_browser path=%:p:h grouped=true<CR>', opt },
    { '<leader>xx', '<cmd>Telescope media_files<CR>',                          opt },
    { '<leader>ss', '<cmd>Telescope live_grep<CR>',                            opt },
    { '<leader>s.', '<cmd>Telescope grep_string<CR>',                          opt },
    { '<leader>lr', '<cmd>Telescope lsp_references<CR>',                       opt },
    { '<leader>la', '<cmd>Telescope lsp_code_actions<CR>',                     opt },
    { '<leader>gs', '<cmd>Telescope git_status<CR>',                           opt },
    { '<leader>gb', '<cmd>Telescope git_branches<CR>',                         opt },
    { '<leader>tS', '<cmd>Telescope treesitter<CR>',                           opt },
    -- map('n', '<leader>x.', '<cmd>Telescope media_files path=%:p:h grouped=true<CR>', opt)
  },
  config = config,
  cmd = 'Telescope',
}
