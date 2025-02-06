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

function M.refresh_ui()
  pcall(function()
    vim.cmd([[
      nohlsearch
      diffupdate
    ]])
  end)

  if vim.g.loaded_dadbod then
    -- stylua: ignore
    pcall(function() vim.cmd("DBUIHideNotifications") end)
  end

  -- stylua: ignore
  pcall(Snacks.notifier.hide)
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
      a = {
        fg = lualine_colors.darkgray,
        bg = lualine_colors.black,
        gui = "bold",
      },
      b = { fg = lualine_colors.darkgray, bg = lualine_colors.black },
      c = {
        fg = lualine_colors.darkgray,
        bg = lualine_colors.black,
        gui = "bold",
      },
      x = { fg = lualine_colors.darkgray, bg = lualine_colors.black },
      y = {
        fg = lualine_colors.darkgray,
        bg = lualine_colors.black,
        gui = "bold",
      },
      z = {
        fg = lualine_colors.darkgray,
        bg = lualine_colors.black,
        gui = "bold",
      },
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
      a = {
        fg = lualine_colors.lightgray,
        bg = lualine_colors.black,
        gui = "bold",
      },
      b = { fg = lualine_colors.lightgray, bg = lualine_colors.black },
      c = {
        fg = lualine_colors.lightgray,
        bg = lualine_colors.black,
        gui = "bold",
      },
      x = { fg = lualine_colors.lightgray, bg = lualine_colors.black },
      y = {
        fg = lualine_colors.lightgray,
        bg = lualine_colors.black,
        gui = "bold",
      },
      z = {
        fg = lualine_colors.lightgray,
        bg = lualine_colors.black,
        gui = "bold",
      },
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

--- Toggles focus mode
--- @param state boolean?
function M.toggle_focus_mode(state)
  if state == nil then
    state = vim.g.focus_mode
  end

  vim.opt.laststatus = state and 0 or 3

  if require("lazy.core.config").plugins["copilot.vim"] ~= nil then
    vim.cmd("Copilot " .. (state and "enable" or "disable"))
  end

  if vim.g.loaded_tabby ~= nil then
    vim.g.tabby_trigger_mode = state and "manual" or "auto"
  end

  pcall(function()
    vim.cmd("SupermavenToggle")
  end)

  ---@diagnostic disable-next-line: param-type-mismatch
  pcall(vim.cmd, "IlluminateToggle")

  M.toggle_lsp_references(state)
  M.toggle_winbar(state)

  pcall(function()
    if not vim.g.always_show_gitsigns then
      vim.cmd("Gitsigns toggle_signs")
    end
  end)

  if vim.version().minor >= 10 then
    vim.diagnostic.enable(state)
  else
    ---@diagnostic disable-next-line: deprecated
    if vim.diagnostic.is_disabled(0) then
      ---@diagnostic disable-next-line: param-type-mismatch
      vim.diagnostic.enable(0)
    else
      ---@diagnostic disable-next-line: deprecated
      vim.diagnostic.disable(0)
    end
  end

  require("utils.ui").refresh_ui()
  vim.g.focus_mode = state
end

--- Toggles winbar
--- @param state boolean?
function M.toggle_winbar(state)
  if state == nil then
    ---@diagnostic disable-next-line: undefined-field
    state = vim.opt.winbar:get() ~= ""
  end

  if state then
    vim.opt.winbar = ""
  else
    if package.loaded["nvim-navic"] and require("nvim-navic").is_available() then
      vim.opt.winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"
    end
  end
end

--- Toggles LSP references
--- @param state boolean?
function M.toggle_lsp_references(state)
  local hl_info = vim.api.nvim_get_hl(0, { name = "LspReferenceRead" })

  if state == nil then
    -- flip the state
    state = hl_info.link ~= nil
  end

  if state then
    vim.api.nvim_set_hl(0, "LspReferenceText", {})
    vim.api.nvim_set_hl(0, "LspReferenceRead", {})
    vim.api.nvim_set_hl(0, "LspReferenceWrite", {})
  else
    vim.api.nvim_set_hl(0, "LspReferenceText", { link = "Visual" })
    vim.api.nvim_set_hl(0, "LspReferenceRead", { link = "Visual" })
    vim.api.nvim_set_hl(0, "LspReferenceWrite", { link = "Visual" })
  end
end

function M.open_terminal_tab()
  vim.cmd([[
    tabnew
    terminal
    startinsert
  ]])
end

function M.autostart_focus_mode()
  vim.defer_fn(function()
    require("utils").ui.toggle_focus_mode(vim.g.focus_mode)
  end, 100)
end

return M
