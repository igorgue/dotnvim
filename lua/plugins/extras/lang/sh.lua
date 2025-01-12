vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = "*.env",
  callback = function()
    vim.diagnostic.enable(false, { bufnr = 0 })
  end,
})

vim.filetype.add({
  extension = {
    ["envrc"] = "sh",
  },
})

return {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "shellcheck",
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        bashls = {
          filetypes = {
            "sh",
            "zsh",
          },
        },
      },
    },
  },
}
