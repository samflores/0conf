return {
  {
    src = "git@github.com:ibhagwan/fzf-lua.git",
    data = {
      event = 'DeferredUIEnter',
      keys = {
        {
          lhs = '<leader>o?',
          rhs = function() require('fzf-lua').help_tags() end,
          desc = 'Search help',
        },
        {
          lhs = 'z=',
          rhs = function() require('fzf-lua').spell_suggest() end,
        },
        {
          lhs = '<leader>oo',
          rhs = function() require('fzf-lua').files() end,
          desc = 'Find files',
        },
        {
          lhs = '<leader>oO',
          rhs = function() require('fzf-lua').files({ hidden = true }) end,
          desc = 'Find files (hidden)',
        },
        {
          lhs = '<leader>o.',
          rhs = function() require('fzf-lua').files({ cwd = vim.fn.expand('%:p:h') }) end,
          desc = "Find files in current file's directory",
        },
        {
          lhs = '<leader>ov',
          rhs = function() require('fzf-lua').files({ cwd = vim.fn.stdpath('config'), prompt = ' ' }) end,
          desc = 'Find vim config files',
        },
        {
          lhs = '<leader>og',
          rhs = function() require('fzf-lua').git_files() end,
          desc = 'Find Git files',
        },
        {
          lhs = '<leader>ob',
          rhs = function() require('fzf-lua').buffers() end,
          desc = 'Find open buffer',
        },
        {
          lhs = '<leader>oh',
          rhs = function() require('fzf-lua').oldfiles({ cwd_only = true }) end,
          desc = 'Find in project history',
        },
        {
          lhs = '<leader>oH',
          rhs = function() require('fzf-lua').oldfiles() end,
          desc = 'Find in all history',
        },
        {
          lhs = '<leader>ss',
          rhs = function() require('fzf-lua').live_grep_native() end,
          desc = 'Live grep',
        },
        {
          lhs = '<leader>s.',
          rhs = function() require('fzf-lua').grep_cword() end,
          desc = 'Grep word under cursor',
        },
        {
          lhs = '<leader>lr',
          rhs = function() require('fzf-lua').lsp_references() end,
          desc = 'Find LSP references',
        },
        {
          lhs = '<leader>ld',
          rhs = function() require('fzf-lua').lsp_definitions() end,
          desc = 'Find LSP definitions',
        },
        {
          lhs = '<leader>le',
          rhs = function() require('fzf-lua').diagnostics_document() end,
          desc = 'Find LSP diagnostics',
        },
        {
          lhs = '<leader>ls',
          rhs = function() require('fzf-lua').lsp_document_symbols() end,
          desc = 'Find LSP document symbols',
        },
        {
          lhs = '<leader>lS',
          rhs = function() require('fzf-lua').lsp_workspace_symbols() end,
          desc = 'Find LSP workspace symbols',
        },
        {
          lhs = '<leader>gs',
          rhs = function() require('fzf-lua').git_status() end,
          desc = 'Git status',
        },
        {
          lhs = '<leader>gb',
          rhs = function() require('fzf-lua').git_branches() end,
          desc = 'Git branches',
        },
        {
          lhs = '<leader>tS',
          rhs = function() require('fzf-lua').treesitter() end,
          desc = 'Find treesitter symbols',
        },
        {
          lhs = '<leader>st',
          rhs = function() require('fzf-lua').treesitter() end,
          desc = 'Find treesitter symbols',
        },
        {
          lhs = '<leader>sa',
          rhs = function()
            require('fzf-lua').fzf_live(
              'ast-grep --context 0 --heading never --pattern <query> 2>/dev/null',
              {
                exec_empty_query = false,
                actions = {
                  ['default'] = require 'fzf-lua'.actions.file_edit,
                  ['ctrl-q'] = {
                    fn = require('fzf-lua').actions.file_edit_or_qf,
                    prefix = 'select-all+'
                  }
                }
              }
            )
          end,
          desc = 'ast-grep query',
        },
      },
      after = function()
        require('fzf-lua').setup({
          'ivy',
          winopts = {
            height = 0.35,
            border = { '', '─', '', '', '', '', '', '' },
            preview = {
              border = { '', '─', '', '', '', '', '', '' },
              layout = 'horizontal',
              horizontal = 'right:60%',
            }
          },
          previewers = {
            builtin = {
              extensions = {
                ['png'] = { 'chafa', '--fit-width' },
                ['svg'] = { 'chafa', '--fit-width' },
                ['jpg'] = { 'chafa', '--fit-width' },
              },
            }
          }
        })
      end,
    },
  },
  { src =  'https://github.com/nvim-tree/nvim-web-devicons' },
}
