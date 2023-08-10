return {
  {
    "raimon49/requirements.txt.vim",
    event = "BufReadPre requirements*.txt",
  },
  {
    "mfussenegger/nvim-dap",
    optional = true,
    dependencies = {
      "mfussenegger/nvim-dap-python",
    },
    config = function()
      local path = require("mason-registry").get_package("debugpy"):get_install_path()

      require("dap").configurations.python = {}
      require("dap-python").setup(path .. "/venv/bin/python")
    end,
  },
  {
    "linux-cultist/venv-selector.nvim",
    ft = { "python" },
    keys = function()
      return {}
    end,
    config = function()
      local register_keys = function()
        local wk = require("which-key")
        local bufnr = vim.api.nvim_get_current_buf()

        wk.register({
          v = { "<cmd>:VenvSelect<cr>", "Select VirtualEnv" },
        }, {
          prefix = "<leader>c",
          buffer = bufnr,
        })
      end

      vim.api.nvim_create_autocmd("FileType", { pattern = { "python" }, callback = register_keys })
    end,
  },
}
