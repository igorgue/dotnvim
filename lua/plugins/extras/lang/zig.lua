-- NOTE: This uses the path zls to use zig devel version,
-- should also work with Mason's version
vim.api.nvim_create_autocmd("FileType", {
  pattern = "zig",
  callback = function()
    vim.bo.tabstop = 4
    vim.bo.softtabstop = 4
    vim.bo.shiftwidth = 4
    vim.bo.expandtab = true

    vim.lsp.start({
      init_options = {},
      name = "zls",
      filetypes = { { "zig", "zir" } },
      cmd = { "zls" },
      root_dir = vim.fn.getcwd(),
      single_file_support = true,
      settings = {
        zls = {
          semantic_tokens = "full",
          warn_style = true,
          highlight_global_var_declarations = true,
          enable_snippets = true,
          enable_autofix = true,
          -- NOTE: never seen an inlay hint
          -- and I don't know what record_session does
          -- nor dangerous_comptime_experiments_do_not_enable...
          enable_inlay_hints = true,
          inlay_hints_show_builtin = true,
          inlay_hints_exclude_single_argument = true,
          inlay_hints_hide_redundant_param_names = true,
          inlay_hints_hide_redundant_param_names_last_token = true,
          skip_std_references = true,
          record_session = true,
        },
      },
    })
  end,
})

return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "zig" })
      else
        opts.ensure_installed = { "zig" }
      end
    end,
  },
  {
    "ziglang/zig.vim",
    ft = { "zig" },
    init = function()
      vim.g.zig_fmt_autosave = 0 -- handled by lsp
    end,
  },
  {
    "mfussenegger/nvim-dap",
    opts = function()
      local dap = require("dap")
      dap.configurations["zig"] = {
        {
          type = "codelldb",
          request = "launch",
          name = "Run Zig program",
          program = function()
            vim.cmd("make")
            local command = "fd . -t x zig-out/bin/"
            local bin_location = io.popen(command, "r")

            if bin_location ~= nil then
              return vim.fn.getcwd() .. "/" .. bin_location:read("*a"):gsub("[\n\r]", "")
            else
              return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
            end
          end,
          args = function()
            if vim.g.zig_dap_argv ~= nil then
              return vim.g.zig_dap_argv
            end

            local argv = {}

            arg = vim.fn.input(string.format("Arguments: "))

            for a in string.gmatch(arg, "%S+") do
              table.insert(argv, a)
            end

            vim.g.zig_dap_argv = argv

            return argv
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
        },
        {
          type = "codelldb",
          request = "launch",
          name = "Run Zig program (new args)",
          program = function()
            vim.cmd("make")
            local command = "fd . -t x zig-out/bin/"
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

            vim.g.zig_dap_argv = argv

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
    "nvim-neotest/neotest",
    optional = true,
    dependencies = {
      "lawrence-laz/neotest-zig",
    },
    opts = {
      adapters = {
        ["neotest-zig"] = {},
      },
    },
  },
  -- TODO: Use these when Zig 0.12 is released
  -- {
  --   "williamboman/mason.nvim",
  --   optional = true,
  --   opts = function(_, opts)
  --     if type(opts.ensure_installed) == "table" then
  --       vim.list_extend(opts.ensure_installed, { "zls", "codelldb" })
  --     end
  --   end,
  -- },
  -- {
  --   "neovim/nvim-lspconfig",
  --   opts = {
  --     servers = {
  --       zls = {},
  --       -- settings = {
  --       --   semantic_tokens = "full",
  --       --   warn_style = false,
  --       --   highlight_global_var_declarations = false,
  --       --   -- NOTE: never seen an inlay hint
  --       --   -- and I don't know what record_session does
  --       --   -- nor dangerous_comptime_experiments_do_not_enable...
  --       --   -- enable_inlay_hints = true,
  --       --   -- inlay_hints_show_builtin = true,
  --       --   -- inlay_hints_exclude_single_argument = true,
  --       --   -- inlay_hints_hide_redundant_param_names = true,
  --       --   -- inlay_hints_hide_redundant_param_names_last_token = true,
  --       --   -- dangerous_comptime_experiments_do_not_enable = true,
  --       --   -- skip_std_references = true,
  --       --   -- record_session = true,
  --       -- },
  --       -- },
  --     },
  --   },
  -- },
}
