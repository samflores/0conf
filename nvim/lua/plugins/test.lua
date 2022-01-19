local package = 'vim-test/vim-test'

local config = function()
  vim.api.nvim_exec([[
    let test#strategy = 'floaterm'

    function! DirenvTransform(cmd) abort
      if filereadable(".envrc")
        return 'direnv exec . '.a:cmd
      endif
      return a:cmd
    endfunction

    let g:test#custom_transformations = {'direnv': function('DirenvTransform')}
    let g:test#transformation = 'direnv'
  ]], false)
  -- let test#ruby#use_binstubs = 0
  -- let test#ruby#minitest#file_pattern = '_spec\.rb' "

  local map = vim.api.nvim_set_keymap
  local opt = { noremap = true }

  map('n', '<leader>tt', ':TestNearest<CR>', opt)
  map('n', '<leader>tf', ':TestFile<CR>', opt)
  map('n', '<leader>ta', ':TestSuite<CR>', opt)
  map('n', '<leader>tl', ':TestLast<CR>', opt)
  map('n', '<leader>tg', ':TestVisit<CR>', opt)
end

local M = {}

function M.init(use)
  use {
    package,
    config = config
  }
end

return M
