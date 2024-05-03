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
    "williamboman/mason.nvim",
    optional = true,
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "isort", "black", "ruff", "ruff-lsp", "debugpy", "basedpyright" })
      end
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      setup = {
        ruff_lsp = function()
          require("lazyvim.util").lsp.on_attach(function(client, _)
            if client.name == "ruff_lsp" then
              -- Disable hover in favor of pyright
              client.server_capabilities.hoverProvider = false
            end
          end)
        end,
        pyright = function()
          return true
        end,
      },
      servers = {
        basedpyright = {},
        jinja_lsp = {},
        ruff_lsp = {
          keys = {
            {
              "<leader>co",
              function()
                vim.lsp.buf.code_action({
                  apply = true,
                  context = {
                    only = { "source.organizeImports" },
                    diagnostics = {},
                  },
                })
              end,
              desc = "Organize Imports",
            },
          },
        },
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
    config = function(_, opts)
      local venv_selector = require("venv-selector")

      opts.changed_venv_hooks = {
        venv_selector.hooks.basedpyright,
      }

      venv_selector.setup(opts)
    end,
    init = function()
      vim.api.nvim_create_autocmd("VimEnter", {
        desc = "Auto select virtualenv Nvim open",
        pattern = "*",
        callback = function()
          local venv = vim.fn.findfile("pyproject.toml", vim.fn.getcwd() .. ";")

          if venv == "" then
            local names = { "venv", ".venv", "env", ".env" }
            for _, name in ipairs(names) do
              if venv ~= "" then
                break
              end

              venv = vim.fn.finddir(name, vim.fn.getcwd())
            end
          end

          if venv ~= "" then
            require("venv-selector").retrieve_from_cache()
          end
        end,
        once = true,
      })

      return true
    end,
    opts = {
      dap_enabled = true,
    },
  },
  {
    "igorgue/vim-python-enhanced-syntax",
    -- dir = "~/Code/vim-python-enhanced-syntax",
    ft = "python",
  },
}
