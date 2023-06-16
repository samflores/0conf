-- @diagnostic disable: unused-function

local config_monotone = function()
  vim.cmd.colorscheme "monotone"
  local hl = vim.api.nvim_get_hl_by_name("String", true)
  hl['italic'] = true
  vim.api.nvim_set_hl(0, "String", hl)
  hl = vim.api.nvim_get_hl_by_name("Identifier", true)
  hl['italic'] = false
  vim.api.nvim_set_hl(0, "Identifier", { italic = false })
  vim.api.nvim_set_hl(0, "GitSignsCurrentLineBlame", { link = "Comment" })
end

local config_iceberg = function()
  vim.cmd.colorscheme "iceberg"
  local hl = vim.api.nvim_get_hl_by_name("String", true)
  hl['italic'] = true
  vim.api.nvim_set_hl(0, "String", hl)

  hl = vim.api.nvim_get_hl_by_name("Comment", true)
  hl['italic'] = true
  vim.api.nvim_set_hl(0, "Comment", hl)

  vim.api.nvim_exec([[
    hi VertSplit ctermbg=234 ctermfg=239 guibg=#161821 guifg=#444b71
  ]], false)
end

local config_base16 = function()
  vim.cmd.colorscheme "base16-grayscale-dark"

  vim.api.nvim_exec([[
  hi DiffAdd     guifg=#88aa77  guibg=NONE  gui=NONE       ctermfg=107  ctermbg=NONE  cterm=NONE
	hi DiffDelete  guifg=#aa7766  guibg=NONE  gui=NONE       ctermfg=137  ctermbg=NONE  cterm=NONE
	hi DiffChange  guifg=#7788aa  guibg=NONE  gui=NONE       ctermfg=67   ctermbg=NONE  cterm=NONE
	hi DiffText    guifg=#7788aa  guibg=NONE  gui=underline  ctermfg=67   ctermbg=NONE  cterm=underline
  hi SignColumn     guifg=#88aa77  guibg=NONE  gui=NONE       ctermfg=107  ctermbg=NONE  cterm=NONE
  hi GitGutterAdd     guifg=#88aa77  guibg=NONE  gui=NONE       ctermfg=107  ctermbg=NONE  cterm=NONE
	hi GitGutterDelete  guifg=#aa7766  guibg=NONE  gui=NONE       ctermfg=137  ctermbg=NONE  cterm=NONE
	hi GitGutterChange  guifg=#7788aa  guibg=NONE  gui=NONE       ctermfg=67   ctermbg=NONE  cterm=NONE
	hi GitGutterChange  guifg=#7788aa  guibg=NONE  gui=NONE       ctermfg=67   ctermbg=NONE  cterm=NONE
  ]], false)

  local hl = vim.api.nvim_get_hl_by_name("String", true)
  hl['italic'] = true
  vim.api.nvim_set_hl(0, "String", hl)

  hl = vim.api.nvim_get_hl_by_name("Identifier", true)
  hl['italic'] = false
  vim.api.nvim_set_hl(0, "Identifier", hl)

  hl = vim.api.nvim_get_hl_by_name("LineNr", true)
  hl['bg'] = 'NONE'
  vim.api.nvim_set_hl(0, "LineNr", hl)
end

local config_yin_yang = function()
  -- https://github.com/
  vim.cmd.colorscheme "yin"
end

local config_tokyonight = function()
  require("tokyonight").setup({
    style = "storm",        -- The theme comes in three styles, `storm`, `moon`, a darker variant `night` and `day`
    transparent = true,     -- Enable this to disable setting the background color
    terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim
    styles = {
      comments = { italic = true },
      keywords = { italic = true },
      functions = {},
      variables = {},
      -- Background styles. Can be "dark", "transparent" or "normal"
      sidebars = "dark", -- style for sidebars, see below
      floats = "dark",   -- style for floating windows
    },
    sidebars = { "qf", "help" },
    day_brightness = 0.3,
  })
  vim.cmd.colorscheme "tokyonight-storm"
  -- hi StatusFilenameSeparator guifg=#dadae8 guibg=#1e1e29
  -- hi StatusFilenameText guifg=#1e1e29 guibg=#dadae8
end

local config_rose_pine = function()
  require('rose-pine').setup({
    --- @usage 'main' | 'moon'
    dark_variant = 'main',
    bold_vert_split = false,
    dim_nc_background = false,
    disable_background = true,
    disable_float_background = true,
    disable_italics = false,
  })
  vim.cmd.colorscheme "rose-pine"
end

local config_catppuccin = function()
  require('catppuccin').setup({
    transparent_background = false
  })
  vim.cmd.colorscheme "catppuccin-mocha"
end

local config_sweetie = function()
  require('sweetie').setup({
  })
  vim.cmd.colorscheme "sweetie"
end

local config_warlock = function()
  local hl = vim.api.nvim_get_hl_by_name("String", true)
  hl['italic'] = true
  vim.api.nvim_set_hl(0, "String", hl)
  hl = vim.api.nvim_get_hl_by_name("Identifier", true)
  hl['italic'] = false
  vim.api.nvim_set_hl(0, "Identifier", { italic = false })
  vim.api.nvim_set_hl(0, "GitSignsCurrentLineBlame", { link = "Comment" })
  vim.cmd.colorscheme "warlock"
end

local config_komau = function()
  vim.cmd.colorscheme "komau"
end

local config_preto = function()
  vim.cmd.colorscheme "preto"
  local hl = vim.api.nvim_get_hl_by_name("String", true)
  hl['italic'] = true
  vim.api.nvim_set_hl(0, "String", hl)
  hl = vim.api.nvim_get_hl_by_name("Identifier", true)
  hl['italic'] = false
  vim.api.nvim_set_hl(0, "Identifier", { italic = false })
  vim.api.nvim_set_hl(0, "GitSignsCurrentLineBlame", { link = "Comment" })
end

local config_monochrome = function()
  vim.cmd.colorscheme "monochrome"
  local hl = vim.api.nvim_get_hl_by_name("String", true)
  hl['italic'] = true
  vim.api.nvim_set_hl(0, "String", hl)
  hl = vim.api.nvim_get_hl_by_name("Identifier", true)
  hl['italic'] = false
  vim.api.nvim_set_hl(0, "Identifier", { italic = false })
  vim.api.nvim_set_hl(0, "GitSignsCurrentLineBlame", { link = "Comment" })
end

local themes = {
  warlock = { package = "hardselius/warlock", config = config_warlock },
  iceberg = { package = "cocopon/iceberg.vim", config = config_iceberg },
  monotone = { package = "Lokaltog/monotone.nvim", config = config_monotone },
  base16 = { package = "chriskempson/base16-vim", config = config_base16 },
  yin_yang = { package = "pgdouyon/vim-yin-yang", config = config_yin_yang },
  tokyonight = { package = 'folke/tokyonight.nvim', config = config_tokyonight },
  rose_pine = { package = 'rose-pine/neovim', config = config_rose_pine },
  catppuccin = { package = 'catppuccin/nvim', config = config_catppuccin },
  sweetie = { package = "NTBBloodbath/sweetie.nvim", config = config_sweetie },
  komau = { package = "ntk148v/komau.vim", config = config_komau },
  preto = { package = "ewilazarus/preto", config = config_preto },
  monochrome = { package = "fxn/vim-monochrome", config = config_monochrome },
}

local current = 'iceberg'

return {
  themes[current].package,
  config = themes[current].config,
  dependencies = {
    'folke/lsp-colors.nvim',
    'rktjmp/lush.nvim'
  }
}
