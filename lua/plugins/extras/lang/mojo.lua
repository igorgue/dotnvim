return {
  {
    "nvim-treesitter/nvim-treesitter",
    ft = { "mojo" },
    opts = function(_, opts)
      vim.treesitter.language.register("python", "mojo")

      opts.highlight.additional_vim_regex_highlighting = true

      return opts
    end,
  },
  {
    "czheo/mojo.vim",
    ft = { "mojo" },
    lazy = false,
    init = function()
      vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        pattern = { "*.🔥", "*.mojo" },
        callback = function()
          vim.cmd("silent! !mojo format --quiet " .. vim.fn.expand("%:p"))
        end,
      })

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "mojo",
        callback = function()
          vim.bo.expandtab = true
          vim.bo.shiftwidth = 4
          vim.bo.softtabstop = 4

          vim.lsp.start({
            name = "mojo-lsp-server",
            cmd = { vim.env.MODULAR_HOME .. "/pkg/packages.modular.com_mojo/bin/mojo-lsp-server" },
          })
        end,
      })
    end,
  },
}
