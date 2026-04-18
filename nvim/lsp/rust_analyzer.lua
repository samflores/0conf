local function reload_workspace(bufnr)
  local clients = vim.lsp.get_clients { bufnr = bufnr, name = 'rust_analyzer' }
  for _, client in ipairs(clients) do
    vim.notify 'Reloading Cargo Workspace'
    client.request('rust-analyzer/reloadWorkspace', nil, function(err)
      if err then
        error(tostring(err))
      end
      vim.notify 'Cargo workspace reloaded'
    end, 0)
  end
end

local function is_library(fname)
  local user_home = vim.fs.normalize(vim.env.HOME)
  local cargo_home = os.getenv 'CARGO_HOME' or user_home .. '/.cargo'
  local registry = cargo_home .. '/registry/src'
  local git_registry = cargo_home .. '/git/checkouts'

  local rustup_home = os.getenv 'RUSTUP_HOME' or user_home .. '/.rustup'
  local toolchains = rustup_home .. '/toolchains'

  for _, item in ipairs { toolchains, registry, git_registry } do
    if vim.fs.relpath(item, fname) then
      local clients = vim.lsp.get_clients { name = 'rust_analyzer' }
      return #clients > 0 and clients[#clients].config.root_dir or nil
    end
  end
end

local function pick_toolchain(root_dir)
  local file = vim.fs.find({ 'rust-toolchain.toml', 'rust-toolchain' }, { upward = true, path = root_dir })[1]
  if not file then return nil end

  local content = table.concat(vim.fn.readfile(file), '\n')
  local channel = content:match('[Cc]hannel%s*=%s*"%s*([^"%s]+)%s*"')
      or content:match('^%s*([%w%-%./]+)%s*$') -- plain rust-toolchain file
  return channel
end

local function get_cargo_root(bufnr)
  local fname = vim.api.nvim_buf_get_name(bufnr)
  return vim.fs.root(fname, { 'Cargo.toml' }) or vim.fn.getcwd()
end

local function run_cargo_command(bufnr, cmd_args)
  local root = get_cargo_root(bufnr)

  -- Find or create terminal buffer
  local term_bufnr = vim.b[bufnr].cargo_term_bufnr
  local term_valid = term_bufnr and vim.api.nvim_buf_is_valid(term_bufnr)

  -- Create terminal in horizontal split
  vim.cmd('split')
  local win = vim.api.nvim_get_current_win()

  if term_valid then
    vim.api.nvim_win_set_buf(win, term_bufnr)
  else
    local new_bufnr = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_win_set_buf(win, new_bufnr)
    vim.b[bufnr].cargo_term_bufnr = new_bufnr
    term_bufnr = new_bufnr
  end

  -- Build the command
  local full_cmd = 'cd ' .. vim.fn.shellescape(root) .. ' && cargo ' .. cmd_args

  -- Clear terminal and run command
  vim.fn.termopen(full_cmd, {
    on_exit = function(_, exit_code)
      if exit_code == 0 then
        vim.schedule(function()
          vim.notify('Cargo command completed successfully', vim.log.levels.INFO)
        end)
      else
        vim.schedule(function()
          vim.notify('Cargo command failed with exit code ' .. exit_code, vim.log.levels.ERROR)
        end)
      end
    end
  })

  -- Scroll to bottom and enter insert mode
  vim.cmd('normal! G')
  vim.cmd('startinsert')
end

