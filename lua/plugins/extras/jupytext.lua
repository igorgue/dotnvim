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
    "williamboman/mason.nvim",
    optional = true,
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "jupytext" })
      end
    end,
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
