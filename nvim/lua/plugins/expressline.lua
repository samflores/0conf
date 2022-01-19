local package = 'tjdevries/express_line.nvim'
local dependencies = {
  'kyazdani42/nvim-web-devicons',
  'nvim-lua/plenary.nvim'
}

local config = function()
  local modes_settings = {
    n      = { alias = '' },
    i      = { alias = '' },
    c      = { alias = '' },
    V      = { alias = '' },
    [''] = { alias = '' },
    v      = { alias = '' },
    rm     = { alias = '' },
    ['r?'] = { alias = '' },
    ['r']  = { alias = '' },
    R      = { alias = '' },
    Rv     = { alias = '' },
    s      = { alias = '' },
    S      = { alias = '' },
    [''] = { alias = '' },
    t      = { alias = '' },
    ['!']  = { alias = '!' },
  }

  require('el').setup {
    generator = function(win_id)
      local segments = {}
      local builtin = require('el.builtin')
      local subscribe = require('el.subscribe')
      local extensions = require('el.extensions')
      local helper = require("el.helper")

      -----------------------------------------------------
      -- CURRENT MODE
      -----------------------------------------------------
      local mode_provider = function(_window, _buffer)
        local mode_settings = modes_settings[vim.fn.mode()]
        return '%#Normal# ' .. mode_settings.alias
      end
      table.insert(segments, mode_provider)

      -----------------------------------------------------
      -- START BUBBLE
      -----------------------------------------------------
      table.insert(segments, ' %#StatusFilenameSeparator#%#StatusFilenameText#')

      -----------------------------------------------------
      -- FILE NAME
      -----------------------------------------------------
      table.insert(segments,
        subscribe.buf_autocmd(
          "el_file_icon",
          "BufRead",
          function(_, buffer)
            return extensions.file_icon(_, buffer)
          end
        ))
      table.insert(segments, ' ')

      -----------------------------------------------------
      -- FILE NAME
      -----------------------------------------------------
      -- table.insert(segments, builtin.tail_file)
      table.insert(segments,
        helper.async_buf_setter(
          win_id,
          "el_file_namer",
          builtin.tail_file,
          10000
        ))

      -----------------------------------------------------
      -- FILE MODIFIED
      -----------------------------------------------------
      table.insert(segments, builtin.modified)

      -----------------------------------------------------
      -- END BUBBLE
      -----------------------------------------------------
      table.insert(segments, '%#StatusFilenameSeparator#%#Normal# ')

      -----------------------------------------------------
      -- BRANCH NAME
      -----------------------------------------------------
      local branch_provider = function(window, buffer)
        return extensions.git_branch(window, buffer)
      end
      table.insert(segments,
        helper.async_buf_setter(
          win_id,
          "el_git_branch",
          branch_provider,
          10000
        ))

      -----------------------------------------------------
      -- GIT CHANGES INSIDE BUBBLE
      -----------------------------------------------------
      local changes_provider = function(window, buffer)
        local input = extensions.git_changes(window, buffer)
        local result = ' %#StatusFilenameSeparator#%#StatusFilenameText#'
        local delimiter = ","

        input = input.gsub(input, "[%]%[]", "")
        local m = nil
        for match in (input..delimiter):gmatch("(.-)"..delimiter) do
          m = match:match("+(%d+)")
          if m ~= nil then
            result = result .. " " .. m
          end
          m = match:match("~(%d+)")
          if m ~= nil then
            result = result .. " 硫" .. m
          end
          m = match:match("-(%d+)")
          if m ~= nil then
            result = result .. "  " .. m
          end
        end
        result = result .. '%#StatusFilenameSeparator#%#Normal#'

        return result
      end
      table.insert(segments,
        helper.async_buf_setter(
          win_id,
          "el_git_stat",
          changes_provider,
          5000
        ))

      -----------------------------------------------------
      -- RETURN ALL SEGMENTS
      -----------------------------------------------------
      return segments
    end
  }
end

local M = {}

function M.init(use)
  use {
    package ,
    requires = dependencies,
    config = config
  }
end

return M
