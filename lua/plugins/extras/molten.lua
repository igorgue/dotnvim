return {
  {
    "benlubas/molten-nvim",
    build = ":UpdateRemotePlugins",
    lazy = false,
    -- dependencies = {
    --   {
    --     "3rd/image.nvim",
    --     lazy = false,
    --     opts = {
    --       backend = "kitty",
    --       processor = "magick_cli", -- or "magick_rock"
    --       integrations = {
    --         markdown = {
    --           enabled = true,
    --           clear_in_insert_mode = false,
    --           download_remote_images = true,
    --           only_render_image_at_cursor = false,
    --           floating_windows = false, -- if true, images will be rendered in floating markdown windows
    --           filetypes = { "markdown", "vimwiki" }, -- markdown extensions (ie. quarto) can go here
    --         },
    --         neorg = {
    --           enabled = true,
    --           filetypes = { "norg" },
    --         },
    --         typst = {
    --           enabled = true,
    --           filetypes = { "typst" },
    --         },
    --         html = {
    --           enabled = false,
    --         },
    --         css = {
    --           enabled = false,
    --         },
    --       },
    --       max_width = 100,
    --      max_height = 12,
    --       max_width_window_percentage = math.huge,
    --       max_height_window_percentage = math.huge,
    --       window_overlap_clear_enabled = false, -- toggles images when windows are overlapped
    --       window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
    --       editor_only_render_when_focused = false, -- auto show/hide images when the editor gains/looses focus
    --       tmux_show_only_in_active_window = false, -- auto show/hide images in the correct Tmux window (needs visual-activity off)
    --       hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" }, -- render image files as images when opened
    --     },
    --   },
    -- },
    init = function()
      vim.g.molten_image_provider = "image.nvim"
      vim.g.molten_output_win_max_height = 20
      vim.g.molten_auto_open_output = false
    end,
    cmd = { "MoltenInit" },
    keys = {
      { "<leader>mi", "<cmd>MoltenInit<cr>", desc = "Molten init" },
      { "<leader>mR", "<cmd>MoltenRestart<cr>", desc = "Molten restart" },
      { "<leader>mO", "<cmd>MoltenEvaluateOperator<cr>", desc = "Molten evaluate operator" },
      { "<leader>ml", "<cmd>MoltenEvaluateLine<cr>", desc = "Molten evaluate line" },
      { "<leader>mc", "<cmd>MoltenReevaluateCell<cr>", desc = "Molten re-evaluate cell" },
      { "<leader>mr", ":<C-u>MoltenEvaluateVisual<cr>", desc = "Molten evaluate visual", mode = "x" },
      { "<leader>mo", "<cmd>noautocmd MoltenEnterOutput<cr>", desc = "Molten enter output" },
      { "<c-cr>", "<cmd>MoltenEvaluateLine<cr>", desc = "Molten evaluate line" },
      { "<c-cr>", ":<C-u>MoltenEvaluateVisual<cr>gv", desc = "Molten evaluate visual", mode = "x" },
    },
  },
}
