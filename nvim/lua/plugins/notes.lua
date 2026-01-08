return {
  {
    src = 'https://github.com/zk-org/zk-nvim.git',
    data = {
      keys = {
        {
          lhs = '<leader>zn',
          rhs = function()
            require('zk.commands').get('ZkNew')({ title = vim.fn.input('Title: ') })
          end,
          desc = 'New Zk Note'
        },
        {
          lhs = '<leader>oz',
          rhs = function()
            require('zk.commands').get('ZkNotes')({ sort = { 'modified' } })
          end,
          desc = 'Open Zk Notes'
        },
        {
          lhs = '<leader>ozt',
          rhs = function()
            require('zk.commands').get('ZkTags')()
          end,
          desc = 'Zk Tags'
        },
        {
          lhs = '<leader>ozs',
          rhs = function()
            require('zk.commands').get('ZkNotes')({ sort = { 'modified' }, match = { vim.fn.input('Search: ') } })
          end,
          desc = 'Find in Zk Notes'
        },
        {
          lhs = '<leader>oz.',
          rhs = function()
            require('zk.commands').get('ZkMatch')()
          end,
          mode = 'v',
          desc = 'Find in Zk Notes (Visual)'
        },
        {
          lhs = '<leader>znj',
          rhs = function()
            require('zk').new {
              path = os.getenv('ZK_NOTEBOOK_DIR') .. '/journal/daily',
            }
          end,
          desc = 'New Zk Journal Note'
        },
        {
          lhs = '<leader>zi',
          rhs = function()
            require('zk.commands').get('ZkIndex')()
          end,
          desc = 'Index Zk Notes'
        },
      },
      after = function()
        require('zk').setup({
          picker = 'fzf_lua',

          lsp = {
            config = {
              name = 'zk',
              cmd = { 'zk', 'lsp' },
              filetypes = { 'markdown' },
            },

            auto_attach = {
              enabled = true,
            },
          },
        })
      end,
    }
  },
}
