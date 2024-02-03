return {
  {
    "sourcegraph/sg.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
    lazy = false,
    build = "nvim -l build/init.lua",
    opts = {
      on_attach = require("lazyvim.util").lsp.on_attach,
    },
    keys = {
      {
        "<leader>css",
        function()
          require("sg.extensions.telescope").fuzzy_search_results()
        end,
        desc = "Sourcegraph search",
      },
      {
        "<leader>csc",
        "<cmd>CodyToggle<cr>",
        desc = "Cody toggle",
        mode = { "n" },
      },
    },
  },
}
