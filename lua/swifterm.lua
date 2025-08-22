local themes = require("themes")

local M = {}

M.state = {
  swift = {
    buf = -1,
    win = -1,
  },
}

local default = themes.floating()
local options = {}

local function configure_theme(choice)
  -- set the theme if user-defined
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

local function default_keymap(choice)
  choice = choice or nil
  if vim.fn.maparg("<leader>st") ~= "" and choice.remap ~= true then
    local msg = string.format(
      "Default keymap (<leader>st) already mapped to %s, no keymap set. To override this behavior, set opts.mapping.remap = true.",
      vim.fn.maparg("<leader>st")
    )
    vim.notify(msg)
  else
    vim.keymap.set("n", "<leader>st", M.toggle_terminal, { desc = "[S]how [T]erminal" })
  end
end

local function user_keymap(choice)
  local keymap = choice.keymap or nil
  local remap = choice.remap or false
  assert((type(keymap) == "string" or keymap == nil), "User-defined keymap must be a string.")
  -- if remap set but no keymap, set default keymap with remap choice
  if not keymap then
    default_keymap(choice)
  end
  if keymap and vim.fn.maparg(keymap) ~= "" and remap ~= true then
    local msg = string.format(
      "User-defined keymap (%s) already set to %s, defaulting to (<leader>st). To override this behavior, set opts.mapping.remap = true.",
      keymap,
      vim.fn.maparg(keymap)
    )
    vim.notify(msg, 1)
    default_keymap(choice)
  elseif keymap then
    vim.keymap.set("n", keymap, M.toggle_terminal)
  end
end

function M.setup(opts)
  local theme = {}

  if opts.theme then
    theme = configure_theme(opts.theme)
  else
    theme = default
  end

  options = vim.tbl_deep_extend("force", theme, opts.win_config or {})

  if opts.mapping then
    user_keymap(opts.mapping)
  else
    default_keymap()
  end
end

local function create_swift_win(opts)
  -- creates new terminal if M.state.swift.buf is not set; shows terminal if valid
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
  if not vim.api.nvim_win_is_valid(M.state.swift.win) then
    M.state.swift = create_swift_win({ buf = M.state.swift.buf })
    if vim.bo[M.state.swift.buf].buftype ~= "terminal" then
      vim.cmd.terminal()
    end
    vim.api.nvim_win_set_cursor(M.state.swift.win, { vim.api.nvim_buf_line_count(M.state.swift.buf), 0 })
  else
    vim.api.nvim_win_hide(M.state.swift.win)
  end
end

vim.api.nvim_create_autocmd("VimResized", {
  --BUG: floating window does not resize correctly
  group = vim.api.nvim_create_augroup("term-resized", {}),
  callback = function()
    if not vim.api.nvim_win_is_valid(M.state.swift.win) then
      return
    end

    local updated = configure_theme(options)
    vim.api.nvim_win_set_config(M.state.swift.win, updated)
  end,
})

vim.api.nvim_create_user_command("Swifterm", M.toggle_terminal, {})

return M
