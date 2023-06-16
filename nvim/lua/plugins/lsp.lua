local config = function()
  require("mason").setup()
  require("mason-lspconfig").setup()
  require("lspsaga").setup({
    ui = {
      border = "rounded"
    },
    rename = {
      in_select = false,
    },
  })
  require("trouble").setup()
  require("fidget").setup({
    text = {
      spinner = "dots_snake"
    },
    window = {
      blend = 0
    }
  })
  local rt = require("rust-tools")

  local on_attach = function(client, bufnr)
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    local keymap = vim.keymap.set
    local opts = { noremap = true, silent = true, buffer = bufnr }
    keymap("n", "gh", "<cmd>Lspsaga lsp_finder<CR>")
    keymap({ "n", "v" }, "<leader>ca", "<cmd>Lspsaga code_action<CR>")
    keymap("n", "gr", "<cmd>Lspsaga rename<CR>")
    keymap("n", "gd", "<cmd>Lspsaga peek_definition<CR>")
    keymap("n", "gD", "<cmd>Lspsaga goto_definition<CR>")
    keymap("n", "<leader>sl", "<cmd>Lspsaga show_line_diagnostics<CR>")
    keymap("n", "<leader>sc", "<cmd>Lspsaga show_cursor_diagnostics<CR>")
    keymap("n", "<leader>sb", "<cmd>Lspsaga show_buf_diagnostics<CR>")
    keymap("n", "[e", "<cmd>Lspsaga diagnostic_jump_prev<CR>")
    keymap("n", "]e", "<cmd>Lspsaga diagnostic_jump_next<CR>")
    keymap("n", "[E", function()
      require("lspsaga.diagnostic").goto_prev({ severity = vim.diagnostic.severity.ERROR })
    end)
    keymap("n", "]E", function()
      require("lspsaga.diagnostic").goto_next({ severity = vim.diagnostic.severity.ERROR })
    end)
    keymap("n", "<leader>O", "<cmd>Lspsaga outline<CR>")
    keymap("n", "K", "<cmd>Lspsaga hover_doc<CR>")
    keymap("n", "<Leader>ci", "<cmd>Lspsaga incoming_calls<CR>")
    keymap("n", "<Leader>co", "<cmd>Lspsaga outgoing_calls<CR>")
    keymap({ "n", "t" }, "<A-d>", "<cmd>Lspsaga term_toggle<CR>")

    -- print(vim.inspect(client.server_capabilities));
    if client.server_capabilities.documentFormattingProvider then
      keymap("n", "<space>f", vim.lsp.buf.format, opts)
      vim.api.nvim_exec([[
        augroup lsp_document_formatting
        autocmd! * <buffer>
        autocmd BufWritePre <buffer> lua vim.lsp.buf.format()
        augroup END
      ]], false)
    end

    if client.server_capabilities.documentRangeFormattingProvider then
      -- keymap("n", "<space>f", vim.lsp.buf.range_formatting, opts)
    end

    if client.server_capabilities.documentHighlightProvider then
      -- vim.api.nvim_exec([[
      --   augroup lsp_document_highlight
      --   autocmd! * <buffer>
      --   autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
      --   autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      --   augroup END
      -- ]], false)
    end
  end

  rt.setup {
    tools = {
      inlay_hints = {
        auto = false
      }
    },
    server = { on_attach = on_attach }
  }

  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true
  }
  local lsp_config = require('lspconfig')
  lsp_config['bashls'].setup { on_attach = on_attach, capabilities = capabilities }
  lsp_config['clangd'].setup { on_attach = on_attach, capabilities = capabilities }
  lsp_config['clojure_lsp'].setup { on_attach = on_attach, capabilities = capabilities }
  lsp_config['cssls'].setup { on_attach = on_attach, capabilities = capabilities }
  -- lsp_config['dartls'].setup { on_attach = on_attach, capabilities = capabilities }
  lsp_config['denols'].setup {
    on_attach = on_attach,
    capabilities = capabilities,
    root_dir = lsp_config.util.root_pattern("deno.json", "deno.jsonc"),
  }
  -- lsp_config['ember'].setup { on_attach = on_attach, capabilities = capabilities }
  lsp_config['emmet_ls'].setup { on_attach = on_attach, capabilities = capabilities }
  lsp_config['graphql'].setup { on_attach = on_attach, capabilities = capabilities }
  lsp_config['html'].setup { on_attach = on_attach, capabilities = capabilities }
  lsp_config['jsonls'].setup { on_attach = on_attach, capabilities = capabilities }
  lsp_config['jdtls'].setup { on_attach = on_attach, capabilities = capabilities }
  -- lsp_config['rust_analyzer'].setup { on_attach = on_attach, capabilities = capabilities }

  -- lsp_config['sorbet'].setup { on_attach = on_attach, capabilities = capabilities }
  -- lsp_config['solargraph'].setup { on_attach = on_attach, capabilities = capabilities }
  -- lsp_config['typeprof'].setup { on_attach = on_attach, capabilities = capabilities }
  lsp_config['steep'].setup { on_attach = on_attach, capabilities = capabilities }
  -- lsp_config['ruby_ls'].setup { on_attach = on_attach, capabilities = capabilities }

  lsp_config['sqlls'].setup { on_attach = on_attach, capabilities = capabilities }
  lsp_config['lua_ls'].setup {
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
      Lua = {
        runtime = {
          version = 'LuaJIT',
          path = vim.split(package.path, ';'),
        },
        diagnostics = {
          globals = { 'vim' },
        },
        workspace = {
          library = {
            [vim.fn.expand('$VIMRUNTIME/lua')] = true,
            [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
          },
        },
      }
    }
  }
  lsp_config['svelte'].setup { on_attach = on_attach, capabilities = capabilities }
  lsp_config['tsserver'].setup {
    on_attach = on_attach,
    capabilities = capabilities,
    root_dir = lsp_config.util.root_pattern("package.json"),
  }

  local handler = function(virtText, lnum, endLnum, width, truncate)
    local newVirtText = {}
    local suffix = ('  %d '):format(endLnum - lnum)
    local sufWidth = vim.fn.strdisplaywidth(suffix)
    local targetWidth = width - sufWidth
    local curWidth = 0
    for _, chunk in ipairs(virtText) do
      local chunkText = chunk[1]
      local chunkWidth = vim.fn.strdisplaywidth(chunkText)
      if targetWidth > curWidth + chunkWidth then
        table.insert(newVirtText, chunk)
      else
        chunkText = truncate(chunkText, targetWidth - curWidth)
        local hlGroup = chunk[2]
        table.insert(newVirtText, { chunkText, hlGroup })
        chunkWidth = vim.fn.strdisplaywidth(chunkText)
        -- str width returned from truncate() may less than 2nd argument, need padding
        if curWidth + chunkWidth < targetWidth then
          suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
        end
        break
      end
      curWidth = curWidth + chunkWidth
    end
    table.insert(newVirtText, { suffix, 'MoreMsg' })
    return newVirtText
  end
  require('ufo').setup({ fold_virt_text_handler = handler })
end

return {
  'neovim/nvim-lspconfig',
  dependencies = {
    'glepnir/lspsaga.nvim',
    { dir = '~/Code/mason.nvim' },
    { dir = '~/Code/mason-lspconfig.nvim' },
    'mattfbacon/rust-tools.nvim',
    'folke/trouble.nvim',
    'j-hui/fidget.nvim',
    'kevinhwang91/nvim-ufo',
    'kevinhwang91/promise-async'
  },
  config = config,
  event = 'UiEnter',
}
