local package = 'rcarriga/nvim-dap-ui'
local dependencies = {
  'Pocco81/DAPInstall.nvim',
  'mfussenegger/nvim-dap'
}

local config = function()
  local dap_install = require("dap-install")

  dap_install.setup({
    installation_path = vim.fn.stdpath("data") .. "/dapinstall/",
  })

  dap_install.config("jsnode", {})
  dap_install.config("ruby_vsc", {
    configurations = {
      {
        type = "ruby",
        name = "ruby",
        request = "launch",
        program = "${file}",
        args = {
          "--rules-file", "spec/fixtures/smallinput.txt" ,
          "--bag", "shiny gold" ,
        },
      }
    }
  })
  dap_install.config("ccppr_vsc", {})

  require("dapui").setup()

  local map = vim.api.nvim_set_keymap
  local opt = { silent = true, noremap = true }

  map('n', '<leader>db', ":lua require'dap'.toggle_breakpoint()<cr>", opt)
  map('n', '<leader>dB', ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>", opt)
  map('n', '<leader>dp', ":lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>", opt)
  map('n', '<leader>dr', ":lua require'dap'.repl.open()<CR>", opt)
  map('n', '<leader>dl', ":lua require'dap'.run_last()<CR>", opt)

  map('n', '<leader>dc',  ":lua require'dap'.continue()<CR>", opt)
  map('n', '<leader>do', ":lua require'dap'.step_over()<CR>", opt)
  map('n', '<leader>di', ":lua require'dap'.step_into()<CR>", opt)
  map('n', '<leader>dO', ":lua require'dap'.step_out()<CR>", opt)

  map('n', '<leader>dd', ":lua require'dapui'.toggle()<CR>", opt)
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
