local M = {}

M.ui = require("utils.ui")

function M.version()
  local ver = vim.version()

  return ver.major .. "." .. ver.minor .. "." .. ver.patch
end

function M.file_info()
  local path = vim.fn.expand("%:~:.")
  local cursor = vim.fn.line(".") .. ":" .. vim.fn.col(".")
  local lines = vim.fn.line("$")

  M.ui.refresh_ui()

  if #path > 50 then
    vim.notify('"' .. path .. '"' .. "\n" .. cursor .. " " .. lines .. " lines", "info", {
      title = "File Info",
    })
  else
    vim.notify('"' .. path .. '"' .. " @ " .. cursor .. " " .. lines .. " lines", "info", {
      title = "File Info",
    })
  end
end

return M
