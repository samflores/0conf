local opt = { noremap = true }

return {
  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    keys = {
      {
        "<S-Enter>",
        function() require("noice").redirect(vim.fn.getcmdline()) end,
        mode = "c",
        desc = "Redirect Cmdline"
      },
      {
        "<leader>m",
        function() require("notify").dismiss({ silent = true, pending = true }) end,
        mode = "n",
        desc = "Dismiss all notifications"
      }
    },
    opts = {
      lsp = {
        override = {
          ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
          ['vim.lsp.util.stylize_markdown'] = true,
          ['cmp.entry.get_documentation'] = true,
        },
      },
      routes = {
        {
          filter = {
            event = "msg_show",
            kind = "",
            find = "written",
          },
          opts = { skip = true },
        },
        {
          filter = {
            event = "msg_show",
            kind = "",
            find = "LSP",
          },
          opts = { skip = true },
        },
        {
          filter = {
            event = "msg_show",
            kind = "",
            find = "lsp",
          },
          opts = { skip = true },
        },
        {
          filter = {
            event = 'msg_show',
            any = {
              { find = '%d+L, %d+B' },
              { find = '; after #%d+' },
              { find = '; before #%d+' },
              { find = '%d fewer lines' },
              { find = '%d more lines' },
              { find = 'Modified' },
              { find = '%d lines' },
              { find = 'Format request failed' },
            },
          },
          opts = { skip = true },
        },
        {
          view = "notify",
          filter = { event = "msg_showmode" },
        },
      },
      views = {
        cmdline_popup = {
          position = {
            row = "80%",
            col = "50%",
          },
          size = {
            width = 90,
            height = "auto",
          },
          border = {
            style = "none",
            padding = { 2, 3 },
          },
          filter_options = {},
          win_options = {
            winhighlight = {
              Normal = "ColorColumn",
              FloatBorder = "FloatBorder"
            },
          }
        },
        mini = {
          win_options = {
            winhighlight = {
              Normal = "ColorColumn",
              FloatBorder = "FloatBorder"
            },
          },
        },
        popupmenu = {
          position = {
            row = "67%",
            col = "50%",
          },
          size = {
            width = 90,
            height = 10,
          },
          border = {
            style = "none",
            padding = { 1, 3 },
          },
          filter_options = {},
          win_options = {
            winhighlight = {
              Normal = "ColorColumn",
              FloatBorder = "FloatBorder"
            },
          },
        },
      },
      presets = {
        bottom_search = false,
        -- command_palette = true,
        long_message_to_split = true,
        inc_rename = true,
        lsp_doc_border = true,
      },
    },
    dependencies = {
      'MunifTanjim/nui.nvim',
    }
  },
  {
    'b0o/incline.nvim',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
      'SmiteshP/nvim-navic'
    },
    opts = {
      hide = {
        cursorline = false,
      },
      window = {
        padding = 0
      },
      render = function(props)
        local helpers  = require 'incline.helpers'
        local navic    = require 'nvim-navic'
        local devicons = require 'nvim-web-devicons'
        local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ':t')
        if filename == '' then
          filename = '[No Name]'
        end
        local normal_bg         = '#191919'
        local bg_color          = '#44406e'
        local ft_icon, ft_color = devicons.get_icon_color(filename)
        local modified          = vim.bo[props.buf].modified
        local res               = {
          guibg = normal_bg
        }

        table.insert(res, { '', guifg = ft_color, guibg = normal_bg })
        if ft_icon then
          table.insert(res, { ft_icon, ' ', guibg = ft_color, guifg = helpers.contrast_color(ft_color) })
        end
        -- guibg = normal_bg,
        -- ft_icon and { '', guifg = ft_color, guibg = normal_bg } or '',
        -- ft_icon and { ft_icon, ' ', guibg = ft_color, guifg = helpers.contrast_color(ft_color) } or '',
        -- ft_icon and '' or { '', guifg = bg_color, guibg = nil },
        table.insert(res, { ' ', filename, gui = modified and 'bold,italic' or 'bold', guibg = bg_color })
        table.insert(res, { "", guifg = bg_color, guibg = normal_bg })
        if props.focused and navic.is_available() then
          for _, item in ipairs(navic.get_data(props.buf) or {}) do
            table.insert(res, {
              { ' > ',     group = 'NavicSeparator' },
              { item.icon, group = 'NavicIcons' .. item.type },
              { item.name, group = 'NavicText' },
            })
          end
        end
        -- table.insert(res, ' ')
        return res
      end,
    },
    event = 'VeryLazy',
  },
  {
    'simonmclean/triptych.nvim',
    cmd = 'Triptych',
    config = true,
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons',
    }
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
  {
    "vhyrro/luarocks.nvim",
    priority = 1001,
    opts = {
      rocks = { "magick" },
    },
  },
  {
    "3rd/image.nvim",
    dependencies = { "luarocks.nvim" },
    config = true
  }
}
