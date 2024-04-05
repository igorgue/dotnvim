local function fuzzy_search_results()
  require("sg.extensions.telescope").fuzzy_search_results()
end

return {
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      local cmp = require("cmp")
      opts.sources = cmp.config.sources(vim.list_extend(opts.sources, {
        { name = "cody" },
      }))
    end,
  },
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
      { "<leader>se", fuzzy_search_results, desc = "Sourcegraph search" },
      { "<leader>ai", "<cmd>CodyToggle<cr>", desc = "Cody toggle" },
      { "<C-;>", "<cmd>CodyToggle<cr>", desc = "Cody toggle", mode = { "n", "i" } },
    },
  },
}
