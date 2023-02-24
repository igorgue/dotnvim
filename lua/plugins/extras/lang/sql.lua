return {
  {
    "tpope/vim-dadbod",
    cmd = { "DBUI", "DBUIToggle" },
    dependencies = {
      "kristijanhusak/vim-dadbod-ui",
      "kristijanhusak/vim-dadbod-completion",
    },
    keys = {
      { "<leader><cr>d", "<cmd>DBUIToggle<cr>", desc = "Dadbod database manager" },
    },
  },
}
