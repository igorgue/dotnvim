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
      callhierarchy = { silent = true, keys = { quit = keys.quit } },
      finder = { silent = true, keys = { quit = keys.quit, toggle_or_open = keys.toggle_or_jump } },
      hover = { silent = true },
      definition = { silent = true },
      outline = { silent = true, keys = keys },
      lightbulb = { enable = false },
      code_action = { enable = false, extend_gitsigns = true },
      diagnostic = { enable = false },
      symbols_in_winbar = { enable = true, show_file = false },
    },
    keys = {
      { "<leader>k", "<Cmd>Lspsaga hover_doc<CR>", desc = "Lspsaga hover_doc" },
      { "<leader>j", "<Cmd>Lspsaga finder<CR>", desc = "Lspsaga finder" },
      { "<leader>i", "<Cmd>Lspsaga incoming_calls<CR>", desc = "Lspsaga incoming_calls" },
      { "<leader>I", "<Cmd>Lspsaga outgoing_calls<CR>", desc = "Lspsaga outgoing_calls" },
      { "<leader>p", "<Cmd>Lspsaga peek_definition<CR>", desc = "Lspsaga peek_definition" },
      { "<leader>o", "<Cmd>Lspsaga outline<CR>", desc = "Lspsaga outline" },
      { "<leader>r", "<Cmd>Lspsaga rename<CR>", desc = "Lspsaga rename" },
    },
  },
  {
    "RRethy/vim-illuminate",
    opts = {
      filetypes_denylist = {
        "sagafinder",
        "sagacallhierarchy",
        "sagahoverdoc",
        "sagaincomingcalls",
        "sagapeekdefinition",
        "sagaoutline",
        "sagarename",
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
