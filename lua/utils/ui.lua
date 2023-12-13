local M = {}

M.diagnostic_config = {
  -- float = { border = "single" },
  underline = true,
  virtual_text = {
    spacing = 0,
    prefix = "●",
  },
  signs = true,
  update_in_insert = true,
  severity_sort = true,
}

function M.disable_fn(buf)
  local max_filesize = 100 * 1024 -- 100 KB
  local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
  if ok and stats and stats.size > max_filesize then
    return true
  end
end

function M.refresh_ui()
  vim.cmd("cd ~")
  vim.cmd("cd -")
  vim.cmd("nohlsearch")
  vim.cmd("diffupdate")
  vim.cmd("normal! <C-L>")
  -- stylua: ignore start
  pcall(function() vim.cmd("DBUIHideNotifications") end)
  pcall(function() require("notify").dismiss({ silent = true, pending = true }) end)
  -- stylua: ignore end
end

function M.hi_co(group, kind)
  local succ, val = pcall(vim.fn.hlID, group)

  if not succ then
    return ""
  end

  local succ2, val2 = pcall(vim.fn.synIDattr, val, kind)

  if not succ2 then
    return ""
  end

  return val2
end

function M.lualine_theme()
  local lualine_colors = {}

  if
    vim.env.NVIM_COLORSCHEME == "danger"
    or vim.env.NVIM_COLORSCHEME == "danger_dark"
    or vim.g.colors_name == "danger"
    or vim.g.colors_name == "danger_dark"
  then
    lualine_colors = {
      black = M.hi_co("Normal", "bg"),
      white = M.hi_co("Normal", "fg"),
      red = M.hi_co("DiffDelete", "bg"),
      green = M.hi_co("DiffAdd", "bg"),
      blue = M.hi_co("CursorLineNr", "fg"),
      lightblue = M.hi_co("CursorLineNr", "bg"),
      yellow = M.hi_co("DiffChange", "bg"),
      gray = M.hi_co("Pmenu", "fg"),
      darkgray = M.hi_co("LspCodeLens", "fg"),
      lightgray = M.hi_co("Visual", "bg"),
      inactivegray = M.hi_co("TabLine", "fg"),
    }
  else
    lualine_colors = {
      black = M.hi_co("Normal", "bg"),
      white = M.hi_co("Normal", "fg"),
      red = M.hi_co("DiffDelete", "bg"),
      green = M.hi_co("DiffAdd", "bg"),
      blue = M.hi_co("Folded", "fg"),
      lightblue = M.hi_co("Folded", "bg"),
      yellow = M.hi_co("DiffChange", "bg"),
      gray = M.hi_co("StatusLine", "fg"),
      darkgray = M.hi_co("Normal", "fg"),
      lightgray = M.hi_co("Visual", "bg"),
      inactivegray = M.hi_co("Normal", "fg"),
    }
  end

  local theme = {
    normal = {
      a = { bg = lualine_colors.lightblue, fg = lualine_colors.white, gui = "bold" },
      b = { bg = lualine_colors.lightblue, fg = lualine_colors.white },
      c = { bg = lualine_colors.lightblue, fg = lualine_colors.white, gui = "bold" },
      x = { bg = lualine_colors.lightblue, fg = lualine_colors.white },
      y = { bg = lualine_colors.lightblue, fg = lualine_colors.white, gui = "bold" },
      z = { bg = lualine_colors.lightblue, fg = lualine_colors.white, gui = "bold" },
    },
    insert = {
      a = { bg = lualine_colors.blue, fg = lualine_colors.black, gui = "bold" },
      b = { bg = lualine_colors.blue, fg = lualine_colors.black },
      c = { bg = lualine_colors.blue, fg = lualine_colors.black, gui = "bold" },
      x = { bg = lualine_colors.blue, fg = lualine_colors.black },
      y = { bg = lualine_colors.blue, fg = lualine_colors.black, gui = "bold" },
      z = { bg = lualine_colors.blue, fg = lualine_colors.black, gui = "bold" },
    },
    visual = {
      a = { bg = lualine_colors.lightgray, fg = lualine_colors.white, gui = "bold" },
      b = { bg = lualine_colors.lightgray, fg = lualine_colors.white },
      c = { bg = lualine_colors.lightgray, fg = lualine_colors.white, gui = "bold" },
      x = { bg = lualine_colors.lightgray, fg = lualine_colors.white },
      y = { bg = lualine_colors.lightgray, fg = lualine_colors.white, gui = "bold" },
      z = { bg = lualine_colors.lightgray, fg = lualine_colors.white, gui = "bold" },
    },
    replace = {
      a = { bg = lualine_colors.red, fg = lualine_colors.black, gui = "bold" },
      b = { bg = lualine_colors.red, fg = lualine_colors.black },
      c = { bg = lualine_colors.red, fg = lualine_colors.black, gui = "bold" },
      x = { bg = lualine_colors.red, fg = lualine_colors.black },
    },
    command = {
      a = { bg = lualine_colors.green, fg = lualine_colors.black, gui = "bold" },
      b = { bg = lualine_colors.green, fg = lualine_colors.black },
      c = { bg = lualine_colors.green, fg = lualine_colors.black, gui = "bold" },
      x = { bg = lualine_colors.green, fg = lualine_colors.black },
      y = { bg = lualine_colors.green, fg = lualine_colors.black, gui = "bold" },
      z = { bg = lualine_colors.green, fg = lualine_colors.black, gui = "bold" },
    },
    inactive = {
      a = { bg = lualine_colors.darkgray, fg = lualine_colors.gray },
      b = { bg = lualine_colors.darkgray, fg = lualine_colors.gray },
      c = { bg = lualine_colors.darkgray, fg = lualine_colors.gray },
    },
  }

  if vim.o.diff ~= false then
    local defaults = {
      a = { bg = lualine_colors.inactivegray, fg = lualine_colors.white },
      b = { bg = lualine_colors.inactivegray, fg = lualine_colors.white },
      c = { bg = lualine_colors.inactivegray, fg = lualine_colors.white },
      x = { bg = lualine_colors.inactivegray, fg = lualine_colors.white },
    }

    theme.inactive = defaults
    theme.normal = defaults
    theme.insert = defaults
    theme.visual = defaults
    theme.replace = defaults
    theme.command = defaults
    theme.inactive = defaults
  end

  return theme
end

return M
