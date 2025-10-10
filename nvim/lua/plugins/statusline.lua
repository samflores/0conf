local lualine_config = function()
  local navic = require('nvim-navic')
  navic.setup {
    highlight = true,
    separator = ' > ',
    depth_limit = 5,
    depth_limit_indicator = '..',
    safe_output = true,
    lsp = {
      auto_attach = true,
    },
  }

  local mode_map = {
    n = ' ',
    no = '?',
    nov = '?',
    noV = '?',
    ['no\22'] = '?',
    niI = 'i',
    niR = 'r',
    niV = 'v',
    nt = 't',
    v = '󰒇 ',
    vs = '󰒇s',
    V = '󰒇_',
    Vs = '󰒇s',
    ['\22'] = '󰒇^',
    ['\22s'] = '󰒇^',
    s = '󰹾 ',
    S = '󰹾_',
    ['\19'] = '󰹾^',
    i = ' ',
    ic = 'c',
    ix = 'x',
    R = '󰹾 ',
    Rc = '󰹾c',
    Rx = '󰹾x',
    Rv = '󰹾v',
    Rvc = '󰹾v',
    Rvx = '󰹾v',
    c = ' ',
    cv = 'Ex',
    r = ' ',
    rm = 'M ',
    ['r?'] = ' ',
    ['!'] = ' ',
    t = ' ',
  }

  local palette = require 'tokyobones.palette'
  local colors = {
    normal_bg = palette.dark.bg.hex,
    bright_fg = palette.dark.fg.hex,
    bright_bg = palette.dark.bg_warm.hex,
    gray = palette.dark.bg_warm.hex,
    red = palette.dark.rose.hex,
    green = palette.dark.leaf.hex,
    orange = palette.dark.wood.hex,
    blue = palette.dark.water.hex,
    purple = palette.dark.blossom.hex,
    cyan = palette.dark.sky.hex,
    pink = palette.dark.orange.hex,
  }

  local custom_theme = {
    normal = {
      a = { bg = colors.purple, fg = colors.normal_bg, gui = 'bold' },
      b = { bg = colors.bright_bg, fg = colors.bright_fg },
      c = { bg = colors.normal_bg, fg = colors.normal_fg },
      x = { bg = colors.bright_bg, fg = colors.bright_fg },
      y = { bg = colors.bright_bg, fg = colors.bright_fg },
      z = { bg = colors.bright_bg, fg = colors.bright_fg },
    },
    insert = {
      a = { bg = colors.orange, fg = colors.normal_bg, gui = 'bold' },
      b = { bg = colors.bright_bg, fg = colors.bright_fg },
      c = { bg = colors.normal_bg, fg = colors.bright_fg }
    },
    visual = {
      a = { bg = colors.blue, fg = colors.normal_bg, gui = 'bold' },
      b = { bg = colors.bright_bg, fg = colors.bright_fg },
      c = { bg = colors.normal_bg, fg = colors.bright_fg }
    },
    replace = {
      a = { bg = colors.red, fg = colors.normal_bg, gui = 'bold' },
      b = { bg = colors.bright_bg, fg = colors.bright_fg },
      c = { bg = colors.normal_bg, fg = colors.bright_fg }
    },
    command = {
      a = { bg = colors.cyan, fg = colors.normal_bg, gui = 'bold' },
      b = { bg = colors.bright_bg, fg = colors.bright_fg },
      c = { bg = colors.normal_bg, fg = colors.bright_fg }
    },
    terminal = {
      a = { bg = colors.normal_bg, fg = colors.bright_fg, gui = 'bold' },
      b = { bg = colors.bright_bg, fg = colors.bright_fg },
      c = { bg = colors.normal_bg, fg = colors.bright_fg }
    },
    inactive = {
      a = { bg = colors.normal_bg, fg = colors.gray },
      b = { bg = colors.normal_bg, fg = colors.gray },
      c = { bg = colors.normal_bg, fg = colors.gray },
    }
  }

  local mode_component = {
    'mode',
    fmt = function()
      local mode = vim.api.nvim_get_mode().mode
      return mode_map[mode] or mode
    end,
    separator = { left = '', right = '' },
  }

  local filetype_component = {
    'filetype',
    colored = true,
    icon_only = true,
    color = { bg = colors.normal_bg },
    separator = { left = '', right = '' },
  }

  local filename_component = {
    'filename',
    path = 4,
    symbols = { newfile = '', readonly = '', unnamed = ' ', modified = '●' },
    separator = { left = '', right = '' },
  }

  local snippets_component = {
    function()
      if not vim.tbl_contains({ 's', 'i' }, vim.fn.mode()) then
        return ''
      end

      if vim.snippet == nil or vim.snippet.active == nil then
        return ''
      end

      local forward = vim.snippet.active({ direction = 1 }) and '󰙡 ' or ''
      local backward = vim.snippet.active({ direction = -1 }) and '󰙣 ' or ''
      return backward .. forward
    end,
    separator = { left = '', right = '' },
  }

  local diagnostics_component = {
    'diagnostics',
    symbols = {
      errors = ' ',
      warnings = ' ',
      info = ' ',
      hints = ' '
    },
    separator = { left = '', right = '' },
  }

  local navic_component = {
    'navic',
    color_correction = 'dynamic',
    navic_opts = nil,
    -- separator = { left = '', right = '' },
  }

  local git_component = {
    'diff',
    symbols = {
      added = '  ',
      removed = '  ',
      modified = '  ',
    },
    separator = { left = '', right = '' },
  }

  require('lualine').setup({
    options = {
      theme = custom_theme,
      component_separators = { left = '', right = '' },
      section_separators = { left = '', right = '' },
      always_divide_middle = true,
      globalstatus = true,
    },
    sections = {
      lualine_a = { mode_component },
      lualine_b = { filetype_component, filename_component },
      lualine_c = { snippets_component, navic_component },
      lualine_x = { diagnostics_component },
      lualine_y = { git_component },
      lualine_z = {}
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = { 'filename' },
      lualine_x = { 'location' },
      lualine_y = {},
      lualine_z = {}
    },
  })
end

return {
  'nvim-lualine/lualine.nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
    'SmiteshP/nvim-navic'
  },
  config = lualine_config,
}
