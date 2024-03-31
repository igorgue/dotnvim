local M = {}

M.diagnostic_config = {
  -- float = { border = "single" },
  float = { border = "rounded" },
  underline = true,
  virtual_text = {
    spacing = 0,
    prefix = "●",
  },
  signs = { text = { "", "", "", "" } },
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
  vim.cmd([[
    nohlsearch
    diffupdate
    normal! <C-L>
  ]])

  if vim.g.loaded_dadbod then
    -- stylua: ignore
    pcall(function() vim.cmd("DBUIHideNotifications") end)
  end

  -- stylua: ignore
  pcall(function() require("notify").dismiss({ silent = true, pending = true }) end)
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
      a = { fg = lualine_colors.darkgray, bg = lualine_colors.black, gui = "bold" },
      b = { fg = lualine_colors.darkgray, bg = lualine_colors.black },
      c = { fg = lualine_colors.darkgray, bg = lualine_colors.black, gui = "bold" },
      x = { fg = lualine_colors.darkgray, bg = lualine_colors.black },
      y = { fg = lualine_colors.darkgray, bg = lualine_colors.black, gui = "bold" },
      z = { fg = lualine_colors.darkgray, bg = lualine_colors.black, gui = "bold" },
    },
    insert = {
      a = { fg = lualine_colors.blue, bg = lualine_colors.black, gui = "bold" },
      b = { fg = lualine_colors.blue, bg = lualine_colors.black },
      c = { fg = lualine_colors.blue, bg = lualine_colors.black, gui = "bold" },
      x = { fg = lualine_colors.blue, bg = lualine_colors.black },
      y = { fg = lualine_colors.blue, bg = lualine_colors.black, gui = "bold" },
      z = { fg = lualine_colors.blue, bg = lualine_colors.black, gui = "bold" },
    },
    visual = {
      a = { fg = lualine_colors.lightgray, bg = lualine_colors.black, gui = "bold" },
      b = { fg = lualine_colors.lightgray, bg = lualine_colors.black },
      c = { fg = lualine_colors.lightgray, bg = lualine_colors.black, gui = "bold" },
      x = { fg = lualine_colors.lightgray, bg = lualine_colors.black },
      y = { fg = lualine_colors.lightgray, bg = lualine_colors.black, gui = "bold" },
      z = { fg = lualine_colors.lightgray, bg = lualine_colors.black, gui = "bold" },
    },
    replace = {
      a = { fg = lualine_colors.red, bg = lualine_colors.black, gui = "bold" },
      b = { fg = lualine_colors.red, bg = lualine_colors.black },
      c = { fg = lualine_colors.red, bg = lualine_colors.black, gui = "bold" },
      x = { fg = lualine_colors.red, bg = lualine_colors.black },
    },                               
    command = {                      
      a = { fg = lualine_colors.green, bg = lualine_colors.black, gui = "bold" },
      b = { fg = lualine_colors.green, bg = lualine_colors.black },
      c = { fg = lualine_colors.green, bg = lualine_colors.black, gui = "bold" },
      x = { fg = lualine_colors.green, bg = lualine_colors.black },
      y = { fg = lualine_colors.green, bg = lualine_colors.black, gui = "bold" },
      z = { fg = lualine_colors.green, bg = lualine_colors.black, gui = "bold" },
    },
    inactive = {
      a = { fg = lualine_colors.darkgray, bg = lualine_colors.black },
      b = { fg = lualine_colors.darkgray, bg = lualine_colors.black },
      c = { fg = lualine_colors.darkgray, bg = lualine_colors.black },
    },
  }

  if vim.o.diff ~= false then
    local defaults = {
      a = { fg = lualine_colors.inactivegray, bg = lualine_colors.black },
      b = { fg = lualine_colors.inactivegray, bg = lualine_colors.black },
      c = { fg = lualine_colors.inactivegray, bg = lualine_colors.black },
      x = { fg = lualine_colors.inactivegray, bg = lualine_colors.black },
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
