return {
  {
    "sourcegraph/sg.nvim",
    build = "nvim -l build/init.lua",
    opts = {
      on_attach = require("lazyvim.util").lsp.on_attach,
    },
    keys = {
      {
        "<leader>cS",
        function()
          require("sg.extensions.telescope").fuzzy_search_results()
        end,
        desc = "Sourcegraph search",
      },
    },
  },
}
