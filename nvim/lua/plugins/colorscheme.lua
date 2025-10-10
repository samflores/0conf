-- @diagnostic disable: unused-function

local config_zenbones = function()
  vim.g.transparent_background = true
  vim.cmd.colorscheme 'tokyobones'
end

local config_lackluster = function()
  require('lackluster').setup({
    tweak_highlight = {
      ['@string'] = { overwrite = false, italic = true, },
      ['@comment'] = { overwrite = false, italic = true, },
    },
    tweak_background = {
      normal = '#0b0b0b',
      popup = '#0b0b0b',
      menu = '#0b0b0b',
    },
  })
  vim.cmd.colorscheme 'lackluster'
end

local config_techbase = function()
  vim.cmd.colorscheme 'techbase'
end

local config_coal = function()
  vim.cmd.colorscheme 'coal'
end

local config_iceberg = function()
  vim.cmd.colorscheme 'iceberg'
end

local themes = {
  zenbones = { package = 'zenbones-theme/zenbones.nvim', config = config_zenbones, dependencies = { 'rktjmp/lush.nvim' } },
  lackluster = { package = 'slugbyte/lackluster.nvim', config = config_lackluster },
  techbase = { package = 'mcauley-penney/techbase.nvim', config = config_techbase },
  iceberg = { package = 'cocopon/iceberg.vim', config = config_iceberg },
}

local current = 'zenbones'

return {
  themes[current].package,
  config = function()
    if themes[current].config ~= nil then
      themes[current].config()
    else
      vim.cmd.colorscheme(current)
    end
  end,
  lazy = false,
  priority = 1000,
  dependencies = themes[current].dependencies or {}
}
