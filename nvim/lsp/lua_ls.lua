return {
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  root_markers = {
    '.git',
    '.luacheckrc',
    '.luarc.json',
    '.luarc.jsonc',
    '.stylua.toml',
    '.tylua.toml',
    'selene.toml',
    'selene.yml',
  },
  settings = {
    Lua = {
      hint = {
        enable = true,
        arrayIndex = 'Disable',
        setType = true,
      },
      runtime = {
        version = 'LuaJIT',
        path = vim.split(package.path, ';'),
      },
      diagnostics = {
        globals = { 'vim' },
      },
      workspace = {
        library = {
          [vim.fn.expand('$VIMRUNTIME/lua')] = true,
          [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
          [vim.fn.stdpath('data') .. '/lazy'] = true,
        },
      },
    }
  },
  single_file_support = true,
  log_level = vim.lsp.protocol.MessageType.Warning,
}
