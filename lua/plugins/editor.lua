return {
  {
    "michaeljsmith/vim-indent-object",
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
    },
  },
  {
    "arp242/xdg_open.vim",
    keys = {
      { "gx", nil, desc = "Open With xdg-open" },
    },
  },
  {
    "mattn/webapi-vim",
    event = { "BufReadPost", "BufNewFile" },
  },
  {
    "s1n7ax/nvim-window-picker",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("window-picker").setup()
    end,
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
      { "<leader>cgg", "<cmd>OpenInGHFileLines<CR>", desc = "Open in GitHub File Lines" },
      { "<leader>cgr", "<cmd>OpenInGHRepo<CR>", desc = "Open in GitHub Repo" },
      { "<leader>cgf", "<cmd>OpenInGHFile<CR>", desc = "Open in GitHub File" },
    },
  },
  {
    "echasnovski/mini.surround",
    keys = {
      { "S", [[:<C-u>lua MiniSurround.add('visual')<CR>]], desc = "Add Surrounding", mode = "x" },
    },
  },
  {
    "nvim-pack/nvim-spectre",
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
    "numToStr/Comment.nvim",
    event = { "BufReadPost", "BufNewFile" },
    config = true,
  },
  {
    "RRethy/vim-illuminate",
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
    opts = {
      delay = 250,
      providers = {
        "lsp",
        "treesitter",
        "regex",
      },
      min_count_to_highlight = 2,
      filetypes_denylist = {
        "alpha",
        "dbui",
        "DiffviewFileHistory",
        "DiffviewFiles",
        "dirbuf",
        "dirvish",
        "DressingSelect",
        "fugitive",
        "fugitive",
        "git",
        "lazy",
        "lir",
        "lspinfo",
        "mason",
        "minifiles",
        "neogitstatus",
        "neo-tree",
        "notify",
        "NvimTree",
        "Outline",
        "packer",
        "SidebarNvim",
        "spectre_panel",
        "spectre_panel",
        "TelescopePrompt",
        "TelescopePrompt",
        "toggleterm",
        "toggleterm",
        "Trouble",
      },
    },
  },
}
