local M = {}
local Util = require("lazyvim.util")

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
  Util.toggle.diagnostics()

  if vim.g.copilot_enabled == 0 then
    vim.cmd("Copilot enable")
  else
    vim.cmd("Copilot disable")
  end

  vim.cmd("Copilot status")
  -- vim.cmd("Lspsaga winbar_toggle")

  if vim.opt.laststatus:get() == 0 then
    vim.opt.laststatus = 3
  else
    vim.opt.laststatus = 0
  end
end

local function disable_winbar()
  local curbuf = vim.api.nvim_get_current_buf()
  local ok, g = pcall(vim.api.nvim_get_autocmds, {
    group = "SagaWinbar" .. curbuf,
    event = { "CursorMoved" },
    buffer = curbuf,
  })

  if ok then
    vim.opt_local.winbar = ""
    vim.api.nvim_del_augroup_by_id(g[1].group)
  end
end

function M.enable_focus_mode()
  vim.diagnostic.disable()
  vim.cmd("Copilot disable")
  vim.opt.laststatus = 0
  -- disable_winbar()
end

function M.open_terminal_tab()
  vim.cmd([[
    tabnew
    terminal
    startinsert
  ]])
end

M.ui = require("utils.ui")

return M
