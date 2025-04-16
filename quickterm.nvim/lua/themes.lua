local themes = {}

function themes.floating(opts)
  opts = opts or {}
  local theme_opts = {
    relative = "editor",
    -- theme = "floating",
    width = opts.width or math.floor(vim.o.columns * 0.6),
    height = opts.height or math.floor(vim.o.lines * 0.6),
    col = math.floor((vim.o.columns * 0.4) / 2),
    row = math.floor((vim.o.lines * 0.4) / 2),
    border = opts.border or "double",
    -- mapping = opts.mapping or true,
  }
  return theme_opts
end

function themes.bottom(opts)
  opts = opts or {}
  local theme_opts = {
    relative = "editor",
    -- theme = "bottom",
    width = vim.o.columns,
    height = opts.height or 10,
    col = vim.o.columns - 1,
    row = vim.o.lines - 1,
    border = opts.border or "double",
    -- mapping = opts.mapping or true,
  }
  return vim.tbl_deep_extend("force", theme_opts, opts)
end

function themes.top(opts)
  opts = opts or {}
  local theme_opts = {
    relative = "editor",
    -- theme = "top",
    width = vim.o.columns,
    height = opts.height or 10,
    col = 1,
    row = 1,
    border = opts.border or "double",
    -- mapping = opts.mapping or true,
  }
  return vim.tbl_deep_extend("force", theme_opts, opts)
end

return themes
