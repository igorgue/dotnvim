return {
  "neovim/nvim-lspconfig",
  dependencies = {
    {
      "ziglang/zig.vim",
      init = function()
        vim.g.zig_fmt_autosave = 1

        vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
          pattern = "*.zig.zon",
          callback = function()
            vim.bo.filetype = "zig"
          end,
        })
      end,
    },
  },
  opts = {
    servers = {
      zls = {
        settings = {
          semantic_tokens = "full",
          warn_style = true,
          -- NOTE: never seen an inlay hint
          -- and I don't know what record_session does
          -- nor dangerous_comptime_experiments_do_not_enable...
          -- enable_inlay_hints = true,
          -- inlay_hints_show_builtin = true,
          -- inlay_hints_exclude_single_argument = true,
          -- inlay_hints_hide_redundant_param_names = true,
          -- inlay_hints_hide_redundant_param_names_last_token = true,
          -- highlight_global_var_declarations = true,
          -- dangerous_comptime_experiments_do_not_enable = true,
          -- record_session = true,
        },
      },
    },
  },
}
