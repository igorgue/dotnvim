return {
  desc = "Copilot LSP",
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
  },
  {
    "saghen/blink.cmp",
    optional = true,
    opts = {
      keymap = {
        ["<Tab>"] = {
          function(cmp)
            if vim.b[vim.api.nvim_get_current_buf()].nes_state then
              cmp.hide()
              return require("copilot-lsp.nes").apply_pending_nes()
            end
            if cmp.snippet_active() then
              return cmp.accept()
            else
              return cmp.select_and_accept()
            end
          end,
          LazyVim.cmp.map({ "snippet_forward", "ai_accept" }),
          "fallback",
        },
      },
    },
  },
}
