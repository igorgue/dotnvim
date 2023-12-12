return {
  {
    "benlubas/molten-nvim",
    build = ":UpdateRemotePlugins",
    lazy = false, -- TODO: Figure out why this cannot lazy load...
    dependencies = {
      {
        "3rd/image.nvim",
        event = "VeryLazy",
        init = function()
          package.path = package.path .. ";" .. vim.fn.expand("$HOME") .. "/.luarocks/share/lua/5.1/?/init.lua;"
          package.path = package.path .. ";" .. vim.fn.expand("$HOME") .. "/.luarocks/share/lua/5.1/?.lua;"
        end,
        opts = {
          backend = "kitty",
          integrations = {
            markdown = {
              enabled = true,
              clear_in_insert_mode = false,
              download_remote_images = true,
              only_render_image_at_cursor = false,
              filetypes = { "markdown", "vimwiki" }, -- markdown extensions (ie. quarto) can go here
            },
          },
          max_width = 100, -- tweak to preference
          max_height = 12, -- ^
          max_height_window_percentage = math.huge, -- this is necessary for a good experience
          max_width_window_percentage = math.huge,
          window_overlap_clear_enabled = true,
          window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
          kitty_method = "normal",
        },
      },
    },
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
