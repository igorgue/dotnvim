if vim.fn.has("nvim-0.12") == 0 then
  return {
    desc = "GitHub Copilot with Neovim 0.12+ native LSP",
    { import = "lazyvim.plugins.extras.ai.copilot-native" },
    {
      "github/copilot.vim",
      cmd = "Copilot",
      lazy = false,
      config = function()
        vim.g.copilot_no_tab_remap = false
        vim.g.copilot_assume_mapped = false
        vim.g.copilot_filetypes = {
          codecompanion = true,
        }

        vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
          pattern = "codecompanion",
          callback = function()
            vim.b.workspace_folder = vim.fn.getcwd()
          end,
        })
      end,
      keys = {
        { "<C-l>", "<Plug>(copilot-suggest)", desc = "Copilot manual trigger", mode = "i", ft = "codecompanion" },
        { "<M-left>", "<C-w>", desc = "Remove last word", mode = "i", ft = "codecompanion" },
        {
          "<M-up>",
          'copilot#Accept("\\<CR>")',
          desc = "Accept suggestion",
          mode = "i",
          expr = true,
          silent = true,
          replace_keycodes = false,
          ft = "codecompanion",
        },
        { "<M-down>", "<C-o>u", desc = "Undo", mode = "i", ft = "codecompanion" },
      },
    },
  }
else
  return {
    desc = "GitHub Copilot (official)",
    { import = "plugins.extras.ai.copilot" },
    "github/copilot.vim",
  }
end
