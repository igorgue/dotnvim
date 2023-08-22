return {
  "neovim/nvim-lspconfig",
  opts = {
    setup = {
      millet = function(_, opts)
        vim.api.nvim_create_autocmd("FileType", {
          pattern = "sml",
          callback = function()
            require("lspconfig").millet.setup(opts.servers.millet)
          end,
        })
      end,
    },
    servers = {
      millet = {},
    },
  },
}
