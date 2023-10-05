return {
  -- FIXME: LSP is not working
  -- {
  --   "neovim/nvim-lspconfig",
  --   ft = { "nim" },
  --   opts = function(_, opts)
  --     opts.servers = {
  --       nim_langserver = {},
  --     }
  --   end,
  -- },
  {
    "alaviss/nim.nvim",
    ft = { "nim" },
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "nim",
        callback = function()
          vim.opt_local.foldignore = "#"
          vim.opt_local.foldmethod = "manual"
        end,
      })
    end,
  },
}
