vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost" }, {
  callback = function()
    if next(vim.lsp.codelens.get(vim.api.nvim_get_current_buf())) ~= nil then
      vim.lsp.codelens.refresh()
    end
  end,
})

return {
  {
    "neovim/nvim-lspconfig",
    enabled = not vim.o.diff,
    opts = function(_, opts)
      local keymaps = require("lazyvim.plugins.lsp.keymaps")
      local ui_windows = require("lspconfig.ui.windows")
      local format = require("lazyvim.util").format.format

      keymaps._keys = {
        { "gd", "<cmd>Telescope lsp_definitions<cr>", desc = "Goto Definition" },
        { "gD", vim.lsp.buf.declaration, desc = "Goto Declaration" },
        { "gI", "<cmd>Telescope lsp_implementations<cr>", desc = "Goto Implementation" },
        { "gK", vim.lsp.buf.signature_help, desc = "Signature Help", has = "signatureHelp" },
        { "gr", "<cmd>Telescope lsp_references<cr>", desc = "References" },
        { "gt", "<cmd>Telescope lsp_type_definitions<cr>", desc = "Goto Type Definition" },
        { "<c-k>", vim.lsp.buf.signature_help, mode = "i", desc = "Signature Help", has = "signatureHelp" },
        { "<leader>ca", vim.lsp.buf.code_action, desc = "Code Actions", mode = { "n", "v" } },
        { "<leader>cd", vim.diagnostic.open_float, desc = "Line Diagnostics" },
        { "<leader>cf", format, desc = "Format Document", has = "documentFormatting" },
        { "<leader>cf", format, desc = "Format Range", mode = "v", has = "documentRangeFormatting" },
        { "<leader>cr", vim.lsp.buf.rename, desc = "Rename", has = "rename" },
        { "<leader>ci", "<cmd>LspInfo<cr>", desc = "Lsp Info" },
        { "<leader>cl", vim.lsp.codelens.run, desc = "Run codelens" },
      }

      -- ui_windows.default_options.border = "single"
      ui_windows.default_options.border = "rounded"

      opts.format = {
        timeout_ms = 5000,
      }

      return opts
    end,
  },
}
