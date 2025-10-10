return {
  'mistweaverco/kulala.nvim',
  keys = {
    { '<leader>Rs', function() require('kulala').run() end, desc = 'Send request', },
    { '<leader>Ra', desc = 'Send all requests' },
    { '<leader>Rb', desc = 'Open scratchpad' },
  },
  ft = { 'http', 'rest' },
  opts = {
    lsp = {
      enable = false,
    }
  },
}
