local themes = require("themes")

local M = {}

M.state = {
  quick = {
    buf = -1,
    win = -1,
  },
}

local default = themes.floating()
local options = {}

function M.setup(opts)
  local theme = {}
  if opts.theme then
    if opts.theme == "floating" then
      theme = themes.floating()
    elseif opts.theme == "bottom" then
      theme = themes.bottom()
    elseif opts.theme == "top" then
      theme = themes.top()
    end
  else
    theme = default
  end

  options = vim.tbl_deep_extend("force", theme, opts or {})
  options.theme = nil
  for k, v in pairs(options) do
    print(k .. v)
  end
end

--- TODO: Add redraw functionality so terminal dynamically resizes
local function create_quick_win(opts)
  opts = opts or {}

  local buf = nil
  if vim.api.nvim_buf_is_valid(opts.buf) then
    buf = opts.buf
  else
    buf = vim.api.nvim_create_buf(false, true)
  end

  local win = vim.api.nvim_open_win(buf, true, options)

  return { buf = buf, win = win }
end

function M.toggle_terminal()
  if not vim.api.nvim_win_is_valid(M.state.quick.win) then
    M.state.quick = create_quick_win({ buf = M.state.quick.buf })
    if vim.bo[M.state.quick.buf].buftype ~= "terminal" then
      vim.cmd.terminal()
    end
    vim.api.nvim_win_set_cursor(M.state.quick.win, { vim.api.nvim_buf_line_count(M.state.quick.buf), 0 })
  else
    vim.api.nvim_win_hide(M.state.quick.win)
  end
end

vim.api.nvim_create_user_command("Quickterm", M.toggle_terminal, {})
vim.keymap.set("n", "<leader>st", M.toggle_terminal, { desc = "[S]how [T]erminal" })

return M
