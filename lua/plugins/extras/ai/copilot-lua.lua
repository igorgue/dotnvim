vim.g.ai_cmp = true

return {
  desc = "Copilot Native Lua (unofficial)",
  { "folke/lazy.nvim" },
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    opts = {
      server = { type = "binary" },
      filetypes = {
        neorepl = false,
        TelescopeResults = false,
        TelescopePrompt = false,
        yaml = true,
        markdown = true,
        gitcommit = true,
        gitrebase = true,
        codecompanion = true,
      },
    },
    keys = {
      {
        "<C-l>",
        function()
          if require("copilot.client").is_disabled() then
            vim.cmd("Copilot enable")

            vim.defer_fn(function()
              require("copilot.suggestion").next()
            end, 250)
          else
            require("copilot.suggestion").next()
          end
        end,
        mode = "i",
        desc = "Copilot manual trigger",
      },
    },
  },
}
