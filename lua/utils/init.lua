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
end

function M.enable_focus_mode()
  vim.diagnostic.disable()
  vim.cmd("Copilot disable")
  vim.opt.laststatus = 0
end

M.ui = require("utils.ui")

return M
