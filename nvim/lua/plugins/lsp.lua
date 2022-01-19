local packagename = 'glepnir/lspsaga.nvim'
local dependencies = {
  'neovim/nvim-lspconfig',
  'nvim-lua/lsp-status.nvim',
  'williamboman/nvim-lsp-installer',
  'simrat39/rust-tools.nvim',
}

local config = function()
  local lsp_status = require('lsp-status')
  lsp_status.register_progress()

  local on_attach = function(client, bufnr)
    local function map(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function opt(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    opt('omnifunc', 'v:lua.vim.lsp.omnifunc')

    lsp_status.on_attach(client)

    -- Mappings.
    local opts = { noremap=true, silent=true }
    map('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    -- map('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
    map('n', 'gd', "<cmd>lua require'lspsaga.provider'.preview_definition()<CR>", opts)
    map('n', 'gh', "<cmd>lua require'lspsaga.provider'.lsp_finder()<CR>", opts)
    map('n', 'gs', "<cmd>lua require('lspsaga.signaturehelp').signature_help()<CR>", opts)
    -- map('n', 'M', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
    map('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    -- map('n', '<C-s>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    map('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    map('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    map('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
    map('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    -- map('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    map('n', '<space>rn', "<cmd>lua require('lspsaga.rename').rename()<CR>", opts)
    map('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    map('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
    --[[ map('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
    map('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts) ]]
    map('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
    -- map('n', '<space>ac', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    map('n', '<space>ca', "<cmd>lua require('lspsaga.codeaction').code_action()<CR>", opts)
    map('v', '<space>ca', "<cmd>'<,'>lua require('lspsaga.codeaction').range_code_action()<CR>", opts)
    map('n', 'M', "<cmd>lua require('lspsaga.hover').render_hover_doc()<CR>", opts)
    map('n', '<C-f>', "<cmd>lua require('lspsaga.hover').smart_scroll_hover(1)<CR>", opts)
    map('n', '<C-b>', "<cmd>lua require('lspsaga.hover').smart_scroll_hover(-1)<CR>", opts)

    map('n', '<space>dd', "<cmd>lua require'lspsaga.diagnostic'.show_line_diagnostics()<CR>", opts)
    map('n', '[d', "<cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_prev()<CR>", opts)
    map('n', ']d', "<cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_next()<CR>", opts)

    -- Set some keybinds conditional on server capabilities
    if client.resolved_capabilities.document_formatting then
      map("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
      vim.api.nvim_exec([[
      augroup lsp_document_formatting
      autocmd! * <buffer>
      autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()
      augroup END
        ]], false)
    elseif client.resolved_capabilities.document_range_formatting then
      map("n", "<space>f", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
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

  -- Configure lua language server for neovim development
  local lua_settings = {
    Lua = {
      runtime = {
        -- LuaJIT in the case of Neovim
        version = 'LuaJIT',
        path = vim.split(package.path, ';'),
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {'vim'},
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = {
          [vim.fn.expand('$VIMRUNTIME/lua')] = true,
          [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
        },
      },
    }
  }

  -- config that activates keymaps and enables snippet support
  local function make_config()
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    return {
      -- enable snippet support
      capabilities = capabilities,
      -- map buffer local keybindings when the language server attaches
      on_attach = on_attach,
    }
  end

  local lsp_installer = require("nvim-lsp-installer")

  lsp_installer.on_server_ready(function(server)
    local opts = make_config()

    if server.name == "sumneko_lua" then
      opts.config = lua_settings
    elseif server.name == "rust_analyzer" then
      require("rust-tools").setup {
        server = vim.tbl_deep_extend("force", server:get_default_options(), opts),
      }
      -- server:attach_buffers()
      return
    end

    -- This setup() function is exactly the same as lspconfig's setup function (:help lspconfig-quickstart)
    server:setup(opts)
    vim.cmd [[ do User LspAttachBuffers ]]
  end)

  -- require("diaglist").init()
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
