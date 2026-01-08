-- return {
--   cmd = { 'qmlls' },
--   filetypes = { 'qml', 'qmljs' },
--   root_dir = function(fname)
--     return vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
--   end,
--   single_file_support = true,
-- }

return {
  cmd = { 'qmlls6' },
  filetypes = { 'qml', 'qmljs' },
  root_dir = function(fname)
    -- Try to find .git directory
    return vim.fs.root(fname, {'.git', '.qmllsrc'}) or vim.fs.dirname(fname)
  end,
  single_file_support = true,
  init_options = {
    importPaths = {
      vim.fn.getcwd() .. '/weaver-qt/qml',
    },
  },
  on_new_config = function(config, root_dir)
    -- Add the build directory
    local build_dir = root_dir .. '/weaver-qt/target/debug'
    if vim.fn.isdirectory(build_dir) == 1 then
      config.init_options = config.init_options or {}
      config.init_options.buildDir = build_dir
      if not config.init_options.importPaths then
        config.init_options.importPaths = {}
      end
      table.insert(config.init_options.importPaths, build_dir)
    end
  end,
}
