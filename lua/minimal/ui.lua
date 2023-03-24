local lazyvim_util = require("lazyvim.util")

return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-telescope/telescope-smart-history.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
      "danielfalk/smart-open.nvim",
      "ghassan0/telescope-glyph.nvim",
      "kkharji/sqlite.lua",
      "nvim-telescope/telescope-symbols.nvim",
      "xiyaowong/telescope-emoji.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
    },
    -- stylua: ignore
    cond = function() return not vim.o.diff end,
    opts = function()
      local actions = require("telescope.actions")
      local themes = require("telescope.themes")

      local function telescope_paste_char(char)
        vim.api.nvim_put({ char.value }, "c", true, true)
      end

      return {
        defaults = {
          prompt_prefix = "   ",
          selection_caret = "   ",
          mappings = {
            i = {
              ["<esc>"] = actions.close,
              ["<C-c>"] = actions.close,
              ["<C-j>"] = actions.cycle_history_next,
              ["<C-k>"] = actions.cycle_history_prev,
              ["<C-b>"] = actions.preview_scrolling_up,
              ["<C-f>"] = actions.preview_scrolling_down,
            },
          },
          layout_config = {
            prompt_position = "top",
          },
          history = {
            path = vim.fn.stdpath("data") .. "/smart_history.sqlite3",
            cycle_wrap = true,
            limit = 100,
          },
          -- borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" }, -- rounded
          borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" }, -- straight
        },
        extensions = {
          emoji = {
            action = telescope_paste_char,
          },
          glyph = {
            action = telescope_paste_char,
          },
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
          ["ui-select"] = {
            themes.get_dropdown({
              -- borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" }, -- rounded
              borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" }, -- straight
            }),
          },
        },
      }
    end,
    config = function(_, opts)
      local telescope = require("telescope")
      local wk = require("which-key")

      wk.register({
        ["<leader><leader>"] = { "<cmd>Telescope smart_open<cr>", "Smart open" },
      })

      telescope.setup(opts)

      telescope.load_extension("notify")
      telescope.load_extension("ui-select")
      telescope.load_extension("glyph")
      telescope.load_extension("emoji")
      telescope.load_extension("smart_open")
      telescope.load_extension("fzf")

      if package.loaded["noice"] then
        telescope.load_extension("noice")
      end
    end,
    keys = {
      { "<leader>o", "<cmd>Telescope smart_open<cr>", desc = "Smart Open" },
      { "<leader><leader>", nil, desc = "Smart Open" },
      { "<leader>fs", "<cmd>Telescope smart_open<cr>", desc = "Smart Open" },
      { "<leader>ss", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Goto Symbol" },
      { "<leader>sS", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", desc = "Goto Symbol (Workspace)" },
    },
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ui = {
        border = "single",
        winhighlight = "Normal:Normal,FloatBorder:VertSplit,CursorLine:CursorLine,Search:Search",
      },
    },
  },
}
