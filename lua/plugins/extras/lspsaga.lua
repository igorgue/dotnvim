local keys = { quit = { "<esc>", "q" }, toggle_or_jump = { "<cr>", "o" } }

return {
  {
    "nvimdev/lspsaga.nvim",
    cmd = { "Lspsaga" },
    event = "BufReadPost",
    config = function(_, opts)
      require("lspsaga").setup(opts)
    end,
    opts = {
      -- ui = { border = "single" },
      callhierarchy = { silent = true, keys = { quit = keys.quit } },
      finder = { silent = true, keys = { quit = keys.quit, toggle_or_open = keys.toggle_or_jump } },
      hover = { enable = false },
      rename = { enable = false },
      definition = { silent = true },
      outline = { silent = true, keys = keys },
      lightbulb = { enable = false },
      code_action = { enable = false, extend_gitsigns = true },
      diagnostic = { enable = false },
      symbol_in_winbar = {
        enable = vim.env.NVIM_FOCUS_MODE == nil,
        show_file = true,
        hide_keyword = false,
        folder_level = 0,
      },
    },
    keys = {
      { "<leader>j", "<Cmd>Lspsaga finder<CR>", desc = "Lspsaga finder" },
      { "<leader>p", "<Cmd>Lspsaga peek_definition<CR>", desc = "Lspsaga peek_definition" },
      { "<leader>o", "<Cmd>Lspsaga outline<CR>", desc = "Lspsaga outline" },
      { "<leader>cI", "<Cmd>Lspsaga incoming_calls<CR>", desc = "Lspsaga incoming_calls" },
      { "<leader>cO", "<Cmd>Lspsaga outgoing_calls<CR>", desc = "Lspsaga outgoing_calls" },
      { "<leader>uW", "<Cmd>Lspsaga winbar_toggle<CR>", desc = "Lspsaga winbar_toggle" },
    },
  },
  {
    "RRethy/vim-illuminate",
    opts = {
      filetypes_denylist = {
        "sagafinder",
        "sagacallhierarchy",
        "sagaincomingcalls",
        "sagapeekdefinition",
        "sagaoutline",
      },
    },
  },
  {
    "SmiteshP/nvim-navic",
    enabled = false,
  },
  {
    "simrat39/symbols-outline.nvim",
    enabled = false,
  },
}
