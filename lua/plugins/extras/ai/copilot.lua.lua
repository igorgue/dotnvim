return {
  desc = "Github Copilot.lua (unofficial)",
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    opts = {
      filetypes = {
        ["*"] = true,
        neorepl = false,
        TelescopeResults = false,
        TelescopePrompt = false,
        yaml = true,
        markdown = true,
        gitcommit = true,
        gitrebase = true,
      },
    },
    -- FIXME: this doesn't work
    keys = {
      {
        "<C-l>",
        function()
          vim.notify("test")
        end,
        desc = "Copilot manual trigger",
        mode = "i",
      },
    },
  },
}
