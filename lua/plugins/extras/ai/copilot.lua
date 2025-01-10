return {
  desc = "Github Copilot (official)",
  {
    "L3MON4D3/LuaSnip",
    optional = true,
    -- stylua: ignore
    keys = function() return {} end,
  },
  {
    "nvim-cmp",
    optional = true,
    -- stylua: ignore
    keys = function() return {} end,
  },
  {
    "github/copilot.vim",
    cmd = "Copilot",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      vim.g.copilot_no_tab_remap = false
      vim.g.copilot_assume_mapped = true
      vim.g.copilot_filetypes = {
        ["*"] = true,
        neorepl = false,
        TelescopeResults = false,
        TelescopePrompt = false,
      }

      vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
        pattern = "*",
        callback = function()
          vim.b.workspace_folder = vim.fn.getcwd()
        end,
      })

      Snacks.toggle({
        name = "Github Copilot (official)",
        get = function()
          return vim.api.nvim_call_function("g:copilot#Enabled", {}) ~= 0
        end,
        set = function(state)
          if state then
            vim.cmd("Copilot enable")
          else
            vim.cmd("Copilot disable")
          end
        end,
      }):map("<leader>aC")
    end,
    keys = {
      {
        "<C-l>",
        function()
          if vim.api.nvim_call_function("g:copilot#Enabled", {}) == 0 then
            vim.cmd("Copilot enable")
          end

          local key = vim.api.nvim_replace_termcodes("<M-\\>", true, false, true)
          vim.api.nvim_feedkeys(key, "i", false)
        end,
        desc = "Copilot manual trigger",
        mode = "i",
      },
    },
  },
}
