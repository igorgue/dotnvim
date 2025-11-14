return {
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = { "RRethy/nvim-treesitter-endwise" },
    lazy = false,
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

          -- PERF: doesn't perform well on large files
          return vim.fn.getfsize(filepath) > 100 * 1024
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
        enable = false,
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
        -- XXX: this is breaking for some files... disable for now
        enable = false,
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
