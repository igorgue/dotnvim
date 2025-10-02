vim.filetype.add({
  extension = {
    jinja = "jinja",
    jinja2 = "jinja",
    j2 = "jinja",
  },
})

vim.lsp.enable("pyrefly")

return {
  { import = "lazyvim.plugins.extras.lang.python" },
  {
    "mfussenegger/nvim-dap-python",
    build = false,
  },
  {
    "raimon49/requirements.txt.vim",
    event = "BufReadPre requirements*.txt",
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyright = false,
        basedpyright = false,
      },
    },
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
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = { "isort", "black", "ruff", "debugpy", "basedpyright", "pyrefly" },
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
    branch = "main",
    cmd = "VenvSelect",
  },
}
