local package = 'scr1pt0r/crease.vim'
local rocks = { 'moses' }

local config = function()
  vim.api.nvim_exec([[
    set foldmarker=\ {{{,\ }}}

    function! CreaseIndent() abort
      let fs = nextnonblank(v:foldstart)
      let line = substitute(getline(fs), '\t', repeat(' ', &tabstop), 'g')
      let foldLevelStr = repeat(' ', match(line,'\S'))
      return foldLevelStr
    endfunction

    function! FoldTxt() abort
      return trim(substitute(
            \ getline(v:foldstart),
            \ '\V\C'
            \ . join(split(&commentstring, '%s'), '\|') . '\|'
            \ . join(split(&foldmarker, ','), '\d\?\|') . '\|'
            \ . join(g:foldtext_stop_words, '\|') . '\|',
            \ '',
            \ 'g'
            \ ))
            \ . ' … ' .
            \ trim(getline(v:foldend))
    endfunction

    let g:fold_label = ''
    let g:lines_label = 'lines'

    let g:foldtext_stop_words = [
          \ '\^function',
          \ '!',
          \ 'abort',
          \ '\^fn',
          \ ]

    let g:crease_foldtext = {
          \   'default': '%{CreaseIndent()}%{FoldTxt()} %= ' . g:fold_label . ' %l ' . g:lines_label . ' %f%f%f%f' 
          \ }
  ]], false)
end

local M = {}

function M.init(use)
  use {
    package,
    rocks = rocks,
    config = config
  }
end

return M
