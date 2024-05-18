local ts_default_enabled_langs = {
  "hyprlang",
  "nim",
  "markdown",
}

if type(vim.g.ts_enabled_langs) == "table" then
  vim.list_extend(vim.g.ts_enabled_langs, ts_default_enabled_langs)
else
  vim.g.ts_enabled_langs = ts_default_enabled_langs
end

return {
  {
    "nvim-treesitter/nvim-treesitter",
    ft = vim.g.ts_enabled_langs,
    cmd = { "TSEnable", "TSBufEnable" },
    -- stylua: ignore
    event = function() return {} end,
    opts = {
      highlight = {
        enable = true,
        disable = function(lang)
          vim.notify(vim.inspect(vim.g.treesitter_enabled_langs))
          return not vim.tbl_contains(vim.g.treesitter_enabled_langs, lang)
        end,
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
