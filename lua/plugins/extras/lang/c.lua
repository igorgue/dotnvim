return {
  {
    "neovim/nvim-lspconfig",
    ft = { "c", "cpp" },
    dependencies = {
      {
        "p00f/clangd_extensions.nvim",
        config = function()
          require("lazyvim.util").on_attach(function(client, _)
            if client.name == "clangd" then
              require("clangd_extensions.inlay_hints").setup_autocmd()
              require("clangd_extensions.inlay_hints").set_inlay_hints()
            end
          end)
        end,
        keys = {
          { "<leader>cR", "<cmd>ClangdSwitchSourceHeader<cr>", desc = "Switch Source/Header (C/C++)" },
          { "<leader>cA", "<cmd>ClangdAST<cr>", desc = "Display AST (C/C++)" },
        },
      },
    },
    opts = {
      setup = {
        clangd = function(_, opts)
          opts.capabilities = {
            offsetEncoding = { "utf-16" },
          }
        end,
      },
    },
  },
}
