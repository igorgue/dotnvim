return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-telescope/telescope-ui-select.nvim",
    "nvim-telescope/telescope-symbols.nvim",
    "ghassan0/telescope-glyph.nvim",
    "xiyaowong/telescope-emoji.nvim",
    "xiyaowong/telescope-emoji.nvim",
  },
  lazy = true,
  opts = function(_, _)
    local actions = require("telescope.actions")
    local function telescope_paste_char(char)
      vim.api.nvim_put({ char.value }, "c", false, true)
    end

    return {
      defaults = {
        prompt_prefix = "   ",
        selection_caret = "   ",
        mappings = {
          i = {
            ["<esc>"] = actions.close,
            ["<C-c>"] = actions.close,
          },
        },
        layout_config = {
          prompt_position = "top",
        },
      },
      extensions = {
        emoji = {
          action = telescope_paste_char,
        },
        glyph = {
          action = telescope_paste_char,
        },
        ["ui-select"] = {
          require("telescope.themes").get_dropdown({}),
        },
      },
    }
  end,
  config = function(_, opts)
    local telescope = require("telescope")

    telescope.setup(opts)

    telescope.load_extension("notify")
    telescope.load_extension("ui-select")
    telescope.load_extension("noice")
    telescope.load_extension("glyph")
    telescope.load_extension("emoji")
  end,
}
