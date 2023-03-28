local M = {}

function M.table_contains(table, item)
  for _, value in ipairs(table) do
    if value == item then
      return true
    end
  end
  return false
end

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

function M.ts_disable(lang, bufnr)
  local langs = {
    "javascript",
    "typescript",
    "typescriptreact",
    "javascriptreact",
    "python",
    "elixir",
    "c",
    "cpp",
    "rust",
    "dart",
  }

  if not M.table_contains(langs, lang) then
    return false
  end

  local line_count = vim.api.nvim_buf_line_count(bufnr)

  if line_count < 2000 then
    return false
  end

  vim.notify_once(
    "* Treesitter degraded\n" .. "* autoformat off\n" .. "* foldmethod manual\n" .. "* disable winbar",
    vim.log.levels.WARN,
    { title = "File is too large! (" .. line_count .. " lines > 2000)" }
  )

  vim.b.autoformat = false
  vim.o.winbar = ""
  vim.opt_local.foldmethod = "manual"

  if vim.version().major >= 9 then
    if not vim.diagnostic.is_disabled(bufnr) then
      vim.diagnostic.disable(bufnr)
    end
  else
    vim.diagnostic.disable(bufnr)
  end

  return true
end

M.ui = require("utils.ui")

return M
