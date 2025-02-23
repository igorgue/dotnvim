return {
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "brianhuster/nvim-treesitter-endwise",
    },
    cmd = { "TSEnable", "TSBufEnable" },
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
        include_match_words = true,
        disable = function(_)
          local filepath = vim.fn.expand("%:p")
          for _, pattern in ipairs(vim.g.cmp_disabled_files or {}) do
            if filepath:match(pattern) then
              return true
            end
          end

          -- PERF: doesn't perform well on "large" files
          return vim.fn.getfsize(filepath) > 32 * 1024
        end,
      },
    },
  },
}
