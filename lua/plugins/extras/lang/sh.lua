vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = "*.env",
  callback = function()
    vim.diagnostic.disable(0)
  end,
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
