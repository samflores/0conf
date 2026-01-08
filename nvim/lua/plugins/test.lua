local config = function()
  -- vim.api.nvim_exec2([[ let test#strategy = 'floaterm' ]], {})

  require('neotest').setup({
    icons = {
      running_animated = {
        '⠋', '⠙', '⠚', '⠒', '⠂', '⠂', '⠒', '⠲', '⠴',
        '⠦', '⠖', '⠒', '⠐', '⠐', '⠒', '⠓', '⠋'
      },
      passed = '',
      failed = '',
      running = '',
      skipped = '',
      unknown = '',
    },
    adapters = {
      require('neotest-python'),
      require('neotest-rust'),
      require('neotest-minitest'),
      require('neotest-rspec')({
        rspec_cmd = function()
          local path = vim.fn.expand('./scripts/run')
          if vim.fn.filereadable(path) ~= 0 or vim.fn.filereadable('Gemfile') ~= 0 then
            return vim.iter({
              'bundle',
              'exec',
              'rspec'
            }):flatten():totable()
          else
            return vim.iter({ 'rspec' }):flatten():totable()
          end
        end,
        transform_spec_path = function(path)
          if vim.fn.filereadable(vim.fn.expand('./scripts/run')) ~= 0 then
            local pattern = string.gsub(vim.fn.getcwd() .. '/', '%-', '%%-')
            local new_path = string.gsub(path, pattern, '')
            return new_path
          else
            return path
          end
        end,
        results_path = function()
          return 'tmp/rspec.out'
        end
      }),
      require('neotest-jest'),
      require('neotest-vitest'),
      require('neotest-vim-test')({ ignore_file_types = {} }),
    },
  })
end

local opt = { noremap = true }

return {
  {
    src = 'https://github.com/nvim-neotest/neotest.git',
    name = 'neotest',
    data = {
      event = 'DeferredUIEnter',
      keys = {
        { lhs = '<leader>tt', rhs = function() require('neotest').run.run() end,                     },
        { lhs = '<leader>tf', rhs = function() require('neotest').run.run(vim.fn.expand('%')) end,   },
        { lhs = '<leader>to', rhs = function() require('neotest').output.open({ short = true }) end, },
        { lhs = '<leader>ts', rhs = function() require('neotest').summary.toggle() end,              },
        { lhs = '<leader>ta', rhs = function() require('neotest').run.run('spec') end,               },
        { lhs = '<leader>tl', rhs = function() require('neotest').run.run_last() end,                },
      },
      before = function()
        vim.cmd.packadd('neotest-python')
        vim.cmd.packadd('neotest-rust')
        vim.cmd.packadd('neotest-rspec')
        vim.cmd.packadd('neotest-minitest')
        vim.cmd.packadd('vim-test')
        vim.cmd.packadd('neotest-jest')
        vim.cmd.packadd('neotest-vitest')
        vim.cmd.packadd('neotest-vim-test')
        vim.cmd.packadd('plenary.nvim')
        vim.cmd.packadd('FixCursorHold.nvim')
        vim.cmd.packadd('nvim-nio')
      end,
      after = config,
    },
  },
  {
    src = 'https://github.com/nvim-neotest/neotest-python.git',
    name = 'neotest-python',
  },
  {
    src = 'https://github.com/rouge8/neotest-rust.git',
    name = 'neotest-rust',
  },
  {
    src = 'https://github.com/olimorris/neotest-rspec.git',
    name = 'neotest-rspec',
  },
  {
    src = 'https://github.com/zidhuss/neotest-minitest.git',
    name = 'neotest-minitest',
  },
  {
    src = 'https://github.com/vim-test/vim-test.git',
    name = 'vim-test',
  },
  {
    src = 'https://github.com/nvim-neotest/neotest-jest.git',
    name = 'neotest-jest',
  },
  {
    src = 'https://github.com/marilari88/neotest-vitest.git',
    name = 'neotest-vitest',
  },
  {
    src = 'https://github.com/nvim-neotest/neotest-vim-test.git',
    name = 'neotest-vim-test',
  },
  {
    src = 'https://github.com/nvim-lua/plenary.nvim',
    name = 'plenary.nvim',
  },
  {
    src = 'https://github.com/antoinemadec/FixCursorHold.nvim.git',
    name = 'FixCursorHold.nvim',
  },
  {
    src = 'https://github.com/nvim-neotest/nvim-nio',
  }
}
