local lualine_config = function()
  local navic = require('nvim-navic')
  navic.setup {
    highlight = false,
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

  local git_component = {
    'diff',
    symbols = {
      added = '  ',
      removed = '  ',
      modified = '  ',
    },
    separator = { left = '', right = '' },
  }

  local navic_component = {
    function()
      if navic.is_available() then
        return navic.get_location()
      end
      return ''
    end,
    cond = function()
      return navic.is_available()
    end,
    separator = { left = '', right = '' },
  }

  require('lualine').setup({
    options = {
      theme = 'gypsum',
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
  {
    src = 'https://github.com/nvim-lualine/lualine.nvim.git',
    name = "lualine",
    data = {
      lazy = false,
      after = lualine_config,
    }
  },
  {
    src =  'https://github.com/nvim-tree/nvim-web-devicons',
    data = {
      dep_of = "lualine"
    }
  },
  {
    src = 'https://github.com/SmiteshP/nvim-navic.git',
    data = {
      dep_of = "lualine"
    }
  },
}
