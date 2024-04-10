local M = {}

M.ui = require("utils.ui")

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

function M.file_info()
  local file_path = vim.fn.expand("%:#")
  local cursor = vim.fn.line(".") .. ":" .. vim.fn.col(".")
  local lines = vim.fn.line("$")

  M.ui.refresh_ui()
  if file_path ~= "" then
    vim.notify('"' .. file_path .. '"' .. " @ " .. cursor .. " " .. lines .. " lines", "info", {
      title = "File Info",
    })
  end
end

return M
