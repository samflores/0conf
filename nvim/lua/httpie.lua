local M = {}

-- Function to get selected text
local function get_visual_selection()
  local _, start_row, start_col, _ = unpack(vim.fn.getpos("'<"))
  local _, end_row, end_col, _ = unpack(vim.fn.getpos("'>"))

  local lines = vim.api.nvim_buf_get_lines(0, start_row - 1, end_row, false)

  if #lines == 0 then
    return ''
  end

  lines[1] = string.sub(lines[1], start_col)
  lines[#lines] = string.sub(lines[#lines], 1, end_col)

  return table.concat(lines, '\n')
end

-- Function to send request using httpie
local function send_http_request()
  local selection = get_visual_selection()
  if selection == '' then
    print('No selection made.')
    return
  end

  local lines = {}
  for line in selection:gmatch('[^\n]+') do
    table.insert(lines, line)
  end

  if #lines == 0 then
    print('Invalid selection.')
    return
  end

  local url = lines[1]
  table.remove(lines, 1)

  local args = ''
  for _, line in ipairs(lines) do
    args = args .. ' ' .. vim.fn.shellescape(line)
  end

  local cmd = 'http --ignore-stdin ' .. vim.fn.shellescape(url) .. args

  -- Open or reuse horizontal split for output
  local output_buf = vim.api.nvim_create_buf(false, true)
  local existing_win = nil
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.api.nvim_buf_get_name(buf) == '[httpie-output]' then
      existing_win = win
      output_buf = buf
      break
    end
  end

  if not existing_win then
    vim.cmd('split')
    existing_win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(existing_win, output_buf)
    vim.api.nvim_buf_set_name(output_buf, '[httpie-output]')
  end

  vim.api.nvim_buf_set_lines(output_buf, 0, -1, false, { 'Running: ' .. cmd })

  vim.fn.jobstart(cmd, {
    stdout_buffered = true,
    on_stdout = function(_, data)
      if data then
        vim.api.nvim_buf_set_lines(output_buf, -1, -1, false, data)
      end
    end,
    on_stderr = function(_, data)
      if data then
        vim.api.nvim_buf_set_lines(output_buf, -1, -1, false, data)
      end
    end,
    on_stdin = function(_, data)
      if data then
        vim.api.nvim_buf_set_lines(output_buf, -1, -1, false, data)
      end
    end,
  })
end

-- Setup command
function M.setup()
  vim.api.nvim_set_keymap('v', '<leader>r', ':lua require("httpie").request()<CR>',
    { noremap = true, silent = true })
end

-- Expose function
M.request = send_http_request

return M
