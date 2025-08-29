vim.filetype.add({
  extension = {
    ["neex"] = "heex",
  },
})

local ok, icons = pcall(require, "nvim-web-devicons")
if ok then
  icons.set_icon({
    [".neex"] = { icon = "", color = "#916AB2", name = "Neex" },
  })
  icons.set_icon({
    neex = { icon = "", color = "#916AB2", name = "Neex" },
  })
end

vim.lsp.config("expert", {
  cmd = { "expert" },
  root_markers = { "mix.exs", ".git" },
  filetypes = { "elixir", "eelixir", "heex" },
})

vim.lsp.enable("expert")

return {
  { import = "lazyvim.plugins.extras.lang.elixir" },
  -- {
  --   "mason-org/mason.nvim",
  --   opts = {
  --     ensure_installed = {
  --       "lexical",
  --     },
  --   },
  -- },
  {
    "neovim/nvim-lspconfig",
    opts = {
      setup = {
        elixirls = function()
          return true
        end,
        nextls = function()
          return true
        end,
        expert = function()
          return true
        end,
        lexical = function()
          return true
        end,
      },
      servers = {
        -- nextls = {},
        -- lexical = {
        --   settings = {
        --     lexical = {
        --       clear_diagnostics_on_save = false,
        --     },
        --   },
        -- },
        -- expert = {
        --   cmd = { "expert" },
        --   root_dir = function(fname)
        --     return require("lspconfig").util.root_pattern("mix.exs", ".git")(fname) or vim.fn.getcwd()
        --   end,
        --   filetypes = { "elixir", "eelixir", "heex" },
        --   settings = {},
        -- },
      },
    },
  },
  {
    "mfussenegger/nvim-dap",
    optional = true,
    config = function()
      local dap = require("dap")
      local adapter = LazyVim.get_pkg_path("lexical", "libexec/lexical/bin/debug_shell.sh")

      dap.adapters.elixir = {
        type = "executable",
        command = adapter,
        args = {},
      }

      dap.configurations.elixir = {
        {
          type = "elixir",
          name = "Run Elixir Program",
          request = "launch",
          task = "phx.server",
          taskArgs = { "--trace" },
          startApps = true,
          projectDir = "${workspaceFolder}",
        },
      }
    end,
  },
  -- do not overwrite the dap adapter setup
  {
    "SmiteshP/nvim-navic",
    optional = true,
    dependencies = {
      {
        "jay-babu/mason-nvim-dap.nvim",
        optional = true,
        opts = {
          handlers = {
            elixir = function() end,
          },
        },
      },
    },
    opts = {
      lsp = {
        preference = { "lexical" },
      },
    },
  },
}
