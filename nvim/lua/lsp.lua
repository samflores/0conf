vim.lsp.enable({
  'bashls',
  'clangd',
  'copilot',
  'cssls',
  'css_variables',
  'docker_compose_language_service',
  'dockerls',
  'emmet_ls',
  -- 'eslint',
  'graphql',
  'herb_ls',
  'html',
  'lemminx',
  'lua_ls',
  'pylsp',
  'ruby_lsp',
  'rust_analyzer',
  'sqls',
  'svelte',
  'taplo',
  -- 'terraformls',
  'tofu_ls',
  'ts_ls',
  'yamlls',
})

vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = 'rounded', -- or "single", "double", "shadow", etc.
})

vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, {
  border = 'rounded',
})
