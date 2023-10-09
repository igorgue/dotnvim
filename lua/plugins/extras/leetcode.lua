return {
  "kawre/leetcode.nvim",
  lazy = false,
  build = ":TSUpdate html",
  opts = {
    lang = "python3",
  },
  config = function(_, opts)
    for _, arg in ipairs(vim.v.argv) do
      if arg == "leetcode.nvim" then
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
    end

    require("leetcode").setup(opts)
  end,
}
