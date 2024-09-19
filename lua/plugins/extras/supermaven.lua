return {
  {
    "L3MON4D3/LuaSnip",
    -- stylua: ignore
    keys = function() return {} end,
  },
  {
    "nvim-cmp",
    -- stylua: ignore
    keys = function() return {} end,
  },
  {
    "supermaven-inc/supermaven-nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      keymaps = {
        accept_suggestion = "<tab>",
        clear_suggestion = "<c-]>",
        accept_word = "<c-s-j>",
      },
      log_level = "off",
      condition = function()
        local invalid_filetypes = {
          ["copilot-chat"] = true,
          ["AvanteInput"] = true,
          ["Avante"] = true,
        }

        return invalid_filetypes[vim.bo.filetype]
      end,
      -- XXX: looks like this is not working...
      color = {
        suggestion_color = "#875fff",
        cterm = 244,
      },
    },
    keys = {
      { "<leader>am", "<cmd>SupermavenToggle<cr>", desc = "Supermaven toggle" },
    },
  },
}
