local config = function()
  local conditions = require('heirline.conditions')
  local utils      = require('heirline.utils')
  local colors     = {
    bright_bg = utils.get_highlight('ColorColumn').bg or '#000000',
    normal_bg = utils.get_highlight('Normal').bg or '#000000',
    bright_fg = utils.get_highlight('Normal').fg or '#ffffff',
    red = utils.get_highlight('@property').fg,
    dark_red = utils.get_highlight('DiffDelete').bg,
    green = utils.get_highlight('Debug').fg,
    blue = utils.get_highlight('@keyword').fg,
    gray = utils.get_highlight('Comment').fg,
    orange = utils.get_highlight('Constant').fg,
    purple = utils.get_highlight('DiagnosticWarn').fg,
    pink = utils.get_highlight('@function').fg,
    cyan = utils.get_highlight('Special').fg,
    diag_warn = utils.get_highlight('DiagnosticWarn').fg,
    diag_error = utils.get_highlight('DiagnosticError').fg,
    diag_hint = utils.get_highlight('DiagnosticHint').fg,
    diag_info = utils.get_highlight('DiagnosticInfo').fg,
    git_del = utils.get_highlight('DiffDelete').fg,
    git_add = utils.get_highlight('DiffAdd').fg,
    git_change = utils.get_highlight('DiffChange').fg,
  }
  require('heirline').load_colors(colors)
  local ViMode = {
    init = function(self)
      self.mode = vim.fn.mode()
      if not self.once then
        vim.api.nvim_create_autocmd('ModeChanged', {
          pattern = '*:*o',
          command = 'redrawstatus'
        })
        self.once = true
      end
    end,
    static = {
      mode_names = {
        n         = ' ',
        no        = '?',
        nov       = '?',
        noV       = '?',
        ['no\22'] = '?',
        niI       = 'i',
        niR       = 'r',
        niV       = 'v',
        nt        = 't',
        v         = '󰒇 ',
        vs        = '󰒇s',
        V         = '󰒇_',
        Vs        = '󰒇s',
        ['\22']   = '󰒇^',
        ['\22s']  = '󰒇^',
        s         = '󰹾 ',
        S         = '󰹾_',
        ['\19']   = '󰹾^',
        i         = ' ',
        ic        = 'c',
        ix        = 'x',
        R         = '󰹾 ',
        Rc        = '󰹾c',
        Rx        = '󰹾x',
        Rv        = '󰹾v',
        Rvc       = '󰹾v',
        Rvx       = '󰹾v',
        c         = ' ',
        cv        = 'Ex',
        r         = ' ',
        rm        = 'M ',
        ['r?']    = ' ',
        ['!']     = ' ',
        t         = ' ',
      },
      mode_colors = {
        n = 'blue',
        i = 'green',
        v = 'purple',
        V = 'purple',
        ['\22'] = 'purple',
        c = 'orange',
        s = 'purple',
        S = 'purple',
        ['\19'] = 'purple',
        R = 'red',
        r = 'red',
        ['!'] = 'red',
        t = 'red',
      }
    },
    {
      provider = '',
      hl = function(self)
        local mode = self.mode:sub(1, 1)
        return { fg = self.mode_colors[mode], bg = 'normal_bg', bold = true, }
      end,
    },
    {
      provider = function(self)
        return '%3(' .. self.mode_names[self.mode] .. '%)'
      end,
      hl = function(self)
        local mode = self.mode:sub(1, 1)
        return { bg = self.mode_colors[mode], fg = 'normal_bg', bold = true, }
      end,
    },
    {
      provider = '',
      hl = function(self)
        local mode = self.mode:sub(1, 1)
        return { fg = self.mode_colors[mode], bg = 'normal_bg', bold = true, }
      end,
    },
    update = {
      'ModeChanged',
    },
  }

  local FileNameBlock = {
    provider = function(self)
      self.filename = vim.api.nvim_buf_get_name(0)
    end,
    hl = { bg = 'gray' }
  }

  local FileIcon = {
    init = function(self)
      local filename = self.filename or ''
      local extension = vim.fn.fnamemodify(filename, ':e') or ''
      self.icon, self.icon_color = require('nvim-web-devicons').get_icon_color(filename, extension, { default = true })
    end,
    provider = function(self)
      return self.icon and (self.icon .. ' ')
    end,
    hl = function(self)
      return { fg = self.icon_color }
    end
  }

  local FileName = {
    provider = function(self)
      local filename = vim.fn.fnamemodify(self.filename, ':.')
      if filename == '' then return '[No Name]' end
      if not conditions.width_percent_below(#filename, 0.25) then
        filename = vim.fn.pathshorten(filename, 3)
      end
      return filename
    end,
    hl = { fg = 'bright_fg' },
  }

  local FileFlags = {
    {
      condition = function()
        return vim.bo.modified
      end,
      provider = ' ',
      hl = { fg = 'purple' },
    },
    {
      condition = function()
        return not vim.bo.modifiable or vim.bo.readonly
      end,
      provider = ' ',
      hl = { fg = 'orange' },
    },
  }

  FileNameBlock = utils.insert(
    FileNameBlock,
    {
      provider = '',
      hl = function()
        return { fg = 'gray', bg = 'normal_bg', bold = true, }
      end,
    },
    FileIcon,
    FileName,
    FileFlags,
    { provider = '%<' },
    {
      provider = '',
      hl = function()
        return { fg = 'gray', bg = 'normal_bg', bold = true, }
      end,
    }
  )

  local Git = {
    condition = conditions.is_git_repo,
    init = function(self)
      self.status_dict = vim.b.gitsigns_status_dict
      self.has_changes = self.status_dict.added ~= 0 or self.status_dict.removed ~= 0 or
          self.status_dict.changed ~= 0
    end,
    hl = { fg = 'bright_fg', bg = 'gray' },
    { provider = '', hl = { fg = 'gray', bg = 'normal_bg' } },
    {
      provider = function(self)
        return ' ' .. self.status_dict.head
      end,
      hl = { bold = true }
    },
    {
      provider = function(self)
        local count = self.status_dict.added or 0
        return count > 0 and ('  ' .. count)
      end,
      hl = { fg = 'green' },
    },
    {
      provider = function(self)
        local count = self.status_dict.removed or 0
        return count > 0 and ('  ' .. count)
      end,
      hl = { fg = 'red' },
    },
    {
      provider = function(self)
        local count = self.status_dict.changed or 0
        return count > 0 and ('  ' .. count)
      end,
      hl = { fg = 'blue' },
    },
    {
      condition = function(self)
        return self.has_changes
      end,
      provider = ' ',
    },
    { provider = '', hl = { fg = 'gray', bg = 'normal_bg' } },
  }

  local Diagnostics = {
    condition = conditions.has_diagnostics,
    static = {
      error_icon = ' ', -- vim.fn.sign_getdefined("DiagnosticSignError")[1].text,
      warn_icon  = ' ', -- vim.fn.sign_getdefined("DiagnosticSignWarn")[1].text,
      info_icon  = ' ', -- vim.fn.sign_getdefined("DiagnosticSignInfo")[1].text,
      hint_icon  = ' ', -- vim.fn.sign_getdefined("DiagnosticSignHint")[1].text,
    },
    init = function(self)
      self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
      self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
      self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
      self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
    end,
    update = { 'DiagnosticChanged', 'BufEnter' },
    hl = { fg = 'bright_fg', bg = 'gray' },
    { provider = '', hl = { fg = 'gray', bg = 'normal_bg' } },
    { provider = '󰈖', hl = { bg = 'gray', bold = true } },
    {
      provider = function(self)
        -- 0 is just another output, we can decide to print it or not!
        return self.errors > 0 and (' ' .. self.error_icon .. self.errors)
      end,
      hl = { fg = 'diag_error', bg = 'gray' },
    },
    {
      provider = function(self)
        return self.warnings > 0 and (' ' .. self.warn_icon .. self.warnings)
      end,
      hl = { fg = 'diag_warn', bg = 'gray' },
    },
    {
      provider = function(self)
        return self.info > 0 and (' ' .. self.info_icon .. self.info)
      end,
      hl = { fg = 'diag_info', bg = 'gray' },
    },
    {
      provider = function(self)
        return self.hints > 0 and (' ' .. self.hint_icon .. self.hints)
      end,
      hl = { fg = 'diag_hint', bg = 'gray' },
    },
    { provider = '', hl = { fg = 'gray', bg = 'normal_bg' } },
  }
  local Snippets = {
    -- check that we are in insert or select mode
    condition = function()
      return vim.tbl_contains({ 's', 'i' }, vim.fn.mode())
    end,
    provider = function()
      if vim.snippet == nil or vim.snippet.active == nil then
        return ''
      end
      local forward = vim.snippet.active({ direction = 1 }) and '󰙡 ' or ''
      local backward = vim.snippet.active({ direction = -1 }) and '󰙣 ' or ''
      return backward .. forward
    end,
    hl = { fg = 'gray', bold = true },
  }
  local Align = { provider = '%=', hl = { fg = 'normal_bg', bg = 'normal_bg' } }
  local Space = { provider = ' ', hl = { fg = 'normal_bg', bg = 'normal_bg' } }
  -- FileNameBlock = utils.surround({ '', '' }, 'normal_bg', { FileNameBlock })
  -- Git = utils.surround({ '', '' }, 'gray', { Git })

  local DefaultStatusline = {
    ViMode, Space,
    FileNameBlock, Space,
    Snippets, Align,
    Diagnostics, Space,
    Git, Space,
  }
  require('heirline').setup({ statusline = DefaultStatusline })
end

return {
  'rebelot/heirline.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons', },
  event        = 'VeryLazy',
  config       = config
}
