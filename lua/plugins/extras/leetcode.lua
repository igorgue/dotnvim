return {
  "kawre/leetcode.nvim",
  lazy = false,
  build = ":TSUpdate html",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-telescope/telescope.nvim",
    "nvim-lua/plenary.nvim", -- required by telescope
    "MunifTanjim/nui.nvim",

    -- optional
    "nvim-tree/nvim-web-devicons",

    -- recommended
    -- "rcarriga/nvim-notify",
  },
  opts = {
    -- configuration goes here
  },
  config = function(_, opts)
    vim.keymap.set("n", "<leader>lq", "<cmd>LcQuestionTabs<cr>")
    vim.keymap.set("n", "<leader>lm", "<cmd>LcMenu<cr>")
    vim.keymap.set("n", "<leader>lc", "<cmd>LcConsole<cr>")
    vim.keymap.set("n", "<leader>ll", "<cmd>LcLanguage<cr>")
    vim.keymap.set("n", "<leader>ld", "<cmd>LcDescriptionToggle<cr>")

    require("leetcode").setup(opts)
  end,
}
