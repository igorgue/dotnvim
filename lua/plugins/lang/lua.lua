return {
  {
    "neovim/nvim-lspconfig",
    ft = "lua",
    opts = {
      servers = {
        sumneko_lua = {
          settings = {
            Lua = {
              codeLens = {
                enable = true,
              },
              hint = {
                enable = true,
                setType = true,
              },
              completion = {
                callSnippets = "Replace",
              },
            },
          },
        },
      },
    },
  },
  {
    "folke/neodev.nvim",
    ft = "lua",
    opts = {
      library = { plugins = { "nvim-dap-ui" }, types = true },
    },
  },
}
