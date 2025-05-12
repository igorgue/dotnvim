vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown" },
  callback = function()
    vim.defer_fn(function()
      require("otter").activate({ "python" })
    end, 150)
  end,
})

return {
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = { "jupytext" },
    },
  },
  {
    "GCBallesteros/jupytext.nvim",
    config = true,
    lazy = false,
    dependencies = {
      {
        "jmbuhr/otter.nvim",
        dependencies = {
          "nvim-treesitter/nvim-treesitter",
        },
        opts = {},
      },
    },
    opts = {
      -- style = "markdown",
      custom_language_formatting = {
        python = {
          extension = "md",
          style = "markdown",
          force_ft = "markdown",
        },
      },
    },
  },
}
