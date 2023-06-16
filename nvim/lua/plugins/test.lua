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
      -- require('neotest-python')({}),
      require('neotest-rust'),
      require('neotest-rspec'),
      require('neotest-vim-test')({ ignore_file_types = {} }),
    },
  })
end

local opt = { noremap = true }

return {
  'rcarriga/neotest',
  config = config,
  keys = {
    { '<leader>tt', ':lua require("neotest").run.run()<CR>',                     opt },
    { '<leader>tf', ':lua require("neotest").run.run(vim.fn.expand("%"))<CR>',   opt },
    { '<leader>to', ':lua require("neotest").output.open({ short = true })<CR>', opt },
    { '<leader>ts', ':lua require("neotest").summary.toggle()<CR>',              opt },
    { '<leader>ta', ':lua require("neotest").run.run("spec")<CR>',               opt },
    { '<leader>tl', ':lua require("neotest").run.run_last()<CR>',                opt },
    -- map('n', '<leader>ta', ':TestSuite<CR>', opt)
    -- map('n', '<leader>tl', ':TestLast<CR>', opt)
    -- map('n', '<leader>tg', ':TestVisit<CR>', opt)
  },
  dependencies = {
    'rouge8/neotest-rust',
    'olimorris/neotest-rspec',
    'vim-test/vim-test',
    'rcarriga/neotest-vim-test',
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "antoinemadec/FixCursorHold.nvim"
  }
}
