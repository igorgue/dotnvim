return {
  desc = "Tabby AI Assistant (self hosted)",
  {
    "L3MON4D3/LuaSnip",
    -- stylua: ignore
    keys = function() return {} end,
  },
  {
    "TabbyML/vim-tabby",
    cmd = "Tabby",
    event = { "BufReadPost", "BufNewFile" },
    lazy = false, -- FIXME: cannot make it lazyload
    init = function()
      vim.g.tabby_trigger_mode = "auto"
      vim.g.tabby_keybinding_accept = "<Tab>"
      vim.g.tabby_keybinding_trigger_or_dismiss = "<C-l>"
    end,
    keys = {
      {
        "<leader>at",
        function()
          if vim.g.tabby_trigger_mode == "manual" then
            vim.g.tabby_trigger_mode = "auto"
          else
            vim.g.tabby_trigger_mode = "manual"
          end
        end,
        desc = "Tabby toggle",
      },
    },
  },
}
