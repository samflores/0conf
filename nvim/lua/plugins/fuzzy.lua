local config = function()
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
end

return {
  {
    'ibhagwan/fzf-lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = config,
    event = 'UiEnter',
    keys = {
      {
        '<leader>o?',
        function() require('fzf-lua').help_tags() end,
        desc = 'Search help',
      },
      {
        'z=',
        function() require('fzf-lua').spell_suggest() end,
      },
      {
        '<leader>oo',
        function() require('fzf-lua').files() end,
        desc = 'Find files',
      },
      {
        '<leader>oO',
        function() require('fzf-lua').files({ hidden = true }) end,
        desc = 'Find files (hidden)',
      },
      {
        '<leader>o.',
        function() require('fzf-lua').files({ cwd = vim.fn.expand('%:p:h') }) end,
        desc = "Find files in current file's directory",
      },
      {
        '<leader>ov',
        function() require('fzf-lua').files({ cwd = vim.fn.stdpath('config'), prompt = ' ' }) end,
        desc = 'Find vim config files',
      },
      {
        '<leader>og',
        function() require('fzf-lua').git_files() end,
        desc = 'Find Git files',
      },
      {
        '<leader>ob',
        function() require('fzf-lua').buffers() end,
        desc = 'Find open buffer',
      },
      {
        '<leader>oh',
        function() require('fzf-lua').oldfiles({ cwd_only = true }) end,
        desc = 'Find in project history',
      },
      {
        '<leader>oH',
        function() require('fzf-lua').oldfiles() end,
        desc = 'Find in all history',
      },
      {
        '<leader>ss',
        function() require('fzf-lua').live_grep_native() end,
        desc = 'Live grep',
      },
      {
        '<leader>s.',
        function() require('fzf-lua').grep_cword() end,
        desc = 'Grep word under cursor',
      },
      {
        '<leader>lr',
        function() require('fzf-lua').lsp_references() end,
        desc = 'Find LSP references',
      },
      {
        '<leader>ld',
        function() require('fzf-lua').lsp_definitions() end,
        desc = 'Find LSP definitions',
      },
      {
        '<leader>le',
        function() require('fzf-lua').diagnostics_document() end,
        desc = 'Find LSP diagnostics',
      },
      {
        '<leader>ls',
        function() require('fzf-lua').lsp_document_symbols() end,
        desc = 'Find LSP document symbols',
      },
      {
        '<leader>lS',
        function() require('fzf-lua').lsp_workspace_symbols() end,
        desc = 'Find LSP workspace symbols',
      },
      {
        '<leader>gs',
        function() require('fzf-lua').git_status() end,
        desc = 'Git status',
      },
      {
        '<leader>gb',
        function() require('fzf-lua').git_branches() end,
        desc = 'Git branches',
      },
      {
        '<leader>tS',
        function() require('fzf-lua').treesitter() end,
        desc = 'Find treesitter symbols',
      },
      {
        '<leader>st',
        function() require('fzf-lua').treesitter() end,
        desc = 'Find treesitter symbols',
      },
      {
        '<leader>sa',
        function()
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
    }
  }
}
