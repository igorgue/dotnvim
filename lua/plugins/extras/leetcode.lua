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

        wk.add({
          { "<leader>l", group = "leetcode" },
        })

        wk.add({
          { "<leader>l<cr>", "<cmd>Leet<cr>", desc = "Menu" },
          { "<leader>lc", "<cmd>Leet console<cr>", desc = "Console" },
          { "<leader>lh", "<cmd>Leet hints<cr>", desc = "Hints" },
          { "<leader>lq", "<cmd>Leet tabs<cr>", desc = "Question Tabs" },
          { "<leader>ll", "<cmd>Leet lang<cr>", desc = "Language" },
          { "<leader>ld", "<cmd>Leet desc<cr>", desc = "Description Toggle" },
          { "<leader>lr", "<cmd>Leet run<cr>", desc = "Run" },
          { "<leader>ls", "<cmd>Leet submit<cr>", desc = "Submit" },
        })
      end

      require("leetcode").setup(opts)
    end,
  },
}
