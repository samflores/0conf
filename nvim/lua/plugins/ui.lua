local opt = { noremap = true }

return {
  -- {
  --   'b0o/incline.nvim',
  --   dependencies = {
  --     'nvim-tree/nvim-web-devicons',
  --     'SmiteshP/nvim-navic'
  --   },
  --   opts = {
  --     hide = {
  --       cursorline = false,
  --     },
  --     window = {
  --       padding = 0
  --     },
  --     render = function(props)
  --       local helpers    = require 'incline.helpers'
  --       local navic      = require 'nvim-navic'
  --       local devicons   = require 'nvim-web-devicons'
  --       local show_navic = false
  --
  --       if props.focused and navic.is_available() then
  --         local win_width = vim.api.nvim_win_get_width(props.win)
  --         local cursor_row = vim.api.nvim_win_get_cursor(props.win)[1] -- 1-indexed
  --         -- hide when window < 40 chars AND cursor is on the first line
  --         show_navic = not (win_width < 120 and cursor_row == 1)
  --       end
  --       if not show_navic then
  --         return {}
  --       end
  --
  --       local filename = vim.fn.pathshorten(vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ':.'), 4)
  --       if filename == '' then
  --         filename = '[No Name]'
  --       end
  --       local normal_bg         = '#191919'
  --       local bg_color          = '#44406e'
  --       local ft_icon, ft_color = devicons.get_icon_color(filename)
  --       local modified          = vim.bo[props.buf].modified
  --
  --       local res               = {
  --         guibg = normal_bg
  --       }
  --
  --       table.insert(res, { '', guifg = ft_color, guibg = normal_bg })
  --       if ft_icon then
  --         table.insert(res, { ft_icon, ' ', guibg = ft_color, guifg = helpers.contrast_color(ft_color) })
  --       end
  --       table.insert(res, { ' ', filename, gui = modified and 'bold,italic' or 'bold', guibg = bg_color })
  --       table.insert(res, { '', guifg = bg_color, guibg = normal_bg })
  --       if props.focused and navic.is_available() then
  --         for _, item in ipairs(navic.get_data(props.buf) or {}) do
  --           table.insert(res, {
  --             { ' > ',     group = 'NavicSeparator' },
  --             { item.icon, group = 'NavicIcons' .. item.type },
  --             { item.name, group = 'NavicText' },
  --           })
  --         end
  --       end
  --       -- table.insert(res, ' ')
  --       return res
  --     end,
  --   },
  --   event = 'VeryLazy',
  -- },
  {
    'j-hui/fidget.nvim',
    opts = {
      -- options
    },
  },
  {
    'echasnovski/mini.files',
    version = '*',
    opts = {
      windows = {
        preview = true,
        width_preview = 55,
      },
    },
    keys = {
      { '<leader>bb', function() require('mini.files').open() end,                             opt },
      { '<leader>b.', function() require('mini.files').open(vim.api.nvim_buf_get_name(0)) end, opt },
    }
  },
}
