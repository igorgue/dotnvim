return {
  {
    "michaeljsmith/vim-indent-object",
    event = { "BufReadPost", "BufNewFile" },
    keys = {
      { "vai", nil, desc = "An Indent Level and Line Above" },
      { "vii", nil, desc = "Inner Indent Level (No Line Above)" },
      { "vaI", nil, desc = "An Indent Level and Lines Above/Below" },
      { "viI", nil, desc = "Inner Indent Level (No Lines Above/Below)" },
      { "dai", nil, desc = "An Indent Level and Line Above" },
      { "dii", nil, desc = "Inner Indent Level (No Line Above)" },
      { "daI", nil, desc = "An Indent Level and Lines Above/Below" },
      { "diI", nil, desc = "Inner Indent Level (No Lines Above/Below)" },
      { "cai", nil, desc = "An Indent Level and Line Above" },
      { "cii", nil, desc = "Inner Indent Level (No Line Above)" },
      { "caI", nil, desc = "An Indent Level and Lines Above/Below" },
      { "ciI", nil, desc = "Inner Indent Level (No Lines Above/Below)" },
      { "<c-space>", "<cmd>normal viI<cr>", desc = "Inner Indent Level" },
      { "<c-space>", "<cmd>normal iI<cr>", desc = "Inner Indent Level", mode = "x" },
    },
  },
  {
    "nvim-mini/mini.surround",
    keys = {
      { "S", [[:<C-u>lua MiniSurround.add('visual')<CR>]], desc = "Add Surrounding", mode = "x" },
    },
  },
  {
    "chentoast/marks.nvim",
    event = "VeryLazy",
    config = true,
    keys = {
      {
        "<leader>M",
        function()
          local input = vim.fn.input("Mark to delete:")

          if input:gsub("^%s*(.-)%s*$", "%1") == "" then
            return
          end

          vim.cmd("delmarks " .. input)
        end,
        desc = "Search marks",
      },
      {
        "<leader>mm",
        function()
          if vim.g.lazyvim_picker == "telescope" then
            vim.cmd("Telescope marks")
          else
            Snacks.picker.marks()
          end
        end,
        desc = "Search marks",
      },
      { "<leader>md", "<cmd>delmarks!<cr>", desc = "Delete local marks" },
      { "<leader>mD", "<cmd>delmarks!<cr><cmd>delmarks A-Z<cr>", desc = "Delete all marks" },
    },
  },
  {
    "andymass/vim-matchup",
    event = "LazyFile",
    init = function()
      vim.g.matchup_surround_enabled = 1
      vim.g.matchup_transmute_enabled = 1
    end,
  },
}
