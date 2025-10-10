---@type vim.lsp.Config
return {
  cmd = { 'herb-language-server', '--stdio' },
  filetypes = { 'html', 'eruby' },
  root_markers = { 'Gemfile', '.git' },
}
