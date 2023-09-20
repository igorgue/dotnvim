local ui_utils = require("utils").ui

local disable_fn = function(_, buf)
  local disable = ui_utils.disable_fn(buf)

  if not disable then
    return false
  end

  vim.notify_once("File too large\n* treesitter off", vim.log.levels.WARN)

  return true
end

return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      highlight = {
        disable = disable_fn,
      },
      indent = {
        disable = disable_fn,
      },
      incremental_selection = {
        disable = disable_fn,
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
    },
  },
}
