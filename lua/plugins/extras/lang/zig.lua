return {
  "neovim/nvim-lspconfig",
  dependencies = {
    {
      "ziglang/zig.vim",
      init = function()
        vim.g.zig_fmt_autosave = 1

        vim.api.nvim_create_autocmd("BufReadPost", {
          pattern = "*.zig.zon",
          callback = function()
            vim.cmd("set ft=zig")
          end,
        })
      end,
    },
  },
  opts = {
    servers = {
      zls = {},
    },
  },
}
