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
    build = "v ls --install",
    config = function()
      vim.g.v_autofmt_bufwritepre = true
    end,
  },
}
