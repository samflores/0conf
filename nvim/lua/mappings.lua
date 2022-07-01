local map = vim.api.nvim_set_keymap

local noremap_opt = { noremap = true }
local silent_noremap_opt = { silent = true, noremap = true }

-- Leader
vim.g.mapleader = ","
vim.g.maplocalleader = [[\]]

map('n', 'zG', '2zg', noremap_opt)

-- Kill window
map('n', '<leader>k', ':Bclose<cr>', noremap_opt)
map('n', '<leader>x', ':wq<cr>', noremap_opt)
map('n', '<leader>X', ':on<cr>', noremap_opt)

-- Sudo to write
map('c', 'w!!', 'w !doas tee % >/dev/null', noremap_opt)

-- Save files
map('n', '<leader>w', ':w<cr>', noremap_opt)
map('n', '<leader>W', ':wa<cr>', noremap_opt)

-- Exiting
map('n', '<leader><space>', ':wqa<cr>', noremap_opt)

-- Toggle line numbers
map('n', '<leader>n', ':setlocal number!<cr>', noremap_opt)
map('n', '<leader>N', ':setlocal relativenumber!<cr>', noremap_opt)

-- Sort lines
map('n', '<leader>s', 'vip:!sort<cr>', noremap_opt)
map('v', '<leader>s', ':!sort<cr>', noremap_opt)

-- Tabs
map('n', '<leader>(', ':tabprev<cr>', noremap_opt)
map('n', '<leader>)', ':tabnext<cr>', noremap_opt)

-- Wrap
map('n', '<leader>fw', ':set wrap!<cr>', noremap_opt)

-- Clear trailing whitespace
map('n', '<leader>ff', "mz:silent! %s/\\s\\+$//<cr>:let @/=''<cr>`zmz", noremap_opt)

-- Clear searches
map('n', '<leader>H', ':nohlsearch<cr>', noremap_opt)

-- 'Uppercase word' mapping.
map('i', '<C-u>', '<esc>mzgUiw`za', noremap_opt)

-- Panic Button
map('n', '<f9>', 'mzggg?G`z', noremap_opt)

-- Formatting, TextMate-style
map('n', 'Q', 'gqip', noremap_opt)
map('v', 'Q', 'gq', noremap_opt)

-- Reformat line.
map('n', 'ql', 'gqq', noremap_opt)

-- Keep the cursor in place while joining lines
map('n', 'J', 'mzJ`z', noremap_opt)

-- Join an entire paragraph.
map('n', '<leader>J', 'mzvipJ`z', noremap_opt)

-- Split line (sister to [J]oin lines)
map('n', 'S', [[i<cr><esc>^mwgk:silent! s/\v +$//<cr>:noh<cr>`w]], noremap_opt)

-- Select (charwise) the contents of the current line, excluding indentation.
map('n', 'vv', '^vg_', noremap_opt)

-- Toggle [i]nvisible characters
map('n', '<leader>i', ':set list!<cr>', noremap_opt)

-- Toggle spell
map('n', '<leader>z', ':set spell!<cr>', noremap_opt)

-- [U]nfuck my screen
map('n', 'U', ':syntax sync fromstart<cr>:redraw!<cr>', noremap_opt)

-- Quick editing
map('n', '<leader>qvv', ':vsplit $MYVIMRC|set bufhidden=wipe<cr>', noremap_opt)
map('n', '<leader>qvd', ':vsplit $XDG_CONFIG_HOME/nvim/custom-dictionary.utf-8.add|set bufhidden=wipe<cr>', noremap_opt)
map('n', '<leader>qvb', ':vsplit $XDG_CONFIG_HOME/nvim/lua/bundle.lua|set bufhidden=wipe<cr>', noremap_opt)
map('n', '<leader>qvm', ':vsplit $XDG_CONFIG_HOME/nvim/lua/mappings.lua|set bufhidden=wipe<cr>', noremap_opt)
map('n', '<leader>qvl', ':vsplit $XDG_CONFIG_HOME/nvim/lua/lsp.lua|set bufhidden=wipe<cr>', noremap_opt)
map('n', '<leader>qvs', ':vsplit $XDG_CONFIG_HOME/nvim/lua/settings.lua|set bufhidden=wipe<cr>', noremap_opt)
map('n', '<leader>qva', ':vsplit $XDG_CONFIG_HOME/nvim/lua/autocmds.lua|set bufhidden=wipe<cr>', noremap_opt)

-- Keep search matches in the middle of the window.
map('n', 'n', 'nzzzv', noremap_opt)
map('n', 'N', 'Nzzzv', noremap_opt)

-- Same when jumping around
map('n', 'g;', 'g;zz', noremap_opt)
map('n', 'g,', 'g,zz', noremap_opt)
map('n', '<c-o>', '<c-o>zz', noremap_opt)

-- Easier to type, and I never use the default behavior.
map('',  'H', '^', noremap_opt)
map('',  'L', '$', noremap_opt)
map('v', 'L', 'g_', noremap_opt)

-- Move around
map('', '<silent>j', 'gj', noremap_opt)
map('', '<silent>k', 'gk', noremap_opt)
map('', '<silent>gj', 'j', noremap_opt)
map('', '<silent>gk', 'k', noremap_opt)

-- Easy buffer navigation
map('', '<C-h>', '<C-w>h', noremap_opt)
map('', '<C-j>', '<C-w>j', noremap_opt)
map('', '<C-k>', '<C-w>k', noremap_opt)
map('', '<C-l>', '<C-w>l', noremap_opt)

map('n', '<leader>bo', ':%bdelete|edit #|bdelete #<cr>|\'"', noremap_opt)

-- List navigation
map('n', '<left>', ' :cprev<cr>zvzz', noremap_opt)
map('n', '<right>', ':cnext<cr>zvzz', noremap_opt)
map('n', '<up>', '   :lprev<cr>zvzz', noremap_opt)
map('n', '<down>', ' :lnext<cr>zvzz', noremap_opt)

-- Expand to current path on command mode
map('c', '%%', "<c-r>=expand('%:h').'/'<CR>", noremap_opt)

-- Yeah, I'm that lazy
map('n', ';', ':', noremap_opt)
map('n', ':', ';', noremap_opt)
map('v', ';', ':', noremap_opt)
map('v', ':', ';', noremap_opt)

-- I prefer block selection
map('n', 'v', '<C-V>', noremap_opt)
map('n', '<C-V>', 'v', noremap_opt)
map('v', 'v', '<C-V>', noremap_opt)
map('v', '<C-V>', 'v', noremap_opt)

-- Easier to type
map('n', '<Leader><Leader>', '<c-^>', noremap_opt)

-- Most of the time I want to ignore the indentation
map('n', '0', '^', noremap_opt)
map('n', '<Leader>0', '0', noremap_opt)

-- Leave insert mode on Terminals easily
map('t', '<Esc>', [[<C-\><C-n>]], noremap_opt)

-- Rust-tools
map("n", "<leader>rr", ":RustRunnables<CR>", silent_noremap_opt)

-- Snippets
vim.api.nvim_exec([[
  imap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
  smap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
  imap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
  smap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
]], false)
