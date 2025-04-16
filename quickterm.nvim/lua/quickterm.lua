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

local function configure_theme(choice)
  local theme = {}
  if choice == "floating" then
    theme = themes.floating()
  elseif choice == "bottom" then
    theme = themes.bottom()
  elseif choice == "top" then
    theme = themes.top()
  end

  return theme
end

local function user_keymap(choice)
  if choice == false then
    return
  elseif type(choice) == "string" then
    vim.keymap.set("n", choice, M.toggle_terminal)
  else
    vim.keymap.set("n", "<leader>st", M.toggle_terminal, { desc = "[S]how [T]erminal" })
  end
end

function M.setup(config, opts)
  local theme = {}

  if config.theme then
    theme = configure_theme(config.theme)
  else
    theme = default
  end

  options = vim.tbl_deep_extend("force", theme, opts or {})
  -- TODO: Error handling for bad strings (overloaded, typos, etc.)
  if pcall(user_keymap, config.mapping) then
    print("User-specified keymap initiated.")
  else
    print("No keymap specified by user.")
  end
end

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

vim.api.nvim_create_autocmd("VimResized", {
  group = vim.api.nvim_create_augroup("term-resized", {}),
  callback = function()
    if not vim.api.nvim_win_is_valid(M.state.quick.win) then
      return
    end

    local updated = configure_theme(options)
    vim.api.nvim_win_set_config(M.state.quick.win, updated)
  end,
})

vim.api.nvim_create_user_command("Quickterm", M.toggle_terminal, {})
-- vim.keymap.set("n", "<leader>st", M.toggle_terminal, { desc = "[S]how [T]erminal" })

return M
