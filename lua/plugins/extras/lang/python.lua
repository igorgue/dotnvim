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
    "L3MON4D3/LuaSnip",
    optional = true,
    ft = { "htmldjango", "jinja" },
    config = function()
      require("luasnip").filetype_extend("htmldjango", { "html" })
      require("luasnip").filetype_extend("jinja", { "html" })
    end,
  },
  {
    "raimon49/requirements.txt.vim",
    event = "BufReadPre requirements*.txt",
  },
  {
    "saghen/blink.cmp",
    optional = true,
    dependencies = {
      "vrslev/cmp-pypi",
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
    "hrsh7th/nvim-cmp",
    optional = true,
    dependencies = {
      "vrslev/cmp-pypi",
    },
    opts = function(_, opts)
      local cmp = require("cmp")
      opts.sources = cmp.config.sources(vim.list_extend(opts.sources, {
        { name = "pypi", keyword_length = 4 },
      }))

      return opts
    end,
  },
  {
    "vrslev/cmp-pypi",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    event = "BufReadPost pyproject.toml",
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
      local path =
        require("mason-registry").get_package("debugpy"):get_install_path()

      require("dap").configurations.python = {}
      require("dap-python").setup(path .. "/venv/bin/python")
    end,
  },
  {
    "linux-cultist/venv-selector.nvim",
    branch = "regexp",
    lazy = false,
    cmd = "VenvSelect",
    enabled = function()
      return LazyVim.has("telescope.nvim")
    end,
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
