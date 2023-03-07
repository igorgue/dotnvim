return {
  {
    "neovim/nvim-lspconfig",
    ft = { "vlang" },
    opts = {
      servers = {
        vls = {},
      },
    },
  },
  {
    "ollykel/v-vim",
    event = {
      "BufReadPre *.v",
      "BufReadPre *.vv",
      "BufReadPre *.vsh",
      "BufNewFile *.v",
      "BufNewFile *.vv",
      "BufNewFile *.vsh",
    },
    config = function()
      -- stylua: ignore
      pcall(function() vim.cmd("!v ls --install") end)

      vim.g.v_autofmt_bufwritepre = true
    end,
  },
}
