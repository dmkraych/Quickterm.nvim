local quickterm = {}

quickterm.state = {
  quick = {
    buf = -1,
    win = -1,
  },
}

-- function quickterm.setup(opts) end

local function create_quick_win(opts)
  opts = opts or {}
  local width = vim.o.columns
  local height = 10
  local col = vim.o.columns - 1
  local row = vim.o.lines - 1

  local buf = nil
  if vim.api.nvim_buf_is_valid(opts.buf) then
    buf = opts.buf
  else
    buf = vim.api.nvim_create_buf(false, true)
  end

  vim.api.nvim_win_set_cursor(0, { vim.api.nvim_buf_line_count(buf), 0 })

  local win_config = {
    relative = "editor",
    width = width,
    height = height,
    col = col,
    row = row,
    border = "rounded",
  }

  local win = vim.api.nvim_open_win(buf, true, win_config)

  return { buf = buf, win = win }
end

function quickterm.toggle_terminal()
  if not vim.api.nvim_win_is_valid(quickterm.state.quick.win) then
    quickterm.state.quick = create_quick_win({ buf = quickterm.state.quick.buf })
    if vim.bo[quickterm.state.quick.buf].buftype ~= "terminal" then
      vim.cmd.terminal()
    end
  else
    vim.api.nvim_win_hide(quickterm.state.quick.win)
  end
end

vim.api.nvim_create_user_command("Quickterm", quickterm.toggle_terminal, {})
vim.keymap.set("n", "<leader>st", quickterm.toggle_terminal)

return quickterm
