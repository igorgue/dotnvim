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
      local ui_windows = require("lspconfig.ui.windows")
      local format = require("lazyvim.util").format.format
      local Keys = require("lazyvim.plugins.lsp.keymaps").get()

      -- stylua: ignore
      vim.list_extend(Keys, {
        { "<c-s-k>", function() return vim.lsp.buf.signature_help() end, mode = "i", desc = "Signature Help", has = "signatureHelp" },
        { "gR", function() require("telescope.builtin").lsp_references({ reuse_win = true }) end, desc = "References" },
        { "gt", function() require("telescope.builtin").lsp_type_definitions({ reuse_win = true }) end, desc = "Goto T[y]pe Definition" },
        { "<leader>cd", vim.diagnostic.open_float, desc = "Line Diagnostics" },
        { "<leader>cf", function() format({force = true}) end, desc = "Format Range", mode = "v", has = "documentRangeFormatting" },
        { "<leader>ci", "<cmd>LspInfo<cr>", desc = "Lsp Info" },
      })

      ui_windows.default_options.border = "rounded"

      opts.format = { timeout_ms = 5000 }
      opts.inlay_hints = { enabled = false }

      return opts
    end,
  },
}
