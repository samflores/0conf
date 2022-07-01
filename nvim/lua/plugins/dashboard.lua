local package = 'goolord/alpha-nvim'
local dependencies = { 'kyazdani42/nvim-web-devicons' }

local config = function()
  local alpha = require'alpha'
  local dashboard = require'alpha.themes.dashboard'
  dashboard.section.header.val = {
    [[              _-o#&&*''''?d:>b\_]],
    [[          _o/"`''  '',, dMF9MMMMMHo_]],
    [[       .o&#'        `"MbHMMMMMMMMMMMHo.]],
    [[     .o"" '         vodM*$&&HMMMMMMMMMM?.]],
    [[    ,'              $M&ood,~'`(&##MMMMMMH\]],
    [[   /               ,MMMMMMM#b?#bobMMMMHMMML]],
    [[  &              ?MMMMMMMMMMMMMMMMM7MMM$R*Hk]],
    [[ ?$.            :MMMMMMMMMMMMMMMMMMM/HMMM|`*L]],
    [[|               |MMMMMMMMMMMMMMMMMMMMbMH'   T,]],
    [[$H#:            `*MMMMMMMMMMMMMMMMMMMMb#}'  `?]],
    [[]MMH#             ""*""""*#MMMMMMMMMMMMM'    -]],
    [[MMMMMb_                   |MMMMMMMMMMMP'     :]],
    [[HMMMMMMMHo                 `MMMMMMMMMT       .]],
    [[?MMMMMMMMP                  9MMMMMMMM}       -]],
    [[-?MMMMMMM                  |MMMMMMMMM?,d-    ']],
    [[ :|MMMMMM-                 `MMMMMMMT .M|.   :]],
    [[  .9MMM[                    &MMMMM*' `'    .]],
    [[   :9MMk                    `MMM#"        -]],
    [[     &M}                     `          .-]],
    [[      `&.                             .]],
    [[        `~,   .                     ./]],
    [[            . _                  .-]],
    [[              '`--._,dd###pp=""']],
  }
  dashboard.section.buttons.val = {
    dashboard.button("e", "  New file",              ":ene <BAR> startinsert <CR>"),
    dashboard.button("f", "  Find file",             ":Telescope find_files<CR>"),
    dashboard.button("h", "  Recently opened files", ":Telescope oldfiles cwd_only=true<CR>"),
    dashboard.button("b", "  Browse project",        ":Telescope file_browser grouped=true<CR>"),
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
