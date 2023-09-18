return {
  {
    "nvimdev/lspsaga.nvim",
    lazy = false,
    config = function(_, opts)
      require("lspsaga").setup(opts)
    end,
    opts = {
      callhierarchy = { silent = true, keys = { quit = "<Esc>" } },
      finder = { silent = true, keys = { quit = "<Esc>" } },
      hover = { silent = true, keys = { quit = "<Esc>" } },
      definition = { silent = true, keys = { quit = "<Esc>" } },
      lightbulb = { enable = false },
      code_action = { enable = false },
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
