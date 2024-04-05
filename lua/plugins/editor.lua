return {
  {
    "michaeljsmith/vim-indent-object",
    keys = {
      { "vai", nil, desc = "An Indent Level and Line Above" },
      { "vii", nil, desc = "Inner Indent Level (No Line Above)" },
      { "vaI", nil, desc = "An Indent Level and Lines Above/Below" },
      { "viI", nil, desc = "Inner Indent Level (No Lines Above/Below)" },
      { "<c-space>", "<cmd>normal vii<cr>", desc = "Inner Indent Level (No Line Above)" },
      { "<c-space>", "<cmd>normal ii<cr>", desc = "Inner Indent Level (No Line Above)", mode = "x" },
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
    "echasnovski/mini.surround",
    keys = {
      { "S", [[:<C-u>lua MiniSurround.add('visual')<CR>]], desc = "Add Surrounding", mode = "x" },
    },
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
    keys = { { "<leader>uI", require("illuminate").toggle, desc = "Toggle Illuminate" } },
  },
}
