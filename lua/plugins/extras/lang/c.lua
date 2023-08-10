return {
  {
    "neovim/nvim-lspconfig",
    ft = { "c", "cpp" },
    opts = {
      setup = {
        clangd = function(_, clangd_opts)
          clangd_opts.capabilities = {
            offsetEncoding = { "utf-16" },
          }
        end,
      },
    },
    keys = { { "<leader>cR", "<cmd>ClangdSwitchSourceHeader<cr>", desc = "Switch Source/Header (C/C++)" } },
  },
}
