return {
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "brianhuster/nvim-treesitter-endwise",
    },
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
      incremental_selection = {
        enable = false,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
      endwise = {
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
      matchup = {
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
    },
  },
}
