local packagename = 'neovim/nvim-lspconfig'
local dependencies = {
  'glepnir/lspsaga.nvim',
  'williamboman/nvim-lsp-installer',
  'simrat39/rust-tools.nvim',
  'folke/trouble.nvim'
}

local config = function()
  require("nvim-lsp-installer").setup({ automatic_installation = true })
  require("lspsaga").init_lsp_saga({
    border_style = "bold"
  })
  require("rust-tools").setup {}
  require("trouble").setup {}

  local on_attach = function(client, bufnr)
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    local map = vim.keymap.set
    local opts = { noremap = true, silent = true, buffer = bufnr }

    map('n', 'gD', vim.lsp.buf.declaration, opts)
    -- map('n', 'gd', vim.lsp.buf.definition, opts)
    -- map('n', 'M', vim.lsp.buf.hover, opts)
    map('n', 'gi', vim.lsp.buf.implementation, opts)
    -- map('n', '<C-s>', vim.lsp.buf.signature_help, opts)
    map('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    map('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    map('n', '<space>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, opts)
    map('n', '<space>D', vim.lsp.buf.type_definition, opts)
    -- map('n', '<space>rn', vim.lsp.buf.rename, opts)
    map('n', 'gr', vim.lsp.buf.references, opts)
    -- map('n', '<space>e', vim.lsp.diagnostic.show_line_diagnostics, opts)
    -- map('n', '[d', vim.lsp.diagnostic.goto_prev, opts)
    -- map('n', ']d', vim.lsp.diagnostic.goto_next, opts)
    map('n', '<space>q', vim.lsp.diagnostic.set_loclist, opts)
    -- map('n', '<space>ca', vim.lsp.buf.code_action, opts)

    map('n', 'gd', require 'lspsaga.definition'.preview_definition, opts)
    map('n', 'gh', require 'lspsaga.finder'.lsp_finder, opts)
    map('n', 'gs', require('lspsaga.signaturehelp').signature_help, opts)
    map('n', '<space>rn', require('lspsaga.rename').lsp_rename, opts)
    map('n', '<space>ca', require('lspsaga.codeaction').code_action, opts)
    map('v', '<space>ca', function()
      vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<C-U>", true, false, true))
      require('lspsaga.codeaction').range_code_action()
    end, opts)
    map('n', 'M', require('lspsaga.hover').render_hover_doc, opts)
    local action = require("lspsaga.action")
    map('n', '<C-f>', function() action.smart_scroll_with_saga(1) end, opts)
    map('n', '<C-b>', function() action.smart_scroll_with_saga(-1) end, opts)
    map('n', '<space>dd', require 'lspsaga.diagnostic'.show_line_diagnostics, opts)
    map('n', '[d', require 'lspsaga.diagnostic'.goto_prev, opts)
    map('n', ']d', require 'lspsaga.diagnostic'.goto_next, opts)

    if client.resolved_capabilities.document_formatting then
      map("n", "<space>f", vim.lsp.buf.formatting, opts)
      vim.api.nvim_exec([[
        augroup lsp_document_formatting
        autocmd! * <buffer>
        autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync(nil, 1000)
        augroup END
      ]], false)
    end

    if client.resolved_capabilities.document_range_formatting then
      map("n", "<space>f", vim.lsp.buf.range_formatting, opts)
    end

    -- Set autocommands conditional on server_capabilities
    if client.resolved_capabilities.document_highlight then
      vim.api.nvim_exec([[
        augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
        augroup END
      ]], false)
    end
  end

  local lsp_config = require('lspconfig')
  lsp_config['clangd'].setup { on_attach = on_attach }
  lsp_config['clojure_lsp'].setup { on_attach = on_attach }
  lsp_config['cssls'].setup { on_attach = on_attach }
  lsp_config['dartls'].setup { on_attach = on_attach }
  lsp_config['denols'].setup {
    on_attach = on_attach,
    root_dir = lsp_config.util.root_pattern("deno.json", "deno.jsonc"),
  }
  -- lsp_config['ember'].setup { on_attach = on_attach }
  lsp_config['emmet_ls'].setup { on_attach = on_attach }
  lsp_config['graphql'].setup { on_attach = on_attach }
  lsp_config['html'].setup { on_attach = on_attach }
  lsp_config['jsonls'].setup { on_attach = on_attach }
  lsp_config['solargraph'].setup { on_attach = on_attach }
  lsp_config['sqlls'].setup { on_attach = on_attach }
  lsp_config['sumneko_lua'].setup {
    on_attach = on_attach,
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
  lsp_config['svelte'].setup { on_attach = on_attach }
  lsp_config['tsserver'].setup {
    on_attach = on_attach,
    root_dir = lsp_config.util.root_pattern("package.json"),
  }
end

local M = {}

function M.init(use)
  use {
    packagename,
    requires = dependencies,
    config = config,
  }
end

return M
