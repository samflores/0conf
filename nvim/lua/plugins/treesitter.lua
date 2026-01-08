
return {
  {
    src = 'https://github.com/nvim-treesitter/nvim-treesitter',
    version = 'main',
    data = {
      after = function()
        require 'nvim-treesitter'.install({
          'bash',
          'css',
          'haskell',
          'html',
          'javascript',
          'lua',
          'markdown',
          'markdown_inline',
          'regex',
          'ruby',
          'rust',
          'scss',
          'sql',
          'svelte',
          'typescript',
          'xml',
        })

        vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
      end,
      -- build = ':TSUpdate',
      -- event = 'DeferredUIEnter',
      ft = {
        'sh',
        'bash',
        'haskell',
        'css',
        'html',
        'javascript',
        'lua',
        'ruby',
        'eruby',
        'rust',
        'svelte',
        'typescript',
        'markdown',
        'sql',
      }
    }
  },
  {
    src = 'https://github.com/nvim-treesitter/nvim-treesitter-textobjects.git',
    version = 'main',
    data = {
      after = function()
        require('nvim-treesitter-textobjects').setup {
          select = {
            lookahead = true,
            selection_modes = {
              ['@parameter.outer'] = 'v',
              ['@function.outer'] = 'V',
              ['@class.outer'] = '<c-v>',
            },
            include_surrounding_whitespace = false,
          },
          move = {
            set_jumps = true,
          },
        }

        vim.keymap.set({ 'x', 'o' }, 'af', function()
          require 'nvim-treesitter-textobjects.select'.select_textobject('@function.outer', 'textobjects')
        end)
        vim.keymap.set({ 'x', 'o' }, 'if', function()
          require 'nvim-treesitter-textobjects.select'.select_textobject('@function.inner', 'textobjects')
        end)
        vim.keymap.set({ 'x', 'o' }, 'ac', function()
          require 'nvim-treesitter-textobjects.select'.select_textobject('@class.outer', 'textobjects')
        end)
        vim.keymap.set({ 'x', 'o' }, 'ic', function()
          require 'nvim-treesitter-textobjects.select'.select_textobject('@class.inner', 'textobjects')
        end)
        vim.keymap.set({ 'x', 'o' }, 'aa', function()
          require 'nvim-treesitter-textobjects.select'.select_textobject('@parameter.outer', 'textobjects')
        end)
        vim.keymap.set({ 'x', 'o' }, 'ia', function()
          require 'nvim-treesitter-textobjects.select'.select_textobject('@parameter.inner', 'textobjects')
        end)
        vim.keymap.set({ 'x', 'o' }, 'as', function()
          require 'nvim-treesitter-textobjects.select'.select_textobject('@local.scope', 'locals')
        end)

        vim.keymap.set('n', '>a', function()
          require('nvim-treesitter-textobjects.swap').swap_next '@parameter.inner'
        end)
        vim.keymap.set('n', '<a', function()
          require('nvim-treesitter-textobjects.swap').swap_previous '@parameter.inner'
        end)
        vim.keymap.set('n', '>e', function()
          require('nvim-treesitter-textobjects.swap').swap_next '@element'
        end)
        vim.keymap.set('n', '<e', function()
          require('nvim-treesitter-textobjects.swap').swap_previous '@element'
        end)

        vim.keymap.set({ 'n', 'x', 'o' }, ']f', function()
          require('nvim-treesitter-textobjects.move').goto_next_start('@function.outer', 'textobjects')
        end)
        vim.keymap.set({ 'n', 'x', 'o' }, ']c', function()
          require('nvim-treesitter-textobjects.move').goto_next_start('@class.outer', 'textobjects')
        end)
        -- You can also use captures from other query groups like `locals.scm` or `folds.scm`
        vim.keymap.set({ 'n', 'x', 'o' }, ']s', function()
          require('nvim-treesitter-textobjects.move').goto_next_start('@local.scope', 'locals')
        end)
        vim.keymap.set({ 'n', 'x', 'o' }, ']z', function()
          require('nvim-treesitter-textobjects.move').goto_next_start('@fold', 'folds')
        end)

        vim.keymap.set({ 'n', 'x', 'o' }, ']F', function()
          require('nvim-treesitter-textobjects.move').goto_next_end('@function.outer', 'textobjects')
        end)
        vim.keymap.set({ 'n', 'x', 'o' }, ']C', function()
          require('nvim-treesitter-textobjects.move').goto_next_end('@class.outer', 'textobjects')
        end)

        vim.keymap.set({ 'n', 'x', 'o' }, '[f', function()
          require('nvim-treesitter-textobjects.move').goto_previous_start('@function.outer', 'textobjects')
        end)
        vim.keymap.set({ 'n', 'x', 'o' }, '[c', function()
          require('nvim-treesitter-textobjects.move').goto_previous_start('@class.outer', 'textobjects')
        end)

        vim.keymap.set({ 'n', 'x', 'o' }, '[F', function()
          require('nvim-treesitter-textobjects.move').goto_previous_end('@function.outer', 'textobjects')
        end)
        vim.keymap.set({ 'n', 'x', 'o' }, '[c', function()
          require('nvim-treesitter-textobjects.move').goto_previous_end('@class.outer', 'textobjects')
        end)

        vim.keymap.set({ 'n', 'x', 'o' }, ']e', function()
          require('nvim-treesitter-textobjects.move').goto_next_start({ '@parameter.inner', '@element' }, 'textobjects')
        end)
        vim.keymap.set({ 'n', 'x', 'o' }, '[e', function()
          require('nvim-treesitter-textobjects.move').goto_previous_start({ '@parameter.inner', '@element' }, 'textobjects')
        end)

        vim.keymap.set({ 'n', 'x', 'o' }, ']i', function()
          require('nvim-treesitter-textobjects.move').goto_next('@conditional.outer', 'textobjects')
        end)
        vim.keymap.set({ 'n', 'x', 'o' }, '[i', function()
          require('nvim-treesitter-textobjects.move').goto_previous('@conditional.outer', 'textobjects')
        end)
      end
    },
  }
}
