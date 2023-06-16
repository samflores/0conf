local config = function()
  vim.g.db_ui_icons = {
    expanded = '>',
    collapsed = '',
    saved_query = '',
    new_query = '',
    tables = '',
    buffers = '',
    connection_ok = '',
    connection_error = '',
  }
  vim.g.dbs = {}
end

return {
  'kristijanhusak/vim-dadbod-ui',
  dependencies = {
    'tpope/vim-dadbod'
  },
  config = config,
  -- cmd = 'DBUI'
}
