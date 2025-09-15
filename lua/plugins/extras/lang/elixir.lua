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
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        elixirls = false,
        nextls = false,
        lexical = false,
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
        preference = { "expert" },
      },
    },
  },
}
