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


      -- stylua: ignore
      keymaps._keys = {
        { "gd", function() require("telescope.builtin").lsp_definitions({ reuse_win = true }) end, desc = "Goto Definition", has = "definition" },
        { "gD", vim.lsp.buf.declaration, desc = "Goto Declaration" },
        { "gI", function() require("telescope.builtin").lsp_implementations({ reuse_win = true }) end, desc = "Goto Implementation" },
        { "K", vim.lsp.buf.hover, desc = "Hover" },
        { "gK", vim.lsp.buf.signature_help, desc = "Signature Help", has = "signatureHelp" },
        { "gr", "<cmd>Telescope lsp_references<cr>", desc = "References" },
        { "gt", function() require("telescope.builtin").lsp_type_definitions({ reuse_win = true }) end, desc = "Goto T[y]pe Definition" },
        { "<c-s-k>", vim.lsp.buf.signature_help, mode = "i", desc = "Signature Help", has = "signatureHelp" },
        { "<leader>ca", vim.lsp.buf.code_action, desc = "Code Actions", mode = { "n", "v" } },
        {
          "<leader>cA",
          function()
            vim.lsp.buf.code_action({
              context = {
                only = {
                  "source",
                },
                diagnostics = {},
              },
            })
          end,
          desc = "Source Action",
          has = "codeAction",
        },
        { "<leader>cd", vim.diagnostic.open_float, desc = "Line Diagnostics" },
        { "<leader>cf", format, desc = "Format Document", has = "documentFormatting" },
        { "<leader>cf", format, desc = "Format Range", mode = "v", has = "documentRangeFormatting" },
        { "<leader>cr", vim.lsp.buf.rename, desc = "Rename", has = "rename" },
        { "<leader>cR", LazyVim.lsp.rename_file, desc = "Rename File", mode ={"n"}, has = { "workspace/didRenameFiles", "workspace/willRenameFiles" } },
        { "<leader>ci", "<cmd>LspInfo<cr>", desc = "Lsp Info" },
        { "<leader>cl", vim.lsp.codelens.run, desc = "Run codelens" },
        { "<leader>cL", vim.lsp.codelens.refresh, desc = "Refresh & Display Codelens", mode = { "n" }, has = "codeLens" },
        { "]]", function() LazyVim.lsp.words.jump(vim.v.count1) end, has = "documentHighlight",
          desc = "Next Reference", cond = function() return LazyVim.lsp.words.enabled end },
        { "[[", function() LazyVim.lsp.words.jump(-vim.v.count1) end, has = "documentHighlight",
          desc = "Prev Reference", cond = function() return LazyVim.lsp.words.enabled end },
        { "<a-n>", function() LazyVim.lsp.words.jump(vim.v.count1, true) end, has = "documentHighlight",
          desc = "Next Reference", cond = function() return LazyVim.lsp.words.enabled end },
        { "<a-p>", function() LazyVim.lsp.words.jump(-vim.v.count1, true) end, has = "documentHighlight",
          desc = "Prev Reference", cond = function() return LazyVim.lsp.words.enabled end },
      }

      -- ui_windows.default_options.border = "single"
      ui_windows.default_options.border = "rounded"

      opts.format = { timeout_ms = 5000 }
      opts.inlay_hints = { enabled = false }

      return opts
    end,
  },
}
