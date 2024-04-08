return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "graphql" })
      else
        opts.ensure_installed = { "graphql" }
      end
    end,
  },
  {
    "neovim/nvim-lspconfig",
    ft = "graphql",
    opts = {
      servers = {
        graphql = {},
      },
    },
  },
  {
    "williamboman/mason.nvim",
    optional = true,
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "graphql-language-service-cli" })
      else
        opts.ensure_installed = { "graphql-language-service-cli" }
      end
    end,
  },
}
