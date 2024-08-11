return {
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",         -- required
      "nvim-telescope/telescope.nvim", -- optional
      "sindrets/diffview.nvim"         -- optional
    },
    keys = {
      { 'gia', function() vim.cmd "silent !git add %:p" end,                           noremap = true, silent = true, desc = "Add file to index" },
      { 'gws', function() require 'neogit'.open({ kind = 'auto' }) end,                noremap = true, silent = true, desc = "Git status" },
      { 'gpp', function() require 'neogit'.open({ 'push' }) end,                       noremap = true, silent = true, desc = "Git status" },
      { 'gpf', function() require 'neogit'.open({ 'push', '--force-with-lease' }) end, noremap = true, silent = true, desc = "Git status" },
      { 'gwd', ':DiffviewOpen<CR>',                                                    noremap = true, silent = true, desc = "Open Git diff" },
      { 'gwD', ':DiffviewClose<CR>',                                                   noremap = true, silent = true, desc = "Close Git diff" },
    },
    config = true
  },

  {
    'almo7aya/openingh.nvim',
    keys = {
      { 'gbb', ':OpenInGHFile<CR>',       mode = "n", noremap = true, silent = true, desc = "Open file in hosting provider" },
      { 'gbb', ':OpenInGHFileLines<CR>',  mode = "v", noremap = true, silent = true, desc = "Open file in hosting provider with lines selected" },
      { 'gbc', ':OpenInGHFile+<CR>',      mode = "n", noremap = true, silent = true, desc = "Copy link to file in hosting provider" },
      { 'gbc', ':OpenInGHFileLines+<CR>', mode = "v", noremap = true, silent = true, desc = "Copy link to file in hosting provider with lines selected" },
    }
  },

  -- {
  --   'tpope/vim-fugitive',
  --   dependencies = {
  --     'tpope/vim-rhubarb'
  --   },
  --   keys = {
  --     { 'gws', ':Git<CR>',                         noremap = true, silent = true, desc = "Git status" },
  --     { 'gia', ':Gwrite<CR>',                      noremap = true, silent = true, desc = "Add file to index" },
  --     { 'gco', ':Gread<CR>',                       noremap = true, silent = true, desc = "Checkout file" },
  --     { 'gwd', ':vert :Gdiffsplit<CR>',            noremap = true, silent = true, desc = "Git diff" },
  --     { 'gcm', ':Git commit<CR>',                  noremap = true, silent = true, desc = "Git commit" },
  --     { 'gpf', ':Git push --force-with-lease<CR>', noremap = true, silent = true, desc = "Force push changes to origin" },
  --     { 'gpp', ':Git push<CR>',                    noremap = true, silent = true, desc = "Push changes to origin" },
  --     { 'grc', ':Git rebase --continue<CR>',       noremap = true, silent = true, desc = "Continue rebase operation" },
  --     { 'gra', ':Git rebase --abobrt<CR>',         noremap = true, silent = true, desc = "Cancel rebase operation" },
  --     { 'gbb', ':GBrowse<CR>',                     noremap = true, silent = true, desc = "Open file in hosting provider" },
  --     {
  --       'gbc',
  --       ':GBrowse!<CR>',
  --       noremap = true,
  --       silent = true,
  --       desc =
  --       "Copy link to file in hosting provider"
  --     },
  --   },
  --   cmd = { 'Git', 'GBrowse' },
  -- },

  {
    'akinsho/git-conflict.nvim',
    version = "*",
    config = true
  },

  {
    'lewis6991/gitsigns.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim'
    },
    event = 'UiEnter',
    config = function()
      require('gitsigns').setup {
        signcolumn              = true,
        numhl                   = false,
        linehl                  = false,
        word_diff               = false,
        watch_gitdir            = {
          interval = 1000,
          follow_files = true
        },
        attach_to_untracked     = true,
        current_line_blame      = true,
        current_line_blame_opts = {
          virt_text = true,
          virt_text_pos = 'right_align',
          delay = 3000,
        },
      }
    end
  }
}
