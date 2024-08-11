local config = function()
  vim.api.nvim_exec2([[
    let test#strategy = 'floaterm'
  ]], {})

  require('neotest').setup({
    icons = {
      running_animated = {
        "⠋", "⠙", "⠚", "⠒", "⠂", "⠂", "⠒", "⠲", "⠴",
        "⠦", "⠖", "⠒", "⠐", "⠐", "⠒", "⠓", "⠋"
      },
      passed = '',
      failed = '',
      running = '',
      skipped = "",
      unknown = "",
    },
    adapters = {
      require('neotest-python'),
      require('neotest-rust'),
      require('neotest-rspec')({
        rspec_cmd = function()
          local path = vim.fn.expand('./scripts/run')
          if vim.fn.filereadable(path) ~= 0 or vim.fn.filereadable('Gemfile') ~= 0 then
            return vim.tbl_flatten({
              "bundle",
              "exec",
              "rspec"
            })
          else
            return vim.tbl_flatten({ "rspec" })
          end
        end,
        transform_spec_path = function(path)
          if vim.fn.filereadable(vim.fn.expand('./scripts/run')) ~= 0 then
            local pattern = string.gsub(vim.fn.getcwd() .. "/", "%-", "%%-")
            local new_path = string.gsub(path, pattern, "")
            return new_path
          else
            return path
          end
        end,
        results_path = function()
          return 'tmp/rspec.out'
        end
      }),
      -- require('neotest-minitest'),
      require('neotest-jest'),
      require('neotest-vitest'),
      require('neotest-vim-test')({ ignore_file_types = {} }),
    },
  })
end

local opt = { noremap = true }

return {
  'nvim-neotest/neotest',
  config = config,
  keys = {
    { '<leader>tt', function() require("neotest").run.run() end,                     opt },
    { '<leader>tf', function() require("neotest").run.run(vim.fn.expand("%")) end,   opt },
    { '<leader>to', function() require("neotest").output.open({ short = true }) end, opt },
    { '<leader>ts', function() require("neotest").summary.toggle() end,              opt },
    { '<leader>ta', function() require("neotest").run.run("spec") end,               opt },
    { '<leader>tl', function() require("neotest").run.run_last() end,                opt },
  },
  dependencies = {
    'nvim-neotest/neotest-python',
    'rouge8/neotest-rust',
    'olimorris/neotest-rspec',
    'zidhuss/neotest-minitest',
    'vim-test/vim-test',
    'haydenmeade/neotest-jest',
    'marilari88/neotest-vitest',
    'rcarriga/neotest-vim-test',
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "antoinemadec/FixCursorHold.nvim"
  }
}
