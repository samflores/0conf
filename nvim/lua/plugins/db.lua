return {
  {
    src = 'https://github.com/joryeugene/dadbod-grip.nvim',
    name = 'dadbod-grip.nvim',
    data = {
      cmd = {
        'Grip', 'GripConnect', 'GripTables', 'GripQuery',
        'GripSchema', 'GripHistory', 'GripStart',
      },
      keys = {
        { lhs = '<leader>Dc', rhs = '<cmd>GripConnect<cr>', desc = 'DB: pick/manage connections' },
        { lhs = '<leader>Ds', rhs = '<cmd>GripSchema<cr>',  desc = 'DB: browse schema (dbs/tables)' },
        { lhs = '<leader>Dt', rhs = '<cmd>GripToggle<cr>',  desc = 'DB: toggle the Grip UI' },
        { lhs = '<leader>DT', rhs = '<cmd>GripTables<cr>',  desc = 'DB: pick a table' },
        { lhs = '<leader>Dq', rhs = '<cmd>GripQuery<cr>',   desc = 'DB: open query pad' },
        { lhs = '<leader>Dg', rhs = '<cmd>Grip<cr>',        desc = 'DB: open editable grid' },
        { lhs = '<leader>Dh', rhs = '<cmd>GripHistory<cr>', desc = 'DB: query history' },
      },
      after = function()
        require('dadbod-grip').setup({
          picker = 'snacks',
          limit = 100,
          max_col_width = 40,
          timeout = 30000,
          border = 'rounded',
          keymaps = {
            qpad_execute     = '<S-CR>',
            qpad_execute_new = '<C-S-CR>',
          },
        })

        local set_col_hl = function()
          local c = vim.api.nvim_get_hl(0, { name = 'Comment', link = false })
          local col = c.bg or c.fg
          if col then vim.api.nvim_set_hl(0, 'GripColHighlight', { bg = col }) end
        end
        set_col_hl()
        vim.api.nvim_create_augroup('DadbodGripColHl', { clear = true })
        vim.api.nvim_create_autocmd('ColorScheme', {
          group = 'DadbodGripColHl', callback = set_col_hl,
        })
        local grip_buf = function() return vim.api.nvim_buf_get_name(0):match('^grip://') end
        vim.api.nvim_create_autocmd({ 'BufWinEnter', 'WinEnter' }, {
          group = 'DadbodGripColHl',
          callback = function(a) if grip_buf() then set_col_hl() end end,
        })
      end,
    },
  },
}
