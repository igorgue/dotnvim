return {
  desc = "Copilot LSP (Next Edit Completion)",
  {
    "williamboman/mason.nvim",
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
      vim.keymap.set("n", "<tab>", function()
        require("copilot-lsp.nes").apply_pending_nes()
      end)
    end,
    keys = {
      {
        "<tab>",
        function()
          require("copilot-lsp.nes").apply_pending_nes()
        end,
      },
    },
  },
}
