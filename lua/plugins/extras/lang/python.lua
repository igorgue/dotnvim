vim.filetype.add({
  extension = {
    jinja = "jinja",
    jinja2 = "jinja",
    j2 = "jinja",
  },
})

return {
  {
    "L3MON4D3/LuaSnip",
    config = function()
      require("luasnip").filetype_extend("htmldjango", { "html" })
    end,
  },
  {
    "raimon49/requirements.txt.vim",
    event = "BufReadPre requirements*.txt",
  },
  {
    "vrslev/cmp-pypi",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "hrsh7th/nvim-cmp",
        opts = function(_, opts)
          local cmp = require("cmp")
          opts.sources = cmp.config.sources(vim.list_extend(opts.sources, {
            { name = "pypi", keyword_length = 4 },
          }))
        end,
      },
    },
    event = "BufReadPost pyproject.toml",
  },
  {
    "williamboman/mason.nvim",
    optional = true,
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "isort", "black", "ruff", "debugpy", "basedpyright" })
      end
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      setup = {
        pyright = function()
          return true
        end,
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
    ft = "python",
    cmd = "VenvSelect",
    config = function()
      require("venv-selector").setup()
    end,
  },
  {
    "igorgue/vim-python-enhanced-syntax",
    -- dir = "~/Code/vim-python-enhanced-syntax",
    ft = "python",
  },
}
