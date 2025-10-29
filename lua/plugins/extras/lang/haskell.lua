return {
  { import = "lazyvim.plugins.extras.lang.haskell" },
  { "mrcjkb/haskell-tools.nvim", lazy = false },
  { "mrcjkb/haskell-snippets.nvim", enabled = false }, -- FIXME: doesn't work well with blink.cmp
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        -- FIXME: disable "hlint" because it crashes on tidal cycles files
        haskell = {},
      },
    },
  },
}
