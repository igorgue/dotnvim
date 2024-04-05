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
  },
  {
    "lewis6991/gitsigns.nvim",
    -- stylua: ignore
    enabled = not vim.o.diff,
    opts = {
      signs = {
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
    opts = {
      diff_binaries = true,
      enhanced_diff_hl = true,
      view = {
        default = {
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
    "almo7aya/openingh.nvim",
    cmd = { "OpenInGHRepo", "OpenInGHFile", "OpenInGHFileLines" },
    init = function()
      local wk = require("which-key")

      wk.register({
        ["<leader>cg"] = { name = "+github" },
      })
    end,
    keys = {
      { "<leader>cgg", "<cmd>OpenInGHFileLines<CR>", desc = "Open in GitHub file lines" },
      { "<leader>cgf", "<cmd>OpenInGHFile<CR>", desc = "Open in GitHub file" },
      { "<leader>cgr", open_github_repo, desc = "Open in GitHub repo" },
    },
  },
}