return {
  cmd = { 'rustup', 'run', 'nightly', 'rust-analyzer' },
  filetypes = { 'rust' },
  on_new_config = function(config, root_dir)
    local tc = pick_toolchain(root_dir)
    if tc and #tc > 0 then
      config.cmd = { 'rustup', 'run', tc, 'rust-analyzer' }
    else
      config.cmd = { 'rustup', 'run', 'stable', 'rust-analyzer' }
    end
  end,
  root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    local reused_dir = is_library(fname)
    if reused_dir then
      on_dir(reused_dir)
      return
    end

    local cargo_crate_dir = vim.fs.root(fname, { 'Cargo.toml' })
    local cargo_workspace_root

    if cargo_crate_dir == nil then
      on_dir(
        vim.fs.root(fname, { 'rust-project.json' })
        or vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
      )
      return
    end

    local cmd = {
      'cargo',
      'metadata',
      '--no-deps',
      '--format-version',
      '1',
      '--manifest-path',
      cargo_crate_dir .. '/Cargo.toml',
    }

    vim.system(cmd, { text = true }, function(output)
      if output.code == 0 then
        if output.stdout then
          local result = vim.json.decode(output.stdout)
          if result['workspace_root'] then
            cargo_workspace_root = vim.fs.normalize(result['workspace_root'])
          end
        end

        on_dir(cargo_workspace_root or cargo_crate_dir)
      else
        vim.schedule(function()
          vim.notify(('[rust_analyzer] cmd failed with code %d: %s\n%s'):format(output.code, cmd, output.stderr))
        end)
      end
    end)
  end,
  capabilities = {
    experimental = {
      serverStatusNotification = true,
    },
  },
  before_init = function(init_params, config)
    -- See https://github.com/rust-lang/rust-analyzer/blob/eb5da56d839ae0a9e9f50774fa3eb78eb0964550/docs/dev/lsp-extensions.md?plain=1#L26
    if config.settings and config.settings['rust-analyzer'] then
      init_params.initializationOptions = config.settings['rust-analyzer']
    end
  end,
  on_attach = function(_, bufnr)
    vim.api.nvim_buf_create_user_command(bufnr, 'LspCargoReload', function()
      reload_workspace(bufnr)
    end, { desc = 'Reload current cargo workspace' })

    -- CargoRun command
    vim.api.nvim_buf_create_user_command(bufnr, 'CargoRun', function(opts)
      local args = opts.args
      local cmd_args = 'run'

      -- Parse profile flag
      if args:match('^%-%-release') then
        cmd_args = cmd_args .. ' --release'
        args = args:gsub('^%-%-release%s*', '')
      elseif args:match('^%-%-debug') then
        args = args:gsub('^%-%-debug%s*', '')
      end

      -- Add remaining arguments
      if #args > 0 then
        cmd_args = cmd_args .. ' ' .. args
      end

      run_cargo_command(bufnr, cmd_args)
    end, { nargs = '*', desc = 'Run cargo run with optional profile and args' })

    -- CargoBuild command
    vim.api.nvim_buf_create_user_command(bufnr, 'CargoBuild', function(opts)
      local args = opts.args
      local cmd_args = 'build'

      if args:match('%-%-release') then
        cmd_args = cmd_args .. ' --release'
      end

      run_cargo_command(bufnr, cmd_args)
    end, { nargs = '?', desc = 'Build cargo project' })

    -- CargoCheck command
    vim.api.nvim_buf_create_user_command(bufnr, 'CargoCheck', function()
      run_cargo_command(bufnr, 'check')
    end, { desc = 'Run cargo check' })

    -- Key mappings
    local function map(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, noremap = true, silent = true, desc = desc })
    end

    -- Run in debug mode (no prompt)
    map('n', '<leader>cd', function()
      run_cargo_command(bufnr, 'run')
    end, 'Cargo: Run (debug)')

    -- Run in release mode (no prompt)
    map('n', '<leader>cr', function()
      run_cargo_command(bufnr, 'run --release')
    end, 'Cargo: Run (release)')

    -- Run in debug mode with args prompt
    map('n', '<leader>cD', function()
      vim.ui.input({ prompt = 'Cargo run arguments: ' }, function(input)
        if input then
          local cmd_args = 'run'
          if #input > 0 then
            cmd_args = cmd_args .. ' -- ' .. input
          end
          run_cargo_command(bufnr, cmd_args)
        end
      end)
    end, 'Cargo: Run (debug, prompt args)')

    -- Run in release mode with args prompt
    map('n', '<leader>cR', function()
      vim.ui.input({ prompt = 'Cargo run arguments: ' }, function(input)
        if input then
          local cmd_args = 'run --release'
          if #input > 0 then
            cmd_args = cmd_args .. ' -- ' .. input
          end
          run_cargo_command(bufnr, cmd_args)
        end
      end)
    end, 'Cargo: Run (release, prompt args)')

    -- Build in debug mode
    map('n', '<leader>cbd', function()
      run_cargo_command(bufnr, 'build')
    end, 'Cargo: Build (debug)')

    -- Build in release mode
    map('n', '<leader>cbr', function()
      run_cargo_command(bufnr, 'build --release')
    end, 'Cargo: Build (release)')

    -- Cargo check
    map('n', '<leader>cc', function()
      run_cargo_command(bufnr, 'check')
    end, 'Cargo: Check')
  end,
}
