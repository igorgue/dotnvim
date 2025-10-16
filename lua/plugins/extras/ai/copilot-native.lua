vim.g.copilot_native = true

if vim.fn.has("nvim-0.12") == 1 then
  return {
    desc = "GitHub Copilot with Neovim 0.12+ native LSP",
    { import = "lazyvim.plugins.extras.ai.copilot-native" },
    {
      "github/copilot.vim",
      cmd = "Copilot",
      lazy = false,
      config = function()
        vim.g.copilot_no_tab_map = true
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
        {
          "<Tab>",
          'copilot#Accept("\\<CR>")',
          desc = "Accept suggestion",
          mode = "i",
          expr = true,
          silent = true,
          replace_keycodes = false,
          ft = "codecompanion",
        },
        { "<M-[", "<Plug>(copilot-previous)", desc = "Previous suggestion", mode = "i", ft = "codecompanion" },
        { "<M-]>", "<Plug>(copilot-next)", desc = "Next suggestion", mode = "i", ft = "codecompanion" },
        { "<C-]>", "<Plug>(copilot-dismiss)", desc = "Dismiss suggestion", mode = "i", ft = "codecompanion" },
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
