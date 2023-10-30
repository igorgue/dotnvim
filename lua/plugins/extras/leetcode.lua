local has_leetcode = false
for _, arg in ipairs(vim.v.argv) do
  if arg == "leetcode.nvim" then
    has_leetcode = true
    break
  end
end

return {
  {
    "kawre/leetcode.nvim",
    lazy = not has_leetcode,
    dependencies = {
      {
        "nvim-treesitter/nvim-treesitter",
        enabled = true,
        opts = function(_, opts)
          if type(opts.ensure_installed) == "table" then
            vim.list_extend(opts.ensure_installed, { "html" })
          end
        end,
      },
    },
    cmd = { "Leet" },
    opts = {
      lang = "python3",
    },
    config = function(_, opts)
      if has_leetcode then
        local wk = require("which-key")

        pcall(vim.api.nvim_del_keymap, "n", "<leader>l")

        wk.register({
          ["<leader>l"] = { name = "+leetcode" },
        })

        wk.register({
          ["<cr>"] = { "<cmd>Leet<cr>", "Menu" },
          c = { "<cmd>Leet console<cr>", "Console" },
          h = { "<cmd>Leet hints<cr>", "Hints" },
          q = { "<cmd>Leet tabs<cr>", "Question Tabs" },
          l = { "<cmd>Leet lang<cr>", "Language" },
          d = { "<cmd>Leet desc<cr>", "Description Toggle" },
          r = { "<cmd>Leet run<cr>", "Run" },
          s = { "<cmd>Leet submit<cr>", "Submit" },
        }, {
          prefix = "<leader>l",
        })
      end

      require("leetcode").setup(opts)
    end,
  },
}
