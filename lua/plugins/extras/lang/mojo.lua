local util = require("lazyvim.util")

return {
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

      -- TODO: Figure out how to make this function work,
      -- currently asks for a "text replacement"?
      -- if this works you don't need to do the BufWritePost below
      -- require("lazyvim.plugins.lsp.format").format = format_mojo

      vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        pattern = { "*.🔥", "*.mojo" },
        nested = true,
        callback = format_mojo,
      })

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "mojo",
        callback = function()
          vim.bo.expandtab = true
          vim.bo.shiftwidth = 4
          vim.bo.softtabstop = 4
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
    dependencies = {
      "igorgue/mojo.vim",
    },
    opts = function()
      local dap = require("dap")
      local mojo_lldb = vim.env.MODULAR_HOME .. "/pkg/packages.modular.com_mojo/bin/lldb-vscode"

      dap.adapters.mojo = {
        type = "executable",
        command = mojo_lldb,
        name = "mojo_lldb",
      }

      local lldb_config = {
        type = "mojo",
        name = "Run Mojo Program",
        request = "launch",
        program = function()
          ---@diagnostic disable-next-line: redundant-parameter
          return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
        args = {},
        runInTerminal = false,
      }

      dap.configurations.mojo = {
        lldb_config,
      }
    end,
  },
}
