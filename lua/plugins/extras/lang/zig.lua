return {
  "neovim/nvim-lspconfig",
  dependencies = {
    {
      "ziglang/zig.vim",
      init = function()
        vim.g.zig_fmt_autosave = 1
      end,
    },
  },
  opts = {
    servers = {
      zls = {},
    },
  },
}
