return {
  "grddavies/tidal.nvim",
  lazy = false,
  opts = {
    mappings = {
      send_line = { mode = { "n" }, key = "<cr>" },
      send_visual = { mode = { "x" }, key = "<cr>" },
      send_block = { mode = { "n", "x" }, key = "<s-cr>" },
      send_node = { mode = "n", key = "<leader><s-cr>" },
      send_silence = { mode = "n", key = "<leader>0" },
      send_hush = { mode = "n", key = "<leader><esc>" },
    },
    boot = {
      sclang = {
        enabled = true,
      },
    },
  },
  cmd = { "TidalLaunch", "TidalQuit" },
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "haskell", "supercollider" } },
  },
  keys = {
    {
      "<leader>;;",
      "<cmd>TidalLaunch<cr>",
      ft = "haskell",
    },
    {
      "<leader>;:",
      "<cmd>TidalQuit<cr>",
      ft = "haskell",
    },
  },
}
