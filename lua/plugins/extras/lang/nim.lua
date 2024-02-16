vim.api.nvim_create_autocmd("FileType", {
  pattern = "nim",
  callback = function()
    vim.bo.tabstop = 2
    vim.bo.softtabstop = 2
    vim.bo.shiftwidth = 2
    vim.bo.expandtab = true

    vim.lsp.start({
      name = "nim",
      filetypes = { "nim" },
      cmd = { "nimlangserver" },
      root_dir = vim.fn.getcwd(),
      single_file_support = true,
      settings = {
        nim = {},
      },
    })
  end,
})

return {
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
