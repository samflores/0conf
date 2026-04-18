vim.lsp.enable({
  'bashls',
  'clangd',
  'copilot',
  'cssls',
  'css_variables',
  'docker_compose_language_service',
  'dockerls',
  'emmet_ls',
  'eslint',
  'graphql',
  'herb_ls',
  'hls',
  'html',
  'lemminx',
  'lua_ls',
  'pylsp',
  'qmlls',
  'ruby_lsp',
  'rust_analyzer',
  'sqls',
  'svelte',
  'taplo',
  'terraformls',
  'tofu_ls',
  'ts_ls',
  'yamlls',
})

vim.lsp.handlers['textDocument/hover'] = function(err, result, ctx, config)
  config = config or {}
  config.border = 'rounded'
  return vim.lsp.handlers.hover(err, result, ctx, config)
end

vim.lsp.handlers['textDocument/signatureHelp'] = function(err, result, ctx, config)
  config = config or {}
  config.border = 'rounded'
  return vim.lsp.handlers.signature_help(err, result, ctx, config)
end
