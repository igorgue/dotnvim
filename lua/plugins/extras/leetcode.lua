local has_leetcode = false
for _, arg in ipairs(vim.v.argv) do
  if arg == "leetcode.nvim" then
    has_leetcode = true
    break
  end
end

return {
  desc = "Leetcode",
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "VeryLazy", "LazyFile" },
    opts = function()
      return {
        highlight = {
          enable = true,
          disable = false,
        },
        indent = {
          enable = true,
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<C-space>",
            node_incremental = "<C-space>",
            scope_incremental = true,
            node_decremental = "<bs>",
          },
        },
      }
    end,
  },
  {
    "kawre/leetcode.nvim",
    lazy = not has_leetcode,
    cmd = { "Leet" },
    opts = {
      lang = "python3",
    },
    config = function(_, opts)
      if has_leetcode then
        local wk = require("which-key")

        -- NOTE: for some reason you need to wait
        -- for the whichkey menu for this keybind to work
        -- probably cause LazyVim sets this up with
        -- after with the nvim api...
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
