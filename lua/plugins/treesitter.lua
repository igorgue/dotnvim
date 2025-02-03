return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    cmd = { "TSEnable", "TSBufEnable" },
    -- stylua: ignore
    event = function() return {} end,
    opts = {
      highlight = {
        enable = true,
        disable = function(_)
          local filepath = vim.fn.expand("%:p")
          for _, pattern in ipairs(vim.g.cmp_disabled_files or {}) do
            if filepath:match(pattern) then
              return true
            end
          end

          return false
        end,
      },
      indent = {
        disable = function(_)
          local filepath = vim.fn.expand("%:p")
          for _, pattern in ipairs(vim.g.cmp_disabled_files or {}) do
            if filepath:match(pattern) then
              return true
            end
          end

          return false
        end,
      },
      incremental_selection = {
        enable = false,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
      endwise = { enable = true },
      matchup = { enable = true },
    },
  },
}
