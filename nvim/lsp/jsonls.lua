return {
  cmd = { 'vscode-json-language-server', '--stdio' },
  filetypes = { 'json', 'jsonc', 'json.erb' },
  init_options = {
    provideFormatter = true
  },
  root_markers = { '.git' },
}
