return {
  {
    src = 'https://github.com/nvim-lua/plenary.nvim',
  },

  {
    src = 'https://github.com/sindrets/diffview.nvim.git',
    name = 'diffview',
    data = {
      cmd = { 'DiffviewOpen', 'DiffviewClose' },
      dep_of = 'neogit',
      after = function()
        require('diffview').setup({
          hooks = {
            view_opened = function()
              require('diffview.actions').toggle_files()
            end,
          },
        })
      end,
    }
  },

  {
    src = 'https://github.com/NeogitOrg/neogit.git',
    name = 'neogit',
    data = {
      keys = {
        { lhs = 'gia', rhs = function() vim.cmd 'silent !git add %:p' end,                           noremap = true, silent = true, desc = 'Add file to index' },
        { lhs = 'gws', rhs = function() require 'neogit'.open({ kind = 'auto' }) end,                noremap = true, silent = true, desc = 'Git status' },
        { lhs = 'gpp', rhs = function() require 'neogit'.open({ 'push' }) end,                       noremap = true, silent = true, desc = 'Git status' },
        { lhs = 'gpf', rhs = function() require 'neogit'.open({ 'push', '--force-with-lease' }) end, noremap = true, silent = true, desc = 'Git status' },
        { lhs = 'gwd', rhs = ':DiffviewOpen<CR>',                                                    noremap = true, silent = true, desc = 'Open Git diff' },
        { lhs = 'gwD', rhs = ':DiffviewClose<CR>',                                                   noremap = true, silent = true, desc = 'Close Git diff' },
      },
      after = function()
        require('neogit').setup()
      end,
    }
  },

  {
    src = 'https://github.com/pwntester/octo.nvim.git',
    data = {
      cmd = 'Octo',
      after = function()
        require('octo').setup({
          picker = 'fzf-lua',
          picker_config = {
            use_emojis = true,
          }
        })
      end,
    }
  },

  {
    src = 'https://github.com/Almo7aya/openingh.nvim.git',
    data = {
      keys = {
        { lhs = 'gbb', rhs = ':OpenInGHFile<CR>',       mode = 'n', noremap = true, silent = true, desc = 'Open file in hosting provider' },
        { lhs = 'gbb', rhs = ':OpenInGHFileLines<CR>',  mode = 'v', noremap = true, silent = true, desc = 'Open file in hosting provider with lines selected' },
        { lhs = 'gbc', rhs = ':OpenInGHFile+<CR>',      mode = 'n', noremap = true, silent = true, desc = 'Copy link to file in hosting provider' },
        { lhs = 'gbc', rhs = ':OpenInGHFileLines+<CR>', mode = 'v', noremap = true, silent = true, desc = 'Copy link to file in hosting provider with lines selected' },
      },
    }
  },

  {
    src = 'https://github.com/akinsho/git-conflict.nvim.git',
    version = '*',
    data = {
      event = 'DeferredUIEnter',
      after = function()
        require('git-conflict').setup()
      end,
    }
  },

  {
    src = 'https://github.com/lewis6991/gitsigns.nvim.git',
    data = {
      event = 'DeferredUIEnter',
      after = function()
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
      end,
    }
  }
}
