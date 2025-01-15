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
        { "<a-n>", function() Snacks.words.jump(vim.v.count1, true) end, has = "documentHighlight", desc = "Next Reference", cond = function() return Snacks.words.is_enabled() end },
        { "<a-p>", function() Snacks.words.jump(-vim.v.count1, true) end, has = "documentHighlight", desc = "Prev Reference", cond = function() return Snacks.words.is_enabled() end },
        { "<c-s-k>", function() return vim.lsp.buf.signature_help() end, mode = "i", desc = "Signature Help", has = "signatureHelp" },
        { "]]", function() Snacks.words.jump(vim.v.count1) end, has = "documentHighlight", desc = "Next Reference", cond = function() return Snacks.words.is_enabled() end },
        { "[[", function() Snacks.words.jump(-vim.v.count1) end, has = "documentHighlight", desc = "Prev Reference", cond = function() return Snacks.words.is_enabled() end },
        { "gD", vim.lsp.buf.declaration, desc = "Goto Declaration" },
        -- { "gd", function() require("telescope.builtin").lsp_definitions({ reuse_win = true }) end, desc = "Goto Definition", has = "definition" },
        { "gd", vim.lsp.buf.definition, desc = "Goto Definition", has = "definition" },
        -- { "gI", function() require("telescope.builtin").lsp_implementations({ reuse_win = true }) end, desc = "Goto Implementation" },
        { "gI", vim.lsp.buf.implementation, desc = "Goto Implementation" },
        { "gK", function() return vim.lsp.buf.signature_help() end, desc = "Signature Help", has = "signatureHelp" },
        { "gR", function() require("telescope.builtin").lsp_references({ reuse_win = true }) end, desc = "References" },
        { "gr", vim.lsp.buf.references, desc = "References", nowait = true },
        { "gt", function() require("telescope.builtin").lsp_type_definitions({ reuse_win = true }) end, desc = "Goto T[y]pe Definition" },
        { "gy", vim.lsp.buf.type_definition, desc = "Goto T[y]pe Definition" },
        { "K", function() return vim.lsp.buf.hover() end, desc = "Hover" },
        { "<leader>cA", LazyVim.lsp.action.source, desc = "Source Action", has = "codeAction" },
        { "<leader>ca", vim.lsp.buf.code_action, desc = "Code Action", mode = { "n", "v" }, has = "codeAction" },
        { "<leader>cC", vim.lsp.codelens.refresh, desc = "Refresh & Display Codelens", mode = { "n" }, has = "codeLens" },
        { "<leader>cc", vim.lsp.codelens.run, desc = "Run Codelens", mode = { "n", "v" }, has = "codeLens" },
        { "<leader>cd", vim.diagnostic.open_float, desc = "Line Diagnostics" },
        { "<leader>cf", function() format({force = true}) end, desc = "Format Document", has = "documentFormatting" },
        { "<leader>cf", function() format({force = true}) end, desc = "Format Range", mode = "v", has = "documentRangeFormatting" },
        { "<leader>ci", "<cmd>LspInfo<cr>", desc = "Lsp Info" },
        { "<leader>cR", function() Snacks.rename.rename_file() end, desc = "Rename File", mode ={"n"}, has = { "workspace/didRenameFiles", "workspace/willRenameFiles" } },
        { "<leader>cr", vim.lsp.buf.rename, desc = "Rename", has = "rename" },
      }

      ui_windows.default_options.border = "rounded"

      opts.format = { timeout_ms = 5000 }
      opts.inlay_hints = { enabled = false }

      return opts
    end,
  },
}
