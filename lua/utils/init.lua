local M = {}

M.ui = require("utils.ui")

function M.version()
  local ver = vim.version()

  return ver.major .. "." .. ver.minor .. "." .. ver.patch
end

function M.file_info()
  local path = vim.fn.expand("%:~:.")
  local filename = vim.fn.expand("%:t")
  local cursor = vim.fn.line(".") .. ":" .. vim.fn.col(".")
  local lines = vim.fn.line("$")

  M.ui.refresh_ui()

  if #path > 50 then
    vim.notify('"' .. path .. '"' .. "\n" .. cursor .. " " .. lines .. " lines", vim.log.levels.INFO, {
      title = filename,
    })
  else
    vim.notify('"' .. path .. '"' .. " @ " .. cursor .. " " .. lines .. " lines", vim.log.levels.INFO, {
      title = filename,
    })
  end
end

--- @param source string
function M.cmp_append_default_source(source)
  local cmp_default_sources = vim.g.cmp_default_sources

  table.insert(cmp_default_sources, source)

  vim.g.cmp_default_sources = cmp_default_sources
end

return M
