vim.api.nvim_create_autocmd("FileType", {
  pattern = "nim",
  callback = function()
    vim.bo.tabstop = 2
    vim.bo.softtabstop = 2
    vim.bo.shiftwidth = 2
    vim.bo.expandtab = true

    vim.lsp.start({
      init_options = {},
      name = "nim",
      filetypes = { "nim" },
      cmd = { "nimlangserver" },
      root_dir = vim.fn.getcwd(),
      single_file_support = true,
      settings = {
        nim = {},
      },
    })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "nim",
  callback = function()
    vim.opt_local.foldignore = "#"
    vim.opt_local.foldmethod = "manual"
  end,
})

return {
  -- FIXME: Using latest version of nim-langserver
  -- included from nim itself
  -- {
  --   "neovim/nvim-lspconfig",
  --   ft = { "nim" },
  --   opts = function(_, opts)
  --     opts.servers = {
  --       nim_langserver = {},
  --     }
  --   end,
  -- },
  {
    "alaviss/nim.nvim",
    ft = { "nim" },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "nim", "nim_format_string" })
      else
        opts.ensure_installed = { "nim", "nim_format_string" }
      end
    end,
  },
  {
    "mfussenegger/nvim-dap",
    opts = function()
      local dap = require("dap")
      dap.configurations["nim"] = {
        {
          type = "codelldb",
          request = "launch",
          name = "Run Nim program",
          program = function()
            vim.cmd("!nimble build")
            local command = "fd . -t x"
            local bin_location = io.popen(command, "r")

            if bin_location ~= nil then
              return vim.fn.getcwd() .. "/" .. bin_location:read("*a"):gsub("[\n\r]", "")
            else
              return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
            end
          end,
          args = function()
            if vim.g.nim_dap_argv ~= nil then
              return vim.g.nim_dap_argv
            end

            local argv = {}

            arg = vim.fn.input(string.format("Arguments: "))

            for a in string.gmatch(arg, "%S+") do
              table.insert(argv, a)
            end

            vim.g.nim_dap_argv = argv

            return argv
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
        },
        {
          type = "codelldb",
          request = "launch",
          name = "Run Nim program (new args)",
          program = function()
            vim.cmd("make")
            local command = "fd . -t x ."
            local bin_location = io.popen(command, "r")

            if bin_location ~= nil then
              return vim.fn.getcwd() .. "/" .. bin_location:read("*a"):gsub("[\n\r]", "")
            else
              return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
            end
          end,
          args = function()
            local argv = {}

            arg = vim.fn.input(string.format("New Arguments: "))

            for a in string.gmatch(arg, "%S+") do
              table.insert(argv, a)
            end

            vim.g.nim_dap_argv = argv

            return argv
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
        },
        {
          type = "codelldb",
          request = "attach",
          name = "Attach to process",
          pid = require("dap.utils").pick_process,
          cwd = "${workspaceFolder}",
        },
      }
    end,
  },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        ["nim"] = { "nimpretty" },
      },
    },
  },
}
