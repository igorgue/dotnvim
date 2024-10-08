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
    optional = true,
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "shellcheck" })
      end
    end,
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
