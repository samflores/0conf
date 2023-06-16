-- local build = 'bash ./install.sh'
local opt = { silent = true, noremap = true }

local config = function()
  local view = require("iron.view")
  require("iron.core").setup {
    config = {
      scratch_repl = true,
      repl_definition = {
        sh = {
          command = { "zsh" }
        }
      },
      repl_open_cmd = view.offset {
        width = 0.4,
        height = 0.4,
        w_offset = view.helpers.flip(2),
        h_offset = view.helpers.flip(2),
      }
    },
    keymaps = {
      send_motion = "<space>sc",
      visual_send = "<space>sc",
      send_file = "<space>sf",
      send_line = "<space>sl",
      send_mark = "<space>sm",
      mark_motion = "<space>mc",
      mark_visual = "<space>mc",
      remove_mark = "<space>md",
      cr = "<space>s<cr>",
      interrupt = "<space>s<space>",
      exit = "<space>sq",
      clear = "<space>cl",
    },
    ignore_blank_lines = true, -- ignore blank lines when sending visual select lines
  }
end

return {
  'hkupty/iron.nvim',
  keys = {
    { '<space>rs', '<cmd>IronRepl<cr>',    opt },
    { '<space>rr', '<cmd>IronRestart<cr>', opt },
    { '<space>rf', '<cmd>IronFocus<cr>',   opt },
    { '<space>rh', '<cmd>IronHide<cr>',    opt }
  },
  config = config,
  cmd = 'IronRepl'
}
