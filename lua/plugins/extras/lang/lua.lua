return {
  {
    "neovim/nvim-lspconfig",
    ft = "lua",
    opts = {
      servers = {
        lua_ls = {},
      },
    },
  },
  {
    "folke/neodev.nvim",
    ft = "lua",
    -- stylua: ignore
    cond = function() return not vim.o.diff end,
    opts = {
      library = { plugins = { "nvim-dap-ui" }, types = true },
    },
  },
}
