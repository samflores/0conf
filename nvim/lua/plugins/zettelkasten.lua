local nopt = { mode = 'n', noremap = true }
local iopt = { mode = 'i', noremap = true }

local keys = {
  { '<leader>zf', function() require('telekasten').find_notes() end,                  nopt },
  { '<leader>zd', function() require('telekasten').find_daily_notes() end,            nopt },
  { '<leader>zg', function() require('telekasten').search_notes() end,                nopt },
  { '<leader>zz', function() require('telekasten').follow_link() end,                 nopt },
  { '<leader>zT', function() require('telekasten').goto_today() end,                  nopt },
  { '<leader>zW', function() require('telekasten').goto_thisweek() end,               nopt },
  { '<leader>zw', function() require('telekasten').find_weekly_notes() end,           nopt },
  { '<leader>zn', function() require('telekasten').new_note() end,                    nopt },
  { '<leader>zN', function() require('telekasten').new_templated_note() end,          nopt },
  { '<leader>zy', function() require('telekasten').yank_notelink() end,               nopt },
  { '<leader>zc', function() require('telekasten').show_calendar() end,               nopt },
  { '<leader>zC', '<cmd>:CalendarT<CR>',                                              nopt },
  { '<leader>zi', function() require('telekasten').paste_img_and_link() end,          nopt },
  { '<leader>zt', function() require('telekasten').toggle_todo() end,                 nopt },
  { '<leader>zb', function() require('telekasten').show_backlinks() end,              nopt },
  { '<leader>zF', function() require('telekasten').find_friends() end,                nopt },
  { '<leader>zI', function() require('telekasten').insert_img_link({ i = true }) end, nopt },
  { '<leader>zp', function() require('telekasten').preview_img() end,                 nopt },
  { '<leader>zm', function() require('telekasten').browse_media() end,                nopt },
  { '<leader>za', function() require('telekasten').show_tags() end,                   nopt },
  { '<leader>#',  function() require('telekasten').show_tags() end,                   nopt },
  { '<leader>zr', function() require('telekasten').rename_note() end,                 nopt },
  { '<leader>z',  function() require('telekasten').panel() end,                       nopt },
  { '[[',         function() require('telekasten').insert_link({ i = true }) end,     iopt },
  { '<leader>zt', function() require('telekasten').toggle_todo({ i = true }) end,     iopt },
  { '<leader>#',  function() require('telekasten').show_tags({ i = true }) end,       iopt },
}

return {
  'renerocksai/telekasten.nvim',
  keys = keys,
  opts = {
    home = vim.fn.expand("~/Documents/Notes"),
    calendar_opts = {
      weeknm = 5,
      calendar_monday = 0,
    },
  },
  dependencies = {
    'renerocksai/calendar-vim'
  }
}
