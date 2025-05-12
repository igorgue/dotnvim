-- FIXME: it doesn't work because of how focus mode works
-- it sets the global diagnostic.enable and that takes,
-- priority over the buffer local diagnostic.enable
vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = "*.env",
  callback = function()
    vim.defer_fn(function()
      vim.diagnostic.enable(false, { bufnr = 0 })
    end, 1000)
  end,
})

vim.filetype.add({
  extension = {
    ["envrc"] = "sh",
  },
})

return {
  {
    "mason-org/mason.nvim",
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
