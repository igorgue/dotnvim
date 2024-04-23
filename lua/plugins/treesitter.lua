return {
  {
    "nvim-treesitter/nvim-treesitter",
    ft = { "hyprlang" },
    -- stylua: ignore
    event = function() return {} end,
    opts = {
      highlight = {
        enable = true,
        disable = function(lang)
          -- add more langs later, as needed
          return lang ~= "hyprlang"
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
