local util = require("lazyvim.util")

return {
  -- XXX: does not work...
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        mojo = {},
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    ft = { "mojo" },
    opts = function(_, opts)
      vim.treesitter.language.register("python", "mojo")

      opts.highlight.additional_vim_regex_highlighting = true

      return opts
    end,
  },
  {
    "igorgue/mojo.vim",
    -- dir = "~/Code/mojo.vim",
    ft = { "mojo" },
    init = function()
      local function format_mojo()
        if require("lazyvim.plugins.lsp.format").enabled() then
          vim.cmd("silent! !mojo format --quiet " .. vim.fn.expand("%:p"))
        end
      end

      -- TODO: Fix this, runs on buf write pre and that shows an error
      -- require("lazyvim.util").on_very_lazy(function()
      --   require("lazyvim.plugins.lsp.format").custom_format = function(_)
      --     format_mojo()
      --     return true
      --   end
      -- end)

      vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        pattern = { "*.🔥", "*.mojo" },
        nested = true,
        callback = format_mojo,
      })

      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "*",
        callback = function()
          local ns = vim.api.nvim_create_namespace("mojo")

          vim.api.nvim_set_hl_ns(ns)

          vim.api.nvim_set_hl(ns, "@variable.python", {})
          vim.api.nvim_set_hl(ns, "@error.python", {})
          vim.api.nvim_set_hl(ns, "@repeat.python", {})
        end,
      })

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "mojo",
        callback = function()
          vim.bo.expandtab = true
          vim.bo.shiftwidth = 4
          vim.bo.softtabstop = 4
          vim.bo.tabstop = 4
          vim.bo.commentstring = "# %s"

          vim.lsp.start({
            name = "mojo",
            cmd = { "mojo-lsp-server" },
            filetypes = { "mojo" },
            root_dir = util.get_root(),
          })
        end,
      })
    end,
  },
  {
    "mfussenegger/nvim-dap",
    optional = true,
    dependencies = { "igorgue/mojo.vim" },
    opts = function()
      local dap = require("dap")
      dap.adapters.mojo = {
        type = "executable",
        command = "lldb-vscode",
        name = "mojo-lldb",
      }

      dap.configurations.mojo = {}
      require("dap.ext.vscode").load_launchjs()
    end,
  },
}
