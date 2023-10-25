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
        disable = true,
      },
      indent = {
        disable = true,
      },
      incremental_selection = {
        disable = true,
        enable = false,
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
