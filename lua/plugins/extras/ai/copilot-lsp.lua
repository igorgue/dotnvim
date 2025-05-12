return {
  desc = "Copilot LSP (Next Edit Completion)",
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "copilot-language-server",
      },
    },
  },
  {
    "copilotlsp-nvim/copilot-lsp",
    lazy = false,
    init = function()
      vim.g.copilot_nes_debounce = 500
      vim.lsp.enable("copilot")
    end,
    keys = {
      {
        "<leader><tab>a",
        function()
          require("copilot-lsp.nes").apply_pending_nes()
        end,
        desc = "Copilot Next Edit Completion",
      },
      {
        "<leader><tab>r",
        function()
          local ns = vim.api.nvim_get_namespaces()["copilot-nes"]
          local nes_ui = require("copilot-lsp.nes.ui")
          local bufnr = vim.api.nvim_get_current_buf()

          nes_ui.clear_suggestion(bufnr, ns)
        end,
        desc = "Copilot Next Edit Completion",
      },
    },
  },
}
