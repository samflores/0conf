local cmd = vim.cmd
local set = vim.opt

local M = {}
M.create_augroup = function(group_name, autocmds_defs)
  local group = vim.api.nvim_create_augroup(group_name, { clear = true })
  for _, autocmd_def in ipairs(autocmds_defs) do
    local pattern = autocmd_def.pattern
    local opts = {
      group = group,
      callback = autocmd_def.callback
    }
    if pattern ~= nil then
      opts.pattern = pattern
    end
    local buffer = autocmd_def.buffer
    if buffer ~= nil then
      opts.buffer = buffer
    end
    vim.api.nvim_create_autocmd(autocmd_def.event, opts)
  end
  cmd('augroup END')
end

local create_augroup = M.create_augroup

create_augroup('Focus', {
  {
    event = 'FocusLost',
    pattern = '<buffer>',
    callback = function()
      local buf = vim.api.nvim_get_current_buf()
      vim.api.nvim_buf_call(buf, function()
        cmd("silent! write")
      end)
    end
  }
})

create_augroup('Resize', {
  {
    event = 'VimResized',
    pattern = '<buffer>',
    callback = function()
      local buf = vim.api.nvim_get_current_buf()
      vim.api.nvim_buf_call(buf, function()
        cmd("wincmd =")
      end)
    end
  }
})

create_augroup('term', {
  {
    event = { 'BufNew', 'BufNewFile', 'BufRead' },
    pattern = 'term://*',
    callback = function()
      set.spell = false
      set.list = false
    end
  },
})

create_augroup('clojure', {
  {
    event = 'FileType',
    pattern = 'clojure',
    callback = 'setlocal lw+=match,go,go-loop,'
  },
})

create_augroup('trailing', {
  {
    event = { 'WinLeave', 'InsertEnter' },
    pattern = '*',
    callback = function() set.list = false end
  },
  {
    event = { 'WinEnter', 'InsertLeave' },
    pattern = '*',
    callback = function() set.list = true end
  },
})

create_augroup('edit_vimrc', {
  {
    event = 'BufWritePost',
    pattern = vim.fn.expand('$MYVIMRC'),
    callback = 'luafile $MYVIMRC'
  },
})

create_augroup('runNearestTest', {
  {
    event = { 'BufNew', 'BufNewFile', 'BufReadPost' },
    pattern = { '*_spec.rb', '*_test.rb', '*.spec.js', '*.spec.ts' },
    callback = function()
      vim.keymap.set('n', '<Enter>', require('neotest').run.run, { noremap = true })
    end
  }
})

create_augroup('jscinoptions', {
  {
    event = { 'BufRead', 'BufNewFile' },
    pattern = '*.js',
    callback = function() set.cino = '(1s' end
  },
})

create_augroup('Neovim configs', {
  {
    event = { 'BufReadPost' },
    pattern = vim.env.HOME .. '/.config/nvim/**/*.lua',
    callback = function()
      vim.bo[0].bufhidden = 'wipe'
    end
  }
})

create_augroup('UserLspConfig', {
  {
    event = 'LspAttach',
    callback = function(ev)
      local bufnr = ev.buf
      if ev.data.client_id == nil then
        return
      end

      local map = vim.keymap.set
      local opts = { noremap = true, buffer = ev.buf }

      local client = vim.lsp.get_client_by_id(ev.data.client_id)
      if client == nil then
        return
      end

      local navic = require("nvim-navic")
      if client.server_capabilities.documentSymbolProvider then
        navic.attach(client, bufnr)
      end

      local capabilities = client.server_capabilities;
      if capabilities then
        if capabilities.completionProvider then
          vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
        end

        if capabilities.definitionProvider then
          vim.bo[bufnr].tagfunc = "v:lua.vim.lsp.tagfunc"
        end

        if capabilities.documentFormattingProvider then
          map("n", "<space>f", vim.lsp.buf.format, opts)
          vim.api.nvim_create_autocmd('BufWritePre', {
            callback = function() vim.lsp.buf.format() end
          })
        end

        if capabilities.inlayHintProvider then
          map("n", "<leader>ih", function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled(), { bufnr = ev.buf })
          end, opts)
          vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
        end

        if capabilities.documentRangeFormattingProvider then
          map("v", "<space>f", function() vim.lsp.buf.range_formatting() end, opts)
        end

        if capabilities.documentHighlightProvider then
          create_augroup('lsp_document_highlight', {
            { event = 'CursorHold',  buffer = bufnr, callback = vim.lsp.buf.document_highlight },
            { event = 'CursorMoved', buffer = bufnr, callback = vim.lsp.buf.clear_references },
          })
        end
      end

      map('n', 'gD', vim.lsp.buf.declaration)
      map('n', 'gd', vim.lsp.buf.definition)
      map('n', 'K', vim.lsp.buf.hover)
      map('n', 'gs', vim.lsp.buf.signature_help)
      map('n', 'gi', vim.lsp.buf.implementation)
      map('n', 'gt', vim.lsp.buf.type_definition)
      map('n', '<leader>gw', vim.lsp.buf.document_symbol)
      map('n', '<leader>gW', vim.lsp.buf.workspace_symbol)
      map('n', '<leader>ee', vim.lsp.util.show_line_diagnostics)
      map('n', '<leader>ai', vim.lsp.buf.incoming_calls)
      map('n', '<leader>ao', vim.lsp.buf.outgoing_calls)
    end
  }
})

return M
