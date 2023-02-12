return {
  {
    "neovim/nvim-lspconfig",
    ft = "lua",
    opts = {
      servers = {
        lua_ls = {
          settings = {
            Lua = {
              runtime = {
                version = "LuaJIT",
              },
              diagnostics = {
                globals = { "vim" },
              },
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
              telemetry = {
                enable = false,
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
