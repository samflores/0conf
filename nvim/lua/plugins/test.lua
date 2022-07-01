local package = 'rcarriga/neotest'
local dependencies = {
  'vim-test/vim-test',
  'rcarriga/neotest-vim-test',
  "nvim-lua/plenary.nvim",
  "nvim-treesitter/nvim-treesitter",
  "antoinemadec/FixCursorHold.nvim"
}

local config = function()
  vim.api.nvim_exec([[
    function! DirenvTransform(cmd) abort
      if filereadable(".envrc")
        return 'direnv exec . '.a:cmd
      endif
      return a:cmd
    endfunction

    let g:test#custom_transformations = {'direnv': function('DirenvTransform')}
    let g:test#transformation = 'direnv'
  ]], false)

  vim.api.nvim_exec([[
    let test#strategy = 'floaterm'
  ]], false)

  -- vim.api.nvim_exec([[
  --   let test#ruby#use_binstubs = 0
  --   let test#ruby#minitest#file_pattern = '_spec\.rb' "
  -- ]], false)

  require('neotest').setup({
    adapters = {
      -- require('neotest-python')({}),
      -- require('neotest-plenary'),
      require('neotest-vim-test')({ ignore_file_types = {} }),
    },
  })

  local map = vim.api.nvim_set_keymap
  local opt = { noremap = true }

  map('n', '<leader>tt', ':lua require("neotest").run.run()<CR>', opt)
  map('n', '<leader>tf', ':lua require("neotest").run.run(vim.fn.expand("%"))<CR>', opt)
  map('n', '<leader>to', ':lua require("neotest").output.open({ short = true })<CR>', opt)
  map('n', '<leader>ts', ':lua require("neotest").summary.toggle()<CR>', opt)
  map('n', '<leader>ta', ':lua require("neotest").run.run("spec")<CR>', opt)
  map('n', '<leader>tl', ':lua require("neotest").run.run_last()<CR>', opt)
  -- map('n', '<leader>ta', ':TestSuite<CR>', opt)
  -- map('n', '<leader>tl', ':TestLast<CR>', opt)
  -- map('n', '<leader>tg', ':TestVisit<CR>', opt)
end

local M = {}

function M.init(use)
  use {
    package,
    config = config,
    requires = dependencies
  }
end

return M
