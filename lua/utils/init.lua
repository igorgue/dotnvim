local M = {}

M.ui = require("utils.ui")

function M.version()
  local ver = vim.version()

  return ver.major .. "." .. ver.minor .. "." .. ver.patch
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
