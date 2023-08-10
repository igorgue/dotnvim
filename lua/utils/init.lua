local M = {}

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

-- TODO: Remove these two functions since they're not used anymore
function M.table_contains(table, item)
  for _, value in ipairs(table) do
    if value == item then
      return true
    end
  end
  return false
end

function M.ts_disable(lang, bufnr)
  local disabled_langs = {
    "zig",
  }

  if not M.table_contains(disabled_langs, lang) then
    return true
  end

  local max_filesize = 100 * 1024 -- 100 KB
  local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(bufnr))
  if ok and stats and stats.size < max_filesize then
    return false
  end

  vim.notify_once(
    "* Treesitter degraded\n" .. "* autoformat off\n" .. "* foldmethod manual\n" .. "* disable winbar",
    vim.log.levels.WARN,
    { title = "File is too large!" }
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
