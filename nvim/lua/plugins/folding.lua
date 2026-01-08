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
          provider_selector = function()
            return { 'treesitter', 'indent' }
          end,

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
