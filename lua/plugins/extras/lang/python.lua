vim.filetype.add({
  extension = {
    jinja = "jinja",
    jinja2 = "jinja",
    j2 = "jinja",
  },
})

vim.g.lazyvim_python_lsp = "basedpyright"

return {
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
    "neovim/nvim-lspconfig",
    opts = {
      setup = {
        -- stylua: ignore
        pyright = function() return true end,
      },
      servers = {
        basedpyright = {},
        jinja_lsp = {},
        djlsp = {},
      },
    },
  },
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "mfussenegger/nvim-dap-python",
    },
    opts = function()
      local path = require("mason-registry").get_package("debugpy"):get_install_path()

      require("dap").configurations.python = {}
      require("dap-python").setup(path .. "/venv/bin/python")
    end,
  },
  {
    "linux-cultist/venv-selector.nvim",
    branch = "regexp",
    lazy = false,
    cmd = "VenvSelect",
    config = function()
      require("venv-selector").setup()
    end,
  },
}
