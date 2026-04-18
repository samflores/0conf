return {
  {
    src = 'https://github.com/kevinhwang91/promise-async',
    name = 'promise-async',
    data = {
      dep_of = 'nvim-ufo',
    },
  },
  {
    src = 'https://github.com/luukvbaal/statuscol.nvim',
    name = 'statuscol.nvim',
    data = {
      event = 'VimEnter',
      after = function()
        local builtin = require('statuscol.builtin')
        require('statuscol').setup({
          relculright = true,
          segments = {
            { text = { builtin.foldfunc },      click = 'v:lua.ScFa' },
            { text = { '%s' },                  click = 'v:lua.ScSa' },
            { text = { builtin.lnumfunc, ' ' }, click = 'v:lua.ScLa' },
          },
        })
      end,
    },
  },
  {
    src = 'https://github.com/anuvyklack/keymap-amend.nvim',
    name = 'keymap-amend.nvim',
    data = {
      dep_of = 'fold-preview.nvim',
    },
  },
  {
    src = 'https://github.com/anuvyklack/fold-preview.nvim',
    name = 'fold-preview.nvim',
    data = {
      event = 'BufReadPost',
      after = function()
        require('fold-preview').setup()
      end,
    },
  },
  {
    src = 'https://github.com/kevinhwang91/nvim-ufo',
    name = 'nvim-ufo',
    data = {
      event = 'BufReadPost',
      before = function()
        vim.keymap.set('n', 'zR', function()
          require('ufo').openAllFolds()
        end)
        vim.keymap.set('n', 'zM', function()
          require('ufo').closeAllFolds()
        end)
      end,
      after = function()
        require('ufo').setup({
          provider_selector = function(bufnr, filetype, buftype)
            -- Languages with LSP support for comment/import folding
            local lsp_languages = {
              rust = true,
              ruby = true,
              typescript = true,
              typescriptreact = true,
              javascript = true,
              javascriptreact = true,
              python = true,
              lua = true,
              c = true,
              cpp = true,
            }

            if lsp_languages[filetype] then
              return { 'lsp', 'treesitter' }
            else
              return { 'treesitter', 'indent' }
            end
          end,

          close_fold_kinds_for_ft = {
            rust = { 'comment', 'imports' },
            ruby = { 'comment', 'imports' },
            typescript = { 'comment', 'imports' },
            typescriptreact = { 'comment', 'imports' },
            javascript = { 'comment', 'imports' },
            javascriptreact = { 'comment', 'imports' },
            python = { 'comment', 'imports' },
            lua = { 'comment', 'imports' },
            c = { 'comment', 'imports' },
            cpp = { 'comment', 'imports' },
            default = { 'imports' },
          },

          fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
            local newVirtText = {}
            local suffix = (' 󰁂 %d '):format(endLnum - lnum)
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
        })
      end,
    },
  },
}
