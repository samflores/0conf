local cmd = vim.cmd

local create_augroup = function(name, autocmds)
  cmd('augroup ' .. name)
  cmd('autocmd!')
  for _, autocmd in ipairs(autocmds) do
    cmd('autocmd ' .. table.concat(autocmd, ' '))
  end
  cmd('augroup END')
end

-- cmd('au BufNewFile,BufRead * if &ft == "" | set ft=text | endif')

-- Save when losing focus
cmd('au FocusLost <buffer> :silent! wall')

-- Resize splits when the window is resized
cmd('au VimResized <buffer> :wincmd =')

create_augroup('dadbod-completion', {
  -- { 'FileType', 'sql,mysql,plsql', "lua require('cmp').setup.buffer({ sources = {{ name = 'vim-dadbod-completion' }} }" }
})

create_augroup('ftmail', {
  { 'BufRead,BufNewFile', '/tmp/nail-*', 'setlocal', 'ft=mail' },
  { 'BufRead,BufNewFile', '*s-nail-*', 'setlocal', 'ft=mail' },
})

create_augroup('llvm', {
  { 'BufRead,BufNewFile', '*.ll', 'setf llvm' },
})

create_augroup('term', {
  { 'BufNew,BufNewFile,BufRead', 'term://*', 'set nospell nolist' },
})

create_augroup('rustpeg', {
  { 'BufNewFile,BufRead', '*.rustpeg', 'setf rust' },
})

create_augroup('clojure', {
  { 'BufNewFile,BufRead', 'build.boot', 'setf clojure' },
  { 'FileType', 'clojure', 'setlocal lw+=match,go,go-loop,' },
})

create_augroup('firebase', {
  { 'BufNewFile,BufRead', 'storage.rules', 'set filetype=firestore' },
})

create_augroup('clap_input', {
  { 'Filetype', 'clap_input', "call compe#setup({'enabled': v:false}, 0)" },
  -- { 'User', 'ClapOnEnter', "echo 'enter' | FocusDisable" },
  -- { 'User', 'ClapOnExit', "echo 'exit' | FocusEnable" },
})

-- augroup cline
--   au!
--   { 'InsertEnter', '*', 'set nocursorline' },
--   { 'InsertLeave', '*', 'set cursorline' },
-- augroup END

create_augroup('trailing', {
  { 'WinLeave,InsertEnter', '*', 'set listchars-=trail:⌴' },
  { 'WinEnter,InsertLeave', '*', 'set listchars+=trail:⌴' },
})

create_augroup('line_return', {
  { 'BufReadPost', '*', [[if line("'\"") > 0 && line("'\"") <= line("$") | execute 'normal! g`"zvzz' | endif]] },
})

create_augroup('edit_vimrc', {
  { 'BufWritePost', '$MYVIMRC', 'luafile $MYVIMRC' },
  {
    'BufWritePost',
    '$XDG_CONFIG_HOME/nvim/lua/plugins/*.lua',
    'source <afile> | source $XDG_CONFIG_HOME/nvim/lua/bundle.lua | PackerCompile'
  },
  { 'BufWritePost', '$XDG_CONFIG_HOME/nvim/lua/bundle.lua', 'PackerSync' },
})

create_augroup('VimCSS3Syntax', {
  { 'FileType', 'css,vue', 'setlocal iskeyword+=-' },
})

create_augroup('runNearestTest', {
  { 'BufNew,BufNewFile,BufReadPost', '*_spec.rb', 'nnoremap <buffer> <Enter> :lua require("neotest").run.run()<CR>' },
  { 'BufNew,BufNewFile,BufReadPost', '*_test.rb', 'nnoremap <buffer> <Enter> :lua require("neotest").run.run()<CR>' },
  { 'BufNew,BufNewFile,BufReadPost', '*.spec.js', 'nnoremap <buffer> <Enter> :lua require("neotest").run.run()<CR>' },
  { 'BufNew,BufNewFile,BufReadPost', '*.spec.ts', 'nnoremap <buffer> <Enter> :lua require("neotest").run.run()<CR>' },
})

create_augroup('jscinoptions', {
  { 'BufRead,BufNewFile', '*.js', 'set cino=(1s' },
})

create_augroup('suckless', {
  { 'BufWritePost', '$HOME/Code/dwm/config.h', ':silent !cd $HOME/Code/dwm && doas make clean install' },
  { 'BufWritePost', '$HOME/Code/st/config.h', ':silent !cd $HOME/Code/st && doas make clean install' },
})

create_augroup('chisel', {
  { 'BufNewFile,BufRead', '*.chsl', 'set filetype=rust' },
})
-- create_augroup('present_mode', {
--   { 'BufNewFile,BufRead', '*.vpm', 'nnoremap <silent> <buffer> <Right> :n<CR>' },
--   { 'BufNewFile,BufRead', '*.vpm', 'nnoremap <silent> <buffer> <Left> :N<CR>' },
--   { 'BufNewFile,BufRead', '*.vpm', 'Goyo' },
-- })
