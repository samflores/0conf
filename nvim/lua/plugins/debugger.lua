local config = function()
  local dap = require('dap')
  local dapui = require("dapui")
  local dap_vt = require("nvim-dap-virtual-text")
  local dap_vsc_js = require("dap-vscode-js")
  local dap_ruby = require('dap-ruby')

  vim.api.nvim_set_hl(0, 'DapBreakpoint', { link = 'DiffAdd' })
  vim.api.nvim_set_hl(0, 'DapLogPoint', { link = 'DiffChange' })
  vim.api.nvim_set_hl(0, 'DapStopped', { link = 'DiffDelete' })

  vim.fn.sign_define('DapBreakpoint', {
    text = '',
    texthl = 'DapBreakpoint',
    linehl = 'DapBreakpoint',
    numhl = 'DapBreakpoint'
  })
  vim.fn.sign_define('DapBreakpointCondition',
    { text = '', texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
  vim.fn.sign_define('DapBreakpointRejected',
    { text = '', texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
  vim.fn.sign_define('DapLogPoint',
    { text = '', texthl = 'DapLogPoint', linehl = 'DapLogPoint', numhl = 'DapLogPoint' })
  vim.fn.sign_define('DapStopped', { text = '', texthl = 'DapStopped', linehl = 'DapStopped', numhl = 'DapStopped' })

  dapui.setup()
  dap_ruby.setup()
  dap_vt.setup()
  dap_vsc_js.setup({
    debugger_path = vim.fn.stdpath("data") .. "/lazy/vscode-js-debug",
    adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' },
  })

  dap.adapters.codelldb = {
    type = 'server',
    port = "${port}",
    executable = {
      command = vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/adapter/codelldb",
      args = { "--port", "${port}" },
    }
  }

  for _, language in ipairs({ "typescript", "javascript", "svelte" }) do
    dap.configurations[language] = {
      {
        type = "pwa-node",
        request = "attach",
        processId = require 'dap.utils'.pick_process,
        name = "Attach debugger to existing `node --inspect` process",
        sourceMaps = true,
        resolveSourceMapLocations = {
          "${workspaceFolder}/**",
          "!**/node_modules/**" },
        cwd = "${workspaceFolder}/src",
        skipFiles = { "${workspaceFolder}/node_modules/**/*.js" },
      },
      {
        type = "pwa-chrome",
        name = "Launch Chrome to debug client",
        request = "launch",
        url = "http://localhost:5173",
        sourceMaps = true,
        protocol = "inspector",
        port = 9222,
        webRoot = "${workspaceFolder}/src",
        skipFiles = { "**/node_modules/**/*", "**/@vite/*", "**/src/client/*", "**/src/*" },
      },
      language == "javascript" and {
        type = "pwa-node",
        request = "launch",
        name = "Launch file in new node process",
        program = "${file}",
        cwd = "${workspaceFolder}",
      } or nil,
    }
  end

  dap.configurations.rust = {
    {
      name = 'Launch Executable',
      type = 'codelldb',
      request = 'launch',
      program = function()
        return coroutine.create(function(dap_run_co)
          local cwd = vim.fn.getcwd()
          local globs = vim.fn.globpath(cwd, "../target/debug/*")
          local files = vim.split(globs, "\n");
          files = vim.tbl_filter(
            function(path) return vim.fn.executable(path) == 1 end,
            files
          )
          files = vim.tbl_map(
            function(path)
              local pattern = string.gsub(cwd .. "/", "%-", "%%-")
              return path:gsub(pattern, '')
            end,
            files
          )

          vim.ui.select(files, { label = 'foo> ' }, function(choice)
            coroutine.resume(dap_run_co, choice)
          end)
        end)
      end,
      cwd = '${workspaceFolder}',
      stopOnEntry = false,
      args = {},
    }
  }

  dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open({ reset = true })
  end
  dap.listeners.before.event_terminated["dapui_config"] = dapui.close
  dap.listeners.before.event_exited["dapui_config"] = dapui.close
end

return {
  'rcarriga/nvim-dap-ui',
  dependencies = {
    'nvim-neotest/nvim-nio',
    'mfussenegger/nvim-dap',
    'suketa/nvim-dap-ruby',
    'theHamsta/nvim-dap-virtual-text',
    'mxsdev/nvim-dap-vscode-js',
    {
      'microsoft/vscode-js-debug',
      version = "1.x",
      build = "npm i && npm run compile vsDebugServerBundle && mv dist out"
    }
  },
  lazy = false,
  -- event = 'UiEnter',
  config = config,
  keys = {
    { '<leader>db', function() require 'dap'.toggle_breakpoint() end },
    { '<leader>dB', function() require 'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end },
    { '<leader>dp', function() require 'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end },
    { '<leader>dr', function() require 'dap'.repl.open() end },
    { '<leader>dl', function() require 'dap'.run_last() end },
    { '<f5>',       function() require 'dap'.continue() end },
    { '<leader>dc', function() require 'dap'.continue() end },
    { '<leader>do', function() require 'dap'.step_over() end },
    { '<leader>di', function() require 'dap'.step_into() end },
    { '<leader>dO', function() require 'dap'.step_out() end },
    { '<leader>dd', function() require 'dapui'.toggle() end },
    { "<Leader>dw", function() require('dapui').float_element('watches', { enter = true }) end },
    { "<Leader>ds", function() require('dapui').float_element('scopes', { enter = true }) end },
    { "<Leader>dr", function() require('dapui').float_element('repl', { enter = true }) end },
  }
}
