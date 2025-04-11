return {
  {
    "github/copilot.vim",
    desc = "Github Copilot (official)",
    cmd = "Copilot",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      vim.g.copilot_no_tab_remap = false
      vim.g.copilot_assume_mapped = true
      vim.g.copilot_filetypes = {
        ["*"] = true,
        neorepl = false,
        TelescopeResults = false,
        TelescopePrompt = false,
      }

      vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
        pattern = "*",
        callback = function()
          vim.b.workspace_folder = vim.fn.getcwd()
        end,
      })
    end,
    keys = {
      { "<C-l>", "<Plug>(copilot-suggest)", desc = "Copilot manual trigger", mode = "i" },
    },
  },
}
