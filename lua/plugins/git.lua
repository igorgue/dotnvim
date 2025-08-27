local function open_github_repo()
  local text = vim.fn.getline("."):match("['\"]([^'\"]+)['\"]")

  if text == nil or text == "" or not text:match("/") then
    vim.cmd("OpenInGHRepo")
    return
  end

  vim.fn.jobstart({ "xdg-open", "https://github.com/" .. text }, { detach = true })
end

return {
  {
    "tpope/vim-fugitive",
    cmd = {
      "Git",
      "Gread",
      "Gwrite",
      "Gdiffsplit",
      "Gvdiffsplit",
      "Ggrep",
      "GMove",
      "GDelete",
      "GBrowse",
      "GRemove",
      "GRename",
      "Glgrep",
      "Gedit",
    },
    dependencies = {
      "tpope/vim-git",
    },
    init = function()
      vim.api.nvim_create_user_command("Gblame", "Git blame", {})
      vim.cmd("cab gb Gblame")
    end,
    keys = {
      -- stylua: ignore start
      { "<esc>", function() vim.api.nvim_input("gq") end, desc = "Quit (Fugitive)", ft = "fugitiveblame" },
      { "q", function() vim.api.nvim_input("gq") end, desc = "Quit (Fugitive)", ft = "fugitiveblame" },
      -- stylua: ignore end
      { "<leader>gdb", "<cmd>Gblame<cr>", desc = "Git Blame (Fugitive)" },
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    enabled = not vim.o.diff,
    opts = {
      signcolumn = true,
      signs = {
        add = { text = "▌" },
        change = { text = "▌" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
        untracked = { text = "┆" },
      },
      signs_staged = {
        add = { text = "▌" },
        change = { text = "▌" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
        untracked = { text = "┆" },
      },
    },
    keys = {
      { "<leader>h", "<cmd>lua require('gitsigns').next_hunk()<cr>", desc = "Next Git Hunk" },
      { "<leader>H", "<cmd>lua require('gitsigns').prev_hunk()<cr>", desc = "Prev Git Hunk" },
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
    config = function(_, opts)
      local actions = require("diffview.actions")

      opts.keymaps = {
        view = {
          {
            "n",
            "<leader>b",
            actions.focus_files,
            { desc = "Bring focus to the file panel" },
          },
          {
            "n",
            "<leader>e",
            actions.toggle_files,
            { desc = "Toggle the file panel." },
          },
        },
        file_panel = {
          {
            "n",
            "<leader>b",
            actions.focus_files,
            { desc = "Bring focus to the file panel" },
          },
          {
            "n",
            "<leader>e",
            actions.toggle_files,
            { desc = "Toggle the file panel." },
          },
        },
        file_history_panel = {
          {
            "n",
            "<leader>b",
            actions.focus_files,
            { desc = "Bring focus to the file panel" },
          },
          {
            "n",
            "<leader>e",
            actions.toggle_files,
            { desc = "Toggle the file panel." },
          },
        },
      }

      require("diffview").setup(opts)
    end,
    opts = {
      diff_binaries = true,
      enhanced_diff_hl = true,
      view = {
        default = {
          winbar_info = true,
          disable_diagnostics = true,
          winbar_info = true,
        },
      },
      hooks = {
        diff_buf_read = function()
          vim.opt_local.list = false
          vim.opt_local.wrap = false

          vim.opt_local.cursorline = true
          vim.opt_local.number = true
          vim.opt.signcolumn = "no"
        end,
        view_closed = function()
          vim.opt.signcolumn = "auto"
        end,
      },
    },
  },
  {
    "almo7aya/openingh.nvim",
    cmd = { "OpenInGHRepo", "OpenInGHFile", "OpenInGHFileLines" },
    keys = {
      { "<leader>cgo", "<cmd>OpenInGHFile<CR>", desc = "Open GitHub file" },
      {
        "<leader>cgg",
        "<cmd>OpenInGHFileLines<CR>",
        desc = "Open GitHub file lines",
      },
      { "<leader>cgr", open_github_repo, desc = "Open GitHub repo" },
      { "gh", open_github_repo, desc = "Go to GitHub repo" },
    },
  },
  {
    "Rawnly/gist.nvim",
    cmd = { "GistCreate", "GistCreateFromFile", "GistsList" },
    config = true,
    keys = {
      { "<leader>cgl", "<cmd>GistsList<cr>", desc = "List gists" },
      { "<leader>cgc", "<cmd>GistCreate<cr>", desc = "Create gist (private)" },
      {
        "<leader>cgC",
        "<cmd>GistCreate public=true<cr>",
        desc = "Create gist (public)",
      },
      {
        "<leader>cgf",
        "<cmd>GistCreateFromFile<cr>",
        desc = "Create gist from file",
      },
    },
    opts = {
      private = true,
      clipboard = "+",
    },
  },
  {
    "akinsho/git-conflict.nvim",
    enabled = not vim.o.diff,
    opts = {
      disable_diagnostics = true,
    },
    -- keys = {
    --   { 'co', '<Plug>(git-conflict-ours)', desc = 'Choose ours (git conflict)' },
    --   { 'ct', '<Plug>(git-conflict-theirs)', desc = 'Choose theirs (git conflict)' },
    --   { 'cb', '<Plug>(git-conflict-both)', desc = 'Choose both (git conflict)' },
    --   { 'c0', '<Plug>(git-conflict-none)', desc = 'Choose none (git conflict)' },
    --   { '[x', '<Plug>(git-conflict-prev-conflict)', desc = 'Prev conflict (git conflict)' },
    --   { ']x', '<Plug>(git-conflict-next-conflict)', desc = 'Next conflict (git conflict)' },
    -- }
  },
}
