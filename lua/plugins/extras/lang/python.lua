return {
  {
    "raimon49/requirements.txt.vim",
    event = "BufReadPre requirements*.txt",
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
    ft = "python",
    opts = {
      highlight = {
        disable = { "python" },
      },
      indent = {
        disable = { "python" },
      },
    },
  },
  -- NOTE: working only if lazy is false
  { "wookayin/semshi", lazy = false },
  -- NOTE: forked from wookayin's removed hardcoded values
  { "igorgue/vim-python-enhanced-syntax", ft = "python" },
}
