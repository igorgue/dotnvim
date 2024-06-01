-- local ts_default_enabled_langs = {
--   "hyprlang",
--   "nim",
--   "markdown",
--   "elixir",
--   "eex",
--   "heex",
--   "surface",
--   "graphql",
--   "javascript",
--   "typescript",
--   "c",
--   "cpp",
--   "rust",
--   "toml",
-- }

return {
  {
    "nvim-treesitter/nvim-treesitter",
    ft = ts_default_enabled_langs,
    cmd = { "TSEnable", "TSBufEnable" },
    -- stylua: ignore
    event = function() return {} end,
    opts = {
      highlight = {
        enable = true,
        -- disable = function(lang)
        --   return not vim.tbl_contains(ts_default_enabled_langs, lang)
        -- end,
      },
      indent = {
        enable = false,
      },
      incremental_selection = {
        enable = false,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
    },
    -- stylua: ignore
    keys = function() return {} end,
  },
}
