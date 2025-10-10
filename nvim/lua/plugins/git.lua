return {
  {
    'NeogitOrg/neogit',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'sindrets/diffview.nvim',
        opts = {
          hooks = {
            view_opened = function()
              require('diffview.actions').toggle_files()
            end,
          },
        }
      }
    },

    keys = {
      { 'gia', function() vim.cmd 'silent !git add %:p' end,                           noremap = true, silent = true, desc = 'Add file to index' },
      { 'gws', function() require 'neogit'.open({ kind = 'auto' }) end,                noremap = true, silent = true, desc = 'Git status' },
      { 'gpp', function() require 'neogit'.open({ 'push' }) end,                       noremap = true, silent = true, desc = 'Git status' },
      { 'gpf', function() require 'neogit'.open({ 'push', '--force-with-lease' }) end, noremap = true, silent = true, desc = 'Git status' },
      { 'gwd', ':DiffviewOpen<CR>',                                                    noremap = true, silent = true, desc = 'Open Git diff' },
      { 'gwD', ':DiffviewClose<CR>',                                                   noremap = true, silent = true, desc = 'Close Git diff' },
    },
    config = true
  },

  {
    'pwntester/octo.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'ibhagwan/fzf-lua',
      'nvim-tree/nvim-web-devicons',
    },
    opts = {
      picker = 'fzf-lua',
      picker_config = {
        use_emojis = true,
      }
    }
  },

  {
    'almo7aya/openingh.nvim',
    keys = {
      { 'gbb', ':OpenInGHFile<CR>',       mode = 'n', noremap = true, silent = true, desc = 'Open file in hosting provider' },
      { 'gbb', ':OpenInGHFileLines<CR>',  mode = 'v', noremap = true, silent = true, desc = 'Open file in hosting provider with lines selected' },
      { 'gbc', ':OpenInGHFile+<CR>',      mode = 'n', noremap = true, silent = true, desc = 'Copy link to file in hosting provider' },
      { 'gbc', ':OpenInGHFileLines+<CR>', mode = 'v', noremap = true, silent = true, desc = 'Copy link to file in hosting provider with lines selected' },
    }
  },

  {
    'akinsho/git-conflict.nvim',
    version = '*',
    config = true,
    event = 'VeryLazy'
  },

  {
    'lewis6991/gitsigns.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim'
    },
    event = 'VeryLazy',
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
