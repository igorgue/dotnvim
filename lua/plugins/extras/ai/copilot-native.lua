vim.g.ai_cmp = true

return {
  desc = "Copilot Native Lua",
  { "folke/lazy.nvim" },
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    opts = {
      filetypes = {
        ["*"] = true,
        neorepl = false,
        TelescopeResults = false,
        TelescopePrompt = false,
        yaml = true,
        markdown = true,
        gitcommit = true,
        gitrebase = true,
        codecompanion = true,
      },
    },
  },
}
