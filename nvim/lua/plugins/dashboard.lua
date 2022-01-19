local package = 'goolord/alpha-nvim'
local dependencies = { 'kyazdani42/nvim-web-devicons' }

local config = function()
  local alpha = require'alpha'
  local dashboard = require'alpha.themes.dashboard'
  dashboard.section.header.val = {
    [[                        _____ __                               ]],
    [[  __________    _____ _/ ____\  |   ____ _______  ____   ______]],
    [[ /  ___/__  \  /     \\   __\|  |  / __ \\_  __ \/ __ \ /  ___/]],
    [[ \___ \ / __ \_  | |  \|  |  |  |__  \_\ )|  | \/  ___/_\___ \ ]],
    [[/______\______/__|_|__/|__|  |____/\____/ |__|   \_____/______\]],
  }
  dashboard.section.buttons.val = {
    dashboard.button("e", "  New file",              ":ene <BAR> startinsert <CR>"),
    dashboard.button("h", "  Recently opened files", ",oh"),
    dashboard.button("q", "  Quit Neovim",           ":qa <CR>"),
  }
  local handle = io.popen('fortune')
  local fortune = handle:read("*a")
  handle:close()
  dashboard.section.footer.val = fortune

  dashboard.opts.opts.noautocmd = true

  vim.cmd[[autocmd User AlphaReady echo 'ready']]

  alpha.setup(dashboard.opts)
end

local M = {}

function M.init(use)
  use {
    package,
    requires = dependencies,
    config = config
  }
end

return M
