return {
  {
    src = 'https://github.com/stevearc/conform.nvim',
    name = 'conform.nvim',
    data = {
      event = 'VimEnter',
      keys = {
        {
          lhs = '<leader>f',
          rhs = function()
            require('conform').format({ async = true, lsp_fallback = true })
          end,
          mode = '',
          desc = '[F]ormat buffer',
        },
      },
      after = function()
        require('conform').setup({
          notify_on_error = false,
          format_on_save = function(bufnr)
            local filetype = vim.bo[bufnr].filetype
            local bufname = vim.api.nvim_buf_get_name(bufnr)

            local pattern = vim.glob.to_lpeg('docker-compose*.y*ml')
            if pattern:match(bufname) then
              return nil
            end

            pattern = vim.glob.to_lpeg('**/*.json.erb')
            if pattern:match(bufname) then
              return nil
            end

            pattern = vim.glob.to_lpeg('**/config/**/*.y*ml')
            if pattern:match(bufname) then
              return nil
            end

            if filetype == 'eruby.yaml' then
              return nil
            end

            -- Disable "format_on_save lsp_fallback" for languages that don't
            -- have a well standardized coding style. You can add additional
            -- languages here or re-enable it for the disabled ones.
            local disable_filetypes = { c = true, cpp = true, yaml = true }
            return {
              timeout_ms = 500,
              lsp_format = 'fallback',
              lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
            }
          end,
          formatters_by_ft = {
            sql = { 'sqlfmt' },
            python = { 'ruff' },
            eruby = { 'erb_format' },
          },
          formatters = {
            sqlfmt = { command = 'sqlfmt' },
            erb_format = { command = 'erb-format' },
          }
        })
      end
    },
  }
}
