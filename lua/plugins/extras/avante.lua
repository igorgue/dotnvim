return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    -- still accessible via ctrl+;
    -- stylua: ignore
    keys = function() return {} end,
  },
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    build = "make",
    dependencies = {
      "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below is optional, make sure to setup it properly if you have lazy=true
      {
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
      {
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
          },
        },
        keys = {
          -- suggested keymap
          { "<leader>P", "<cmd>PasteImage<cr>", desc = "Paste image from system clipboard" },
        },
      },
    },
    opts = {
      provider = "openai",
      openai = {
        model = "gpt-4o",
      },
      hints = { enabled = false },
    },
  },
}
