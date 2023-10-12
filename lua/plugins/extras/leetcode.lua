local has_leetcode = false
for _, arg in ipairs(vim.v.argv) do
  if arg == "leetcode.nvim" then
    has_leetcode = true
    break
  end
end

return {
  "kawre/leetcode.nvim",
  lazy = not has_leetcode,
  dependencies = {
    { "nvim-treesitter/nvim-treesitter", enabled = true },
  },
  cmd = { "LcOpen", "LcMenu", "LcConsole", "LcLanguage", "LcDescriptionToggle" },
  opts = {
    lang = "python3",
  },
  config = function(_, opts)
    if has_leetcode then
      local wk = require("which-key")

      wk.register({
        ["<leader>l"] = { name = "+leetcode" },
      })

      wk.register({
        q = { "<cmd>LcQuestionTabs<cr>", "Question Tabs" },
        m = { "<cmd>LcMenu<cr>", "Menu" },
        c = { "<cmd>LcConsole<cr>", "Console" },
        l = { "<cmd>LcLanguage<cr>", "Language" },
        d = { "<cmd>LcDescriptionToggle<cr>", "Description Toggle" },
      }, {
        prefix = "<leader>l",
      })
    end

    require("leetcode").setup(opts)
  end,
}
