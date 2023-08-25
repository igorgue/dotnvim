return {
  {
    "raimon49/requirements.txt.vim",
    event = "BufReadPre requirements*.txt",
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      setup = {
        ruff_lsp = function()
          require("lazyvim.util").on_attach(function(client, _)
            if client.name == "ruff_lsp" then
              -- Disable hover in favor of pyright
              client.server_capabilities.hoverProvider = false
            end
          end)
        end,
      },
    },
  },
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "mfussenegger/nvim-dap-python",
    },
    config = function()
      local path = require("mason-registry").get_package("debugpy"):get_install_path()

      require("dap").configurations.python = {}
      require("dap-python").setup(path .. "/venv/bin/python")
    end,
  },
  -- NOTE: disable python syntax until we can get it performing better
  -- on the large files I usually deal with, some of them not that
  -- large at all, like 500 lines. And when that highlight slowness
  -- happens, also indenting is slow, so disable that too.
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.highlight.disable) == "table" then
        vim.list_extend(opts.highlight.disable, { "python" })
      else
        opts.highlight.disable = { "python" }
      end

      if type(opts.indent.disable) == "table" then
        vim.list_extend(opts.indent.disable, { "python" })
      else
        opts.indent.disable = { "python" }
      end
    end,
  },
  -- NOTE: working only if lazy is false
  { "wookayin/semshi", lazy = false },
  -- NOTE: forked from wookayin's removed hardcoded values
  { "igorgue/vim-python-enhanced-syntax", ft = "python" },
  -- { dir = "~/Code/vim-python-enhanced-syntax", ft = "python" },
}
