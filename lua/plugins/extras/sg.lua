return {
  desc = "Sourcegraph",
  {
    "saghen/blink.cmp",
    optional = true,
    dependencies = {
      "sourcegraph/sg.nvim",
    },
    opts = {
      sources = {
        default = { "cody" },
        providers = {
          cody = {
            name = "cody",
            module = "blink.compat.source",
            opts = {},
          },
        },
      },
    },
  },
  {
    "hrsh7th/nvim-cmp",
    optional = true,
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
      {
        "nvim-telescope/telescope.nvim",
        optional = true,
        keys = {
          {
            "<leader>se",
            function()
              require("sg.extensions.telescope").fuzzy_search_results()
            end,
            desc = "Sourcegraph search",
          },
        },
      },
    },
    lazy = false,
    opts = {
      on_attach = require("lazyvim.util").lsp.on_attach,
    },
    keys = {
      { "<leader>ai", "<cmd>CodyToggle<cr>", desc = "Cody toggle" },
    },
  },
}
