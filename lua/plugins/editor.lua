return {
  {
    "michaeljsmith/vim-indent-object",
    event = { "BufReadPost", "BufNewFile" },
    keys = {
      { "vai", nil, desc = "An indent level and line above" },
      { "vii", nil, desc = "Inner indent level (no line above)" },
      { "vaI", nil, desc = "An indent level and lines above/below" },
      { "viI", nil, desc = "Inner indent level (no lines above/below)" },
      { "dai", nil, desc = "An indent level and line above" },
      { "dii", nil, desc = "Inner indent level (no line above)" },
      { "daI", nil, desc = "An indent level and lines above/below" },
      { "diI", nil, desc = "Inner indent level (no lines above/below)" },
      { "cai", nil, desc = "An indent level and line above" },
      { "cii", nil, desc = "Inner indent level (no line above)" },
      { "caI", nil, desc = "An indent level and lines above/below" },
      { "ciI", nil, desc = "Inner indent level (no lines above/below)" },
    },
  },
  {
    "arp242/xdg_open.vim",
    event = { "BufReadPost", "BufNewFile" },
  },
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      signs = {
        add = { text = "│" },
        change = { text = "│" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
        untracked = { text = "┆" },
      },
    },
    keys = {
      { "<leader>h", "<cmd>lua require('gitsigns').next_hunk()<cr>", desc = "Next git hunk" },
    },
  },
  {
    "sindrets/diffview.nvim",
    cmd = {
      "DiffviewOpen",
      "DiffviewClose",
      "DiffviewToggleFiles",
      "DiffviewLog",
      "DiffviewRefresh",
      "DiffviewFileHistory",
    },
    ft = { "git", "diff" },
    opts = {
      diff_binaries = true,
      enhanced_diff_hl = true,
      view = {
        default = {
          winbar_info = true,
        },
      },
    },
    keys = {
      {
        "<leader>gd",
        function()
          local view = require("diffview.lib").get_current_view()

          if view then
            vim.cmd("DiffviewClose")
          else
            vim.cmd("DiffviewOpen")
          end
        end,
        desc = "Toggle diff view",
      },
    },
  },
  {
    "echasnovski/mini.surround",
    keys = {
      { "S", [[:<C-u>lua MiniSurround.add('visual')<CR>]], desc = "Add surrounding", mode = "x" },
    },
  },
  {
    "windwp/nvim-spectre",
    opts = {
      highlight = {
        ui = "String",
        search = "IncSearch",
        replace = "DiffChange",
        border = "FloatBorder",
      },
    },
  },
  {
    "folke/which-key.nvim",
    opts = {
      window = {
        position = "top",
        -- border = "rounded",
        margin = { 0, 0, 0, 0 },
        padding = { 1, 0, 1, 0 },
        winblend = 7,
      },
    },
  },
  {
    "numToStr/Comment.nvim",
    event = { "BufReadPost", "BufNewFile" },
    config = true,
  },
  {
    "RRethy/vim-illuminate",
    opts = {
      delay = 12,
    },
    config = function(_, opts)
      require("illuminate").configure(opts)

      local function map(key, dir, buffer)
        vim.keymap.set("n", key, function()
          require("illuminate")["goto_" .. dir .. "_reference"](true)
        end, { desc = dir:sub(1, 1):upper() .. dir:sub(2) .. " Reference", buffer = buffer })
      end

      map("]]", "next")
      map("[[", "prev")

      -- also set it after loading ftplugins, since a lot overwrite [[ and ]]
      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          local buffer = vim.api.nvim_get_current_buf()
          map("]]", "next", buffer)
          map("[[", "prev", buffer)
        end,
      })

      -- re-apply colorscheme to fix highlighting
      vim.cmd("colorscheme " .. vim.g.colors_name)
    end,
  },
}
