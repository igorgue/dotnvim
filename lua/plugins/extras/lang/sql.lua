local sql_ft = { "sql", "mysql", "plsql" }

return {
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "sql" })
      end
    end,
  },
  {
    "folke/edgy.nvim",
    optional = true,
    opts = function(_, opts)
      table.insert(opts.right, {
        title = "Database",
        ft = "dbui",
        pinned = true,
        open = function()
          vim.cmd("DBUI")
        end,
      })

      table.insert(opts.bottom, {
        title = "DB Query Result",
        ft = "dbout",
      })
    end,
  },
  {
    "tpope/vim-dadbod",
    cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
    dependencies = {
      "kristijanhusak/vim-dadbod-ui",
      { "kristijanhusak/vim-dadbod-completion", ft = sql_ft },
      { "jsborjesson/vim-uppercase-sql", ft = sql_ft },
    },
    keys = {
      { "<leader><cr>d", "<cmd>DBUIToggle<cr>", desc = "Dadbod Database Manager" },
    },
    init = function()
      vim.g.db_ui_use_nerd_fonts = true
      vim.g.db_ui_save_location = vim.fn.stdpath("data") .. "/db_ui"
      vim.g.db_ui_execute_on_save = false
      vim.g.db_ui_use_nvim_notify = true

      vim.api.nvim_create_autocmd("FileType", {
        pattern = sql_ft,
        callback = function()
          ---@diagnostic disable-next-line: missing-fields
          require("cmp").setup.buffer({ sources = { { name = "vim-dadbod-completion" } } })
        end,
      })
    end,
  },
}
