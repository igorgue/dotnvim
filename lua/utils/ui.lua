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
  local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
  if ok and stats and stats.size > max_filesize then
    return true
  end
end

function M.refresh_ui()
  vim.cmd([[
    nohlsearch
    diffupdate
  ]])

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

function M.toggle_focus_mode()
  ---@diagnostic disable-next-line: undefined-field
  vim.opt.laststatus = vim.opt.laststatus:get() == 0 and 3 or 0

  if vim.g.copilot_enabled ~= nil then
    if vim.g.copilot_enabled == 0 then
      vim.cmd("Copilot enable")
    elseif vim.g.copilot_enabled == 1 then
      vim.cmd("Copilot disable")
    end
  end

  if vim.g.loaded_tabby ~= nil then
    vim.g.tabby_trigger_mode = vim.g.tabby_trigger_mode == "manual" and "auto" or "manual"
  end

  pcall(function()
    vim.cmd("SupermavenToggle")
  end)

  ---@diagnostic disable-next-line: param-type-mismatch
  pcall(vim.cmd, "IlluminateToggle")

  M.toggle_lsp_references()
  M.toggle_winbar()

  pcall(function()
    if not vim.g.always_show_gitsigns then
      vim.cmd("Gitsigns toggle_signs")
    end
  end)

  -- NOTE: this was annoying, evaluate
  -- if vim.opt_local.ft:get() == "c" then
  --   require("clangd_extensions.inlay_hints").toggle_inlay_hints()
  -- else
  --   vim.lsp.inlay_hint.enable(0, not vim.lsp.inlay_hint.is_enabled(0))
  -- end

  if vim.version().minor >= 10 then
    vim.diagnostic.enable(not vim.diagnostic.is_enabled())
  else
    if vim.diagnostic.is_disabled(0) then
      vim.diagnostic.enable(0)
    else
      vim.diagnostic.disable(0)
    end
  end

  require("utils.ui").refresh_ui()
end

function M.toggle_winbar()
  ---@diagnostic disable-next-line: undefined-field
  vim.opt.winbar = vim.opt.winbar:get() == "" and "%{%v:lua.require'nvim-navic'.get_location()%}" or ""
end

function M.toggle_lsp_references()
  local hl_info = vim.api.nvim_get_hl(0, { name = "LspReferenceRead" })
  if hl_info.link then
    vim.api.nvim_set_hl(0, "LspReferenceText", {})
    vim.api.nvim_set_hl(0, "LspReferenceRead", {})
    vim.api.nvim_set_hl(0, "LspReferenceWrite", {})
  else
    vim.api.nvim_set_hl(0, "LspReferenceText", { link = "Visual" })
    vim.api.nvim_set_hl(0, "LspReferenceRead", { link = "Visual" })
    vim.api.nvim_set_hl(0, "LspReferenceWrite", { link = "Visual" })
  end
end

local function disable_winbar()
  vim.opt.winbar = ""
end

function M.enable_focus_mode()
  vim.opt.laststatus = 0
  pcall(function()
    vim.cmd("Copilot disable")
  end)
  pcall(function()
    vim.cmd("SupermavenStop")
  end)
  vim.opt.winbar = ""

  vim.api.nvim_set_hl(0, "LspReferenceText", {})
  vim.api.nvim_set_hl(0, "LspReferenceRead", {})
  vim.api.nvim_set_hl(0, "LspReferenceWrite", {})
end

function M.open_terminal_tab()
  vim.cmd([[
    tabnew
    terminal
    startinsert
  ]])
end

return M
