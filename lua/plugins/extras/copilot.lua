return {
  {
    "L3MON4D3/LuaSnip",
    -- stylua: ignore
    keys = function() return {} end,
  },
  {
    "github/copilot.vim",
    cmd = "Copilot",
    event = { "BufReadPost", "BufNewFile" },
    init = function()
      vim.g.copilot_no_tab_remap = false
      vim.g.copilot_assume_mapped = true
      vim.g.copilot_filetypes = {
        ["*"] = true,
        TelescopeResults = false,
        TelescopePrompt = false,
      }
    end,
    keys = {
      {
        "<leader>cC",
        function()
          if vim.g.copilot_enabled == 0 then
            vim.cmd("Copilot enable")
          else
            vim.cmd("Copilot disable")
          end

          vim.cmd("Copilot status")
        end,
        desc = "Copilot toggle",
      },
    },
  },
}
