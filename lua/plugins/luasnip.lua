return {
  "L3MON4D3/LuaSnip",
  dependencies = {
    "rafamadriz/friendly-snippets",
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
    end,
  },
  lazy = true,
  opts = {
    history = true,
    delete_check_events = "TextChanged",
  },
  -- NOTE: keys are handled by cmp, ctrl+j/k
  -- stylua: ignore
  keys = function() return {} end,
}
