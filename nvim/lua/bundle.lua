local plugins = require('plugins')

vim.pack.add({ "https://github.com/BirdeeHub/lze" }, { confirm = false })

local pack_specs = {}
for _, plugin in ipairs(plugins) do
  local pack_spec = { src = plugin.src }
  if plugin.name then
    pack_spec.name = plugin.name
  end
  table.insert(pack_specs, pack_spec)
end

vim.pack.add(pack_specs, {
  load = function() end,
  confirm = true,
})

vim.cmd.packadd("lze")

local lze_specs = {}
for _, plugin in ipairs(plugins) do
  if plugin.data then
    local spec = plugin.data
    spec.name = plugin.name or plugin.src:match("([^/]+)%.git$") or plugin.src:match("([^/]+)$")
    table.insert(lze_specs, spec)
  end
end

if #lze_specs > 0 then
  require("lze").load(lze_specs)
end
