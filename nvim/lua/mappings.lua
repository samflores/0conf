local map = vim.api.nvim_set_keymap

local noremap_opt = { noremap = true }
local silent_noremap_opt = { silent = true, noremap = true }

map('n', 'zG', '2zg', silent_noremap_opt)

-- Kill window
map('n', '<leader>q', ':wq<cr>', silent_noremap_opt)
map('n', '<leader>X', ':on<cr>', silent_noremap_opt)

-- Sudo to write
map('c', 'W!!', 'w !doas tee % >/dev/null', silent_noremap_opt)

-- Save files
map('n', '<leader>w', ':w<cr>', silent_noremap_opt)
map('n', '<leader>W', ':wa<cr>', silent_noremap_opt)

-- Exiting
map('n', '<leader><space>', ':wqa<cr>', silent_noremap_opt)

-- Toggle line numbers
map('n', '<leader>n', ':setlocal number!<cr>', silent_noremap_opt)
map('n', '<leader>N', ':setlocal relativenumber!<cr>', silent_noremap_opt)

-- Sort lines
map('n', '<leader>s', 'vip:!sort<cr>', silent_noremap_opt)
map('v', '<leader>s', ':!sort<cr>', silent_noremap_opt)

map('v', '<leader>y', 'J:s/\\ \\././<cr>$^vg_yu:noh<cr>', silent_noremap_opt)

-- Tabs
map('n', '<leader>(', ':tabprev<cr>', silent_noremap_opt)
map('n', '<leader>)', ':tabnext<cr>', silent_noremap_opt)

-- Wrap
map('n', '<leader>fw', ':set wrap!<cr>', silent_noremap_opt)

-- Clear trailing whitespace
map('n', '<leader>ff', "mz:silent! %s/\\s\\+$//<cr>:let @/=''<cr>`zmz", silent_noremap_opt)

-- Clear searches
map('n', '<leader>H', ':nohlsearch<cr>', silent_noremap_opt)

-- 'Uppercase word' mapping.
map('i', '<C-u>', '<esc>mzgUiw`za', silent_noremap_opt)

-- Panic Button
map('n', '<f9>', 'mzggg?G`z', silent_noremap_opt)

-- Formatting, TextMate-style
map('n', 'Q', 'gqip', silent_noremap_opt)
map('v', 'Q', 'gq', silent_noremap_opt)

-- Reformat line.
map('n', 'ql', 'gqq', silent_noremap_opt)

-- Keep the cursor in place while joining lines
map('n', 'J', 'mzJ`z', silent_noremap_opt)

-- Join an entire paragraph.
map('n', '<leader>J', 'mzvipJ`z', silent_noremap_opt)

-- Split line (sister to [J]oin lines)
map('n', '<leader>S', [[i<cr><esc>^mwgk:silent! s/\v +$//<cr>:noh<cr>`w]], silent_noremap_opt)

-- Select (charwise) the contents of the current line, excluding indentation.
map('n', 'vv', '^vg_', silent_noremap_opt)

-- Toggle [i]nvisible characters
map('n', '<leader>i', ':set list!<cr>', silent_noremap_opt)

-- Toggle spell
map('n', '<leader>Z', ':set spell!<cr>', silent_noremap_opt)

-- [U]nfuck my screen
map('n', 'U', ':syntax sync fromstart<cr>:redraw!<cr>', silent_noremap_opt)

-- Keep search matches in the middle of the window.
map('n', 'n', 'nzzzv', silent_noremap_opt)
map('n', 'N', 'Nzzzv', silent_noremap_opt)

-- Same when jumping around
map('n', 'g;', 'g;zz', silent_noremap_opt)
map('n', 'g,', 'g,zz', silent_noremap_opt)
map('n', '<c-o>', '<c-o>zz', silent_noremap_opt)

-- Easier to type, and I never use the default behavior.
map('', 'H', '^', silent_noremap_opt)
map('', 'L', '$', silent_noremap_opt)
map('v', 'L', 'g_', silent_noremap_opt)

-- Move around
map('', '<silent>j', 'gj', silent_noremap_opt)
map('', '<silent>k', 'gk', silent_noremap_opt)
map('', '<silent>gj', 'j', silent_noremap_opt)
map('', '<silent>gk', 'k', silent_noremap_opt)

-- Easy buffer navigation
map('', '<C-h>', '<C-w>h', silent_noremap_opt)
map('', '<C-j>', '<C-w>j', silent_noremap_opt)
map('', '<C-k>', '<C-w>k', silent_noremap_opt)
map('', '<C-l>', '<C-w>l', silent_noremap_opt)

map('n', '<leader>bo', ':%bdelete|edit #|bdelete #<cr>|\'"', silent_noremap_opt)

-- List navigation
map('n', '<left>', ' :cprev<cr>zvzz', silent_noremap_opt)
map('n', '<right>', ':cnext<cr>zvzz', silent_noremap_opt)
map('n', '<up>', '   :lprev<cr>zvzz', silent_noremap_opt)
map('n', '<down>', ' :lnext<cr>zvzz', silent_noremap_opt)

-- Expand to current path on command mode
map('c', '%%', "<c-r>=expand('%:h').'/'<CR>", silent_noremap_opt)

-- Yeah, I'm that lazy
map('n', ';', ':', noremap_opt)
map('n', ':', ';', noremap_opt)
map('v', ';', ':', noremap_opt)
map('v', ':', ';', noremap_opt)

-- I prefer block selection
map('n', 'v', '<C-V>', silent_noremap_opt)
map('n', '<C-V>', 'v', silent_noremap_opt)
map('v', 'v', '<C-V>', silent_noremap_opt)
map('v', '<C-V>', 'v', silent_noremap_opt)

-- Easier to type
map('n', '<Leader><Leader>', '<c-^>', silent_noremap_opt)

-- Most of the time I want to ignore the indentation
map('n', '0', '^', silent_noremap_opt)
map('n', '<Leader>0', '0', silent_noremap_opt)

-- Leave insert mode on Terminals easily
map('t', '<Esc>', [[<C-\><C-n>]], silent_noremap_opt)


-- RestartLsp
map('n', '<leader>ll', ':LspRestart<cr>', silent_noremap_opt)
map('n', '<leader>li', ':LspInfo<cr>', silent_noremap_opt)
