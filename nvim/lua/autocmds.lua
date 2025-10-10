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

create_augroup('Highlight', {
  {
    event = 'FileType',
    pattern = '<filetype>',
    callback = vim.treesitter.start
  }
})

create_augroup('Focus', {
  {
    event = 'FocusLost',
    pattern = '<buffer>',
    callback = function()
      local buf = vim.api.nvim_get_current_buf()
      vim.api.nvim_buf_call(buf, function()
        cmd('silent! write')
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
        cmd('wincmd =')
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


create_augroup('reload_wallpaper', {
  {
    event = 'BufWritePost',
    pattern = '/home/samflores/Code/0conf/hypr/hyprpaper.conf',
    callback = function() os.execute('killall hyprpaper; setsid -f hyprpaper > /dev/null 2>&1') end
  },
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
      local buffer = ev.buf
      if ev.data.client_id == nil then
        return
      end

      vim.diagnostic.config({
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = ' ',
            [vim.diagnostic.severity.WARN] = ' ',
            [vim.diagnostic.severity.HINT] = ' ',
            [vim.diagnostic.severity.INFO] = ' ',
          },
          linehl = {
            [vim.diagnostic.severity.ERROR] = 'DiagnosticSignError',
            [vim.diagnostic.severity.WARN] = 'DiagnosticSignWarn',
            [vim.diagnostic.severity.HINT] = 'DiagnosticSignHint',
            [vim.diagnostic.severity.INFO] = 'DiagnosticSignInfo',
          },
          numhl = {
            [vim.diagnostic.severity.ERROR] = '',
            [vim.diagnostic.severity.WARN] = '',
            [vim.diagnostic.severity.HINT] = '',
            [vim.diagnostic.severity.INFO] = '',
          },
        },
      })

      local map = vim.keymap.set
      local opts = { noremap = true, buffer = ev.buf }

      local client = vim.lsp.get_client_by_id(ev.data.client_id)
      if client == nil then
        return
      end

      if client:supports_method(vim.lsp.protocol.Methods.textDocument_documentSymbol) then
        -- local navic = require('nvim-navic')
        -- navic.attach(client, buffer)
        map('n', '<leader>gw', vim.lsp.buf.document_symbol)
        map('n', '<leader>gW', vim.lsp.buf.workspace_symbol)
      end

      if client:supports_method(vim.lsp.protocol.Methods.textDocument_completion) then
        -- vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'
        vim.opt.completeopt = { 'menu', 'menuone', 'noinsert', 'fuzzy', 'popup' }
        vim.lsp.completion.enable(true, client.id, buffer, { autotrigger = true })
        map('i', '<C-Space>',
          function()
            vim.lsp.completion.get()
          end,
          { desc = 'Trigger lsp completion' }
        )
      end

      if client:supports_method(vim.lsp.protocol.Methods.textDocument_hover) then
        map('n', 'K', function() vim.lsp.buf.hover { max_width = 100 } end)
      end

      if false and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlineCompletion) then
        vim.opt.completeopt = { 'menu', 'menuone', 'noinsert', 'fuzzy', 'popup' }
        vim.lsp.inline_completion.enable(true)
        map('i', '<Tab>',
          function()
            if not vim.lsp.inline_completion.get() then
              return '<Tab>'
            end
          end,
          { expr = true, replace_keycodes = true, desc = 'Apply the currently displayed completion suggestion' }
        )
        map('i', '<M-n>',
          function()
            vim.lsp.inline_completion.select({})
          end,
          { desc = 'Show next inline completion suggestion', }
        )
        map('i', '<M-p>',
          function()
            vim.lsp.inline_completion.select({ count = -1 })
          end,
          { desc = 'Show previous inline completion suggestion', }
        )
      end

      if client:supports_method(vim.lsp.protocol.Methods.textDocument_definition) then
        vim.bo[buffer].tagfunc = 'v:lua.vim.lsp.tagfunc'
      end

      if client:supports_method(vim.lsp.protocol.Methods.textDocument_codeAction) then
        vim.api.nvim_create_autocmd('BufWritePre', {
          pattern = { '*.ts', '*.tsx', '*.js', '*.jsx' },
          callback = function()
            local params = {
              command = '_typescript.organizeImports',
              arguments = { vim.api.nvim_buf_get_name(0) },
              title = '',
            }
            -- vim.lsp.buf.execute_command(params)
          end
        })
      end

      if client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
        map('n', '<leader>ih', function()
          vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled(), { bufnr = ev.buf })
        end, opts)
        vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
      end

      if client:supports_method(vim.lsp.protocol.Methods.textDocument_formatting) then
        map('n', '<space>f', vim.lsp.buf.format, opts)
        vim.api.nvim_create_autocmd('BufWritePre', {
          callback = function() vim.lsp.buf.format() end
        })
      end

      if client:supports_method(vim.lsp.protocol.Methods.textDocument_rangeFormatting) then
        map('v', '<space>f', vim.lsp.buf.format, opts)
      end

      if client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
        create_augroup('lsp_document_highlight', {
          { event = 'CursorHold',  buffer = buffer, callback = vim.lsp.buf.document_highlight },
          { event = 'CursorMoved', buffer = buffer, callback = vim.lsp.buf.clear_references },
        })
      end

      if client:supports_method(vim.lsp.protocol.Methods.textDocument_signatureHelp) then
        map('n', 'gs',
          vim.lsp.buf.signature_help,
          { desc = 'Trigger lsp signature help' }
        )
      end


      if client:supports_method(vim.lsp.protocol.Methods.textDocument_declaration) then
        map('n', 'gD', vim.lsp.buf.declaration)
      end

      if client:supports_method(vim.lsp.protocol.Methods.textDocument_definition) then
        map('n', 'gd', vim.lsp.buf.definition)
      end

      if client:supports_method(vim.lsp.protocol.Methods.textDocument_implementation) then
        map('n', 'gi', vim.lsp.buf.implementation)
      end

      if client:supports_method(vim.lsp.protocol.Methods.textDocument_typeDefinition) then
        map('n', 'gt', vim.lsp.buf.type_definition)
      end

      if client:supports_method(vim.lsp.protocol.Methods.textDocument_diagnostic) then
        map('n', '<leader>ee', vim.diagnostic.open_float)
      end

      if client:supports_method(vim.lsp.protocol.Methods.callHierarchy_incomingCalls) then
        map('n', '<leader>ai', vim.lsp.buf.incoming_calls)
      end

      if client:supports_method(vim.lsp.protocol.Methods.callHierarchy_outgoingCalls) then
        map('n', '<leader>ao', vim.lsp.buf.outgoing_calls)
      end
    end
  },
  {
    event = 'LspNotify',
    callback = function(args)
      if args.data.method == 'textDocument/didOpen' then
        vim.lsp.foldclose('imports', vim.fn.bufwinid(args.buf))
      end
    end
  }
})

return M
