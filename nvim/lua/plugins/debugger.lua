local config = function()
  local dap = require('dap')
  local dapui = require('dapui')
  local dap_vt = require('nvim-dap-virtual-text')
  -- local dap_vsc_js = require('dap-vscode-js')
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

  -- dap.adapters["pwa-node"] = {
  --   type = "server",
  --   host = "localhost",
  --   port = "${port}",
  --   executable = {
  --     command = "node",
  --     args = {
  --       "/path/to/js-debug/src/dapDebugServer.js", "${port}"
  --     },
  --   }
  -- }
  --
  --require("dap").configurations.javascript = {
  --   {
  --     type = "pwa-node",
  --     request = "launch",
  --     name = "Launch file",
  --     program = "${file}",
  --     cwd = "${workspaceFolder}",
  --   },
  -- }

  dap.adapters.codelldb = {
    type = 'server',
    port = '${port}',
    executable = {
      command = vim.fn.stdpath('data') .. '/mason/packages/codelldb/extension/adapter/codelldb',
      args = { '--port', '${port}' },
    }
  }

  dap.adapters.cppdbg = {
    id = 'cppdbg',
    type = 'executable',
    command = vim.fn.stdpath('data') .. '/mason/packages/cpptools/extension/debugAdapters/bin/OpenDebugAD7',
  }

  for _, language in ipairs({ 'typescript', 'javascript', 'svelte' }) do
    dap.configurations[language] = {
      {
        type = 'pwa-node',
        request = 'attach',
        processId = require 'dap.utils'.pick_process,
        name = 'Attach debugger to existing `node --inspect` process',
        sourceMaps = true,
        resolveSourceMapLocations = {
          '${workspaceFolder}/**',
          '!**/node_modules/**' },
        cwd = '${workspaceFolder}/src',
        skipFiles = { '${workspaceFolder}/node_modules/**/*.js' },
      },
      {
        type = 'pwa-chrome',
        name = 'Launch Chrome to debug client',
        request = 'launch',
        url = 'http://localhost:5173',
        sourceMaps = true,
        protocol = 'inspector',
        port = 9222,
        webRoot = '${workspaceFolder}/src',
        skipFiles = { '**/node_modules/**/*', '**/@vite/*', '**/src/client/*', '**/src/*' },
      },
      language == 'javascript' and {
        type = 'pwa-node',
        request = 'launch',
        name = 'Launch file in new node process',
        program = '${file}',
        cwd = '${workspaceFolder}',
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
          local globs = vim.fn.globpath(cwd, 'target/debug/*')
          local files = vim.split(globs, '\n');
          files = vim.tbl_filter(
            function(path) return vim.fn.executable(path) == 1 end,
            files
          )
          files = vim.tbl_map(
            function(path)
              local pattern = string.gsub(cwd .. '/', '%-', '%%-')
              return path:gsub(pattern, '')
            end,
            files
          )

          vim.ui.select(files, { label = 'foo> ' }, function(choice)
            coroutine.resume(dap_run_co, choice)
          end)
        end)
      end,
      -- cwd = '${workspaceFolder}',
      cwd = 'target/debug',
      stopOnEntry = false,
      args = {},
    },
    {
      name = 'Attach to QEMU (min-os kernel)',
      type = 'cppdbg',
      request = 'launch',
      MIMode = 'gdb',
      miDebuggerServerAddress = 'localhost:1234',
      miDebuggerPath = '/bin/gdb',
      program = '${workspaceFolder}/target/x86_64-unknown-none/release/min-os-kernel',
      cwd = '${workspaceFolder}',
      stopAtEntry = false,
      setupCommands = {
        { text = 'set architecture i386:x86-64', ignoreFailures = false },
        { text = 'add-symbol-file ${workspaceFolder}/target/x86_64-unknown-none/release/init 0x400000', ignoreFailures = true },
        { text = 'add-symbol-file ${workspaceFolder}/target/x86_64-unknown-none/release/memsrv 0x500000', ignoreFailures = true },
      },
    },
    {
      name = 'Launch GDB (min-os kernel)',
      type = 'cppdbg',
      request = 'launch',
      MIMode = 'gdb',
      miDebuggerPath = '/bin/gdb',
      program = '${workspaceFolder}/target/x86_64-unknown-none/release/min-os-kernel',
      cwd = '${workspaceFolder}',
      stopAtEntry = true,
      setupCommands = {
        { text = 'set architecture i386:x86-64', ignoreFailures = false },
      },
    },
  }

  dap.listeners.after.event_initialized['dapui_config'] = function()
    dapui.open({ reset = true })
  end
  dap.listeners.before.event_terminated['dapui_config'] = dapui.close
  dap.listeners.before.event_exited['dapui_config'] = dapui.close
end

return {
  {
    src = 'https://github.com/nvim-neotest/nvim-nio',
  },
  {
    src = 'https://github.com/mfussenegger/nvim-dap',
    data = {
      dep_of = 'nvim-dap-ui',
    },
  },
  {
    src = 'https://github.com/suketa/nvim-dap-ruby',
    data = {
      dep_of = 'nvim-dap-ui',
    },
  },
  {
    src = 'https://github.com/theHamsta/nvim-dap-virtual-text',
    data = {
      dep_of = 'nvim-dap-ui',
    },
  },
  {
    src = 'https://github.com/rcarriga/nvim-dap-ui',
    name = 'nvim-dap-ui',
    data = {
      -- {
      --   'microsoft/vscode-js-debug',
      --   version = '1.x',
      --   build = 'npm i && npm run compile vsDebugServerBundle && mv dist out'
      -- }
      before = function()
        vim.cmd.packadd('nvim-nio')
        vim.cmd.packadd('nvim-dap')
        vim.cmd.packadd('nvim-dap-ruby')
        vim.cmd.packadd('nvim-dap-virtual-text')
      end,
      keys = {
        { lhs = '<leader>db', rhs = function() require 'dap'.toggle_breakpoint() end },
        { lhs = '<leader>dB', rhs = function() require 'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end },
        { lhs = '<leader>dp', rhs = function() require 'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end },
        { lhs = '<leader>dr', rhs = function() require 'dap'.repl.open() end },
        { lhs = '<leader>dl', rhs = function() require 'dap'.run_last() end },
        { lhs = '<f5>',       rhs = function() require 'dap'.continue() end },
        { lhs = '<leader>dc', rhs = function() require 'dap'.continue() end },
        { lhs = '<leader>do', rhs = function() require 'dap'.step_over() end },
        { lhs = '<leader>di', rhs = function() require 'dap'.step_into() end },
        { lhs = '<leader>dO', rhs = function() require 'dap'.step_out() end },
        { lhs = '<leader>dd', rhs = function() require 'dapui'.toggle() end },
        { lhs = '<Leader>dw', rhs = function() require('dapui').float_element('watches', { enter = true }) end },
        { lhs = '<Leader>ds', rhs = function() require('dapui').float_element('scopes', { enter = true }) end },
        { lhs = '<Leader>dr', rhs = function() require('dapui').float_element('repl', { enter = true }) end },
      },
      after = config,
    },
  },
}
