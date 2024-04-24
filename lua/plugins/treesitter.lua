local treesitter_enabled_langs = {
  "hyprlang",
  "nim",
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    ft = treesitter_enabled_langs,
    cmd = { "TSEnable", "TSBufEnable" },
    -- stylua: ignore
    event = function() return {} end,
    opts = {
      highlight = {
        enable = true,
        disable = function(lang)
          return not vim.tbl_contains(treesitter_enabled_langs, lang)
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
