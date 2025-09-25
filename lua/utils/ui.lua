local M = {}

M.diagnostic_config = {
  -- float = { border = "single" },
  -- float = { border = "rounded" },
  float = { border = "none" },
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
    state = not vim.g.focus_mode
  end

  vim.opt.laststatus = state and 0 or 3

  if LazyVim.has("copilot.vim") or LazyVim.has("copilot.lua") then
    if not vim.g.focus_mode_no_copilot then
      vim.cmd("Copilot " .. (state and "disable" or "enable"))

      if LazyVim.has("copilot.lua") then
        vim.defer_fn(function()
          require("utils.ui").refresh_ui()
        end, 100)
      end
    end
  end

  if not vim.g.focus_mode_no_copilot and vim.fn.has("nvim-0.12") == 1 then
    vim.lsp.inline_completion.enable(not state)
  end

  if vim.g.loaded_tabby ~= nil then
    vim.g.tabby_trigger_mode = state and "manual" or "auto"
  end

  pcall(function()
    vim.cmd("SupermavenToggle")
  end)

  ---@diagnostic disable-next-line: param-type-mismatch
  pcall(vim.cmd, "IlluminateToggle")

  M.toggle_lsp_references(not state)
  M.toggle_winbar(not state)

  pcall(function()
    require("gitsigns").toggle_signs(vim.g.always_show_gitsigns and true or not state)
  end)

  vim.diagnostic.enable(not state)

  require("utils.ui").refresh_ui()
  vim.g.focus_mode = state
end

--- Toggles winbar
--- @param state boolean?
function M.toggle_winbar(state)
  if state == nil then
    ---@diagnostic disable-next-line: undefined-field
    state = vim.opt.winbar:get() == ""
  end

  if state then
    if package.loaded["nvim-navic"] and require("nvim-navic").is_available() then
      vim.opt.winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"
    end
  else
    vim.opt.winbar = ""
  end
end

--- Toggles LSP references
--- @param state boolean?
function M.toggle_lsp_references(state)
  local hl_info = vim.api.nvim_get_hl(0, { name = "LspReferenceRead" })

  if state == nil then
    state = hl_info.link == nil
  end

  if state then
    vim.api.nvim_set_hl(0, "LspReferenceText", { link = "Visual" })
    vim.api.nvim_set_hl(0, "LspReferenceRead", { link = "Visual" })
    vim.api.nvim_set_hl(0, "LspReferenceWrite", { link = "Visual" })
  else
    vim.api.nvim_set_hl(0, "LspReferenceText", {})
    vim.api.nvim_set_hl(0, "LspReferenceRead", {})
    vim.api.nvim_set_hl(0, "LspReferenceWrite", {})
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
    if vim.g.focus_mode_no_copilot then
      if vim.fn.has("nvim-0.12") == 1 then
        vim.lsp.inline_completion.enable(true)
      end

      if LazyVim.has("copilot.vim") or LazyVim.has("copilot.lua") then
        vim.cmd("Copilot enable")
      end
    else
      if vim.fn.has("nvim-0.12") == 1 then
        vim.lsp.inline_completion.enable(vim.g.focus_mode)
      end

      if LazyVim.has("copilot.vim") or LazyVim.has("copilot.lua") then
        vim.cmd("Copilot " .. (vim.g.focus_mode and "disable" or "enable"))
      end
    end

    if LazyVim.has("copilot.lua") then
      vim.defer_fn(function()
        require("utils.ui").refresh_ui()
      end, 100)
    end

    require("utils").ui.toggle_focus_mode(vim.g.focus_mode)
  end, 500)
end

return M
