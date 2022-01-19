local package = 'Pocco81/TrueZen.nvim'

local M = {}

local config = function()
  require'true-zen'.setup({
    modes = {
      ataraxis = {
        left_padding = 10,
        right_padding = 10,
      },
    },
    integrations = {
      galaxyline = true,
      gitsigns = true,
      -- nvim_bufferline = false,
    },
    misc = {
      on_off_commands = true,
      ui_elements_commands = true,
      cursor_by_mode = false,
    }
  });

vim.api.nvim_exec([[
  function! s:empty_message(timer)
    if mode() ==# 'n'
      echon ''
    endif
  endfunction

  augroup presentationmode
    autocmd!
    autocmd BufNewFile,BufRead *.vpm call SetVimPresentationMode()
  augroup END

  function! SetVimPresentationMode()
    nnoremap <silent> <buffer> <Right> :n<CR>gg0
    nnoremap <silent> <buffer> <Left> :N<CR>gg0

    IndentBlanklineDisable
    TZAtaraxis l10 r10 t4 b3
  endfunction
]], false)

-- augroup cmd_msg_cls
--     autocmd!
--     autocmd CmdlineLeave :  call timer_start(5, funcref('s:empty_message'))
-- augroup END
end

function M.init(use)
  use {
    package,
    config = config
  }
end

return M
