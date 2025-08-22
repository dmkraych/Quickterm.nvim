local themes = {}

function themes.floating(opts)
  -- creates the terminal floating and centered in the window; the default theme
  opts = opts or {}
  local theme_opts = {
    relative = "editor",
    width = opts.width or math.floor(vim.o.columns * 0.6),
    height = opts.height or math.floor(vim.o.lines * 0.6),
    col = math.floor((vim.o.columns * 0.4) / 2),
    row = math.floor((vim.o.lines * 0.4) / 2),
    border = opts.border or "double",
  }
  return theme_opts
end

function themes.bottom(opts)
  -- creates the terminal across the bottom of the window; spans the width
  opts = opts or {}
  local theme_opts = {
    relative = "editor",
    width = vim.o.columns,
    height = opts.height or 10,
    col = vim.o.columns - 1,
    row = vim.o.lines - 1,
    border = opts.border or "double",
  }
  return vim.tbl_deep_extend("force", theme_opts, opts)
end

function themes.top(opts)
  -- creates the terminal across the top of the window; spans the width
  opts = opts or {}
  local theme_opts = {
    relative = "editor",
    width = vim.o.columns,
    height = opts.height or 10,
    col = 1,
    row = 1,
    border = opts.border or "double",
  }
  return vim.tbl_deep_extend("force", theme_opts, opts)
end

return themes
