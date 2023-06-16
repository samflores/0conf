local config = function()
  local Path = require('plenary.path')
  require('session_manager').setup({
    sessions_dir = Path:new(vim.fn.stdpath('data'), 'sessions'),
    path_replacer = '__',
    colon_replacer = '++',
    autoload_mode = require('session_manager.config').AutoloadMode.CurrentDir,
    autosave_last_session = true,
    autosave_ignore_not_normal = true,
    autosave_ignore_filetypes = {
      'gitcommit',
    },
    autosave_only_in_session = false,
    max_path_length = 0,
  })
end

return {
  'Shatur/neovim-session-manager',
  config = config,
  dependencies = { 'nvim-lua/plenary.nvim' }
}
