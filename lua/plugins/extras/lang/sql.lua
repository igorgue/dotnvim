return {
  {
    "tpope/vim-dadbod",
    cmd = { "DBUI", "DBUIToggle" },
    dependencies = {
      "kristijanhusak/vim-dadbod-ui",
      "kristijanhusak/vim-dadbod-completion",
    },
    keys = {
      { "<leader><cr>d", "<cmd>DBUIToggle<cr>", desc = "Dadbod Database Manager" },
    },
    init = function()
      vim.g.db_ui_use_nerd_fonts = true
      vim.g.db_ui_save_location = vim.fn.stdpath("data") .. "/db_ui"
      vim.g.db_ui_execute_on_save = false

      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "sql", "mysql", "plsql" },
        callback = function()
          ---@diagnostic disable-next-line: missing-fields
          require("cmp").setup.buffer({ sources = { { name = "vim-dadbod-completion" } } })
        end,
      })
    end,
  },
  {
    "jsborjesson/vim-uppercase-sql",
    ft = { "sql" },
  },
}
