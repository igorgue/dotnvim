local M = {}
local Util = require("lazyvim.util")

M.ui = require("utils.ui")

-- core utils
function M.version()
  local neovim_version = vim.version()

  if neovim_version == nil then
    neovim_version = {
      major = 0,
      minor = 0,
      patch = 0,
      prerelease = true,
    }
  end

  return neovim_version.major .. "." .. neovim_version.minor .. "." .. neovim_version.patch
end

-- other utils
function M.toggle_focus_mode()
  require("utils.ui").refresh_ui()

  if vim.opt.laststatus:get() == 0 then
    vim.opt.laststatus = 3
  else
    vim.opt.laststatus = 0
  end

  if vim.g.copilot_enabled == 0 then
    vim.cmd("Copilot enable")
  else
    vim.cmd("Copilot disable")
  end

  pcall(vim.cmd, "IlluminateToggle")

  M.toggle_winbar()

  -- NOTE: this was annoying, evaluate
  -- if vim.opt_local.ft:get() == "c" then
  --   require("clangd_extensions.inlay_hints").toggle_inlay_hints()
  -- else
  --   vim.lsp.inlay_hint.enable(0, not vim.lsp.inlay_hint.is_enabled(0))
  -- end

  Util.toggle.diagnostics()
end

function M.toggle_winbar()
  if vim.opt.winbar:get() == "" then
    vim.opt.winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"
  else
    vim.opt.winbar = ""
  end
end

local function disable_winbar()
  vim.opt.winbar = ""
end

function M.enable_focus_mode()
  vim.diagnostic.disable()
  vim.cmd("Copilot disable")
  vim.opt.laststatus = 0
  pcall(vim.cmd, "IlluminatePause")
  disable_winbar()
end

function M.open_terminal_tab()
  vim.cmd([[
    tabnew
    terminal
    startinsert
  ]])
end

return M
