-- @diagnostic disable: unused-function

local config_zenbones = function()
  vim.api.nvim_set_hl(0, "NavicIconsFile", { bg = '#191919' })
  vim.api.nvim_set_hl(0, "NavicIconsModule", { bg = '#191919' })
  vim.api.nvim_set_hl(0, "NavicIconsNamespace", { bg = '#191919' })
  vim.api.nvim_set_hl(0, "NavicIconsPackage", { bg = '#191919' })
  vim.api.nvim_set_hl(0, "NavicIconsClass", { bg = '#191919' })
  vim.api.nvim_set_hl(0, "NavicIconsMethod", { bg = '#191919' })
  vim.api.nvim_set_hl(0, "NavicIconsProperty", { bg = '#191919' })
  vim.api.nvim_set_hl(0, "NavicIconsField", { bg = '#191919' })
  vim.api.nvim_set_hl(0, "NavicIconsConstructor", { bg = '#191919' })
  vim.api.nvim_set_hl(0, "NavicIconsEnum", { bg = '#191919' })
  vim.api.nvim_set_hl(0, "NavicIconsInterface", { bg = '#191919' })
  vim.api.nvim_set_hl(0, "NavicIconsFunction", { bg = '#191919' })
  vim.api.nvim_set_hl(0, "NavicIconsVariable", { bg = '#191919' })
  vim.api.nvim_set_hl(0, "NavicIconsConstant", { bg = '#191919' })
  vim.api.nvim_set_hl(0, "NavicIconsString", { bg = '#191919' })
  vim.api.nvim_set_hl(0, "NavicIconsNumber", { bg = '#191919' })
  vim.api.nvim_set_hl(0, "NavicIconsBoolean", { bg = '#191919' })
  vim.api.nvim_set_hl(0, "NavicIconsArray", { bg = '#191919' })
  vim.api.nvim_set_hl(0, "NavicIconsObject", { bg = '#191919' })
  vim.api.nvim_set_hl(0, "NavicIconsKey", { bg = '#191919' })
  vim.api.nvim_set_hl(0, "NavicIconsNull", { bg = '#191919' })
  vim.api.nvim_set_hl(0, "NavicIconsEnumMember", { bg = '#191919' })
  vim.api.nvim_set_hl(0, "NavicIconsStruct", { bg = '#191919' })
  vim.api.nvim_set_hl(0, "NavicIconsEvent", { bg = '#191919' })
  vim.api.nvim_set_hl(0, "NavicIconsOperator", { bg = '#191919' })
  vim.api.nvim_set_hl(0, "NavicIconsTypeParameter", { bg = '#191919' })
  vim.api.nvim_set_hl(0, "NavicText", { bg = '#191919' })
  vim.api.nvim_set_hl(0, "NavicSeparator", { bg = '#191919' })

  vim.cmd.colorscheme 'zenwritten'
end

local themes = {
  zenbones = { package = "zenbones-theme/zenbones.nvim", config = config_zenbones, dependencies = { "rktjmp/lush.nvim" } }
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
