return {
  "grddavies/tidal.nvim",
  lazy = false,
  opts = {
    mappings = {
      send_line = { mode = { "n" }, key = "<CR>" },
      send_visual = { mode = { "x" }, key = "<CR>" },
      send_block = { mode = { "n", "x" }, key = "<S-CR>" },
      send_node = { mode = "n", key = "<leader><S-CR>" },
      send_silence = { mode = "n", key = "<leader>0" },
      send_hush = { mode = "n", key = "<leader><Esc>" },
    },
    boot = {
      -- tidal = {
      -- cmd = "ghci",
      -- args = {
      --   "-v0",
      -- },
      -- file = vim.api.nvim_get_runtime_file("bootfiles/BootTidal.hs", false)[1],
      -- enabled = true,
      -- },
      sclang = {
        -- cmd = "sclang",
        -- args = {},
        -- file = vim.api.nvim_get_runtime_file("bootfiles/BootSuperDirt.scd", false)[1],
        enabled = true,
      },
      split = "v",
    },
  },
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "haskell", "supercollider" } },
  },
}
