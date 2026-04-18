local ok, err = pcall(function()
  require 'settings'
  require 'bundle'
  require 'autocmds'
  require 'mappings'
  require 'lsp'
end)

if not ok then
  vim.notify('Error loading configuration: ' .. tostring(err), vim.log.levels.ERROR)
end
