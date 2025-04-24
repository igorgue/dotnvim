vim.filetype.add({
  extension = {
    jinja = "jinja",
    jinja2 = "jinja",
    j2 = "jinja",
  },
})

return {
  { import = "lazyvim.plugins.extras.lang.python" },
  {
    "raimon49/requirements.txt.vim",
    event = "BufReadPre requirements*.txt",
  },
  {
    "saghen/blink.cmp",
    optional = true,
    dependencies = {
      {
        "vrslev/cmp-pypi",
        dependencies = {
          "nvim-lua/plenary.nvim",
        },
        event = "BufReadPost pyproject.toml",
      },
    },
    opts = {
      sources = {
        default = { "pypi" },
        providers = {
          pypi = {
            name = "pypi",
            module = "blink.compat.source",
            opts = {
              keyword_length = 4,
            },
          },
        },
      },
    },
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = { "isort", "black", "ruff", "debugpy", "basedpyright" },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "jinja", "jinja_inline", "htmldjango" },
    },
  },
  {
    "linux-cultist/venv-selector.nvim",
    branch = "regexp",
    enabled = true,
    cmd = "VenvSelect",
    config = function()
      require("venv-selector").setup()
    end,
  },
}
