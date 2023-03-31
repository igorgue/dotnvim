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

        vim.api.nvim_create_autocmd("FileType", {
          pattern = "zsh",
          callback = function()
            vim.lsp.start({
              name = "bash-language-server",
              cmd = { "bash-language-server", "start" },
            })
          end,
        })
      end,
    },
    servers = {
      bashls = {},
    },
  },
}
