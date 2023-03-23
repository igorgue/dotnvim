return {
  "neovim/nvim-lspconfig",
  opts = {
    setup = {
      bashls = function()
        vim.api.nvim_create_autocmd("BufReadPost", {
          pattern = "*.env",
          callback = function()
            vim.diagnostic.disable(0)
          end,
        })
      end,
    },
    servers = {
      bashls = {},
    },
  },
}
