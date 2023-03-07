local M = {}

M.diagnostic_config = {
  float = { border = "rounded" },
  underline = true,
  virtual_text = {
    spacing = 0,
    prefix = "●",
  },
  signs = true,
  update_in_insert = true,
  severity_sort = true,
}

function M.hi_co(group, kind)
  return vim.fn.synIDattr(vim.fn.hlID(group), kind)
end

function M.lualine_theme()
  local lualine_colors = {
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

  if vim.api.nvim_win_get_option(0, "diff") then
    local defaults = {
      a = { bg = lualine_colors.black, fg = lualine_colors.inactivegray },
      b = { bg = lualine_colors.black, fg = lualine_colors.inactivegray },
      c = { bg = lualine_colors.black, fg = lualine_colors.inactivegray },
      x = { bg = lualine_colors.black, fg = lualine_colors.inactivegray },
    }

    theme.inactive = defaults
    theme.normal = defaults
    theme.insert = defaults
    theme.visual = defaults
    theme.visual.x = { bg = lualine_colors.blue, fg = lualine_colors.black }
    theme.replace = defaults
    theme.command = defaults
    theme.inactive = defaults
  end

  return theme
end

return M
