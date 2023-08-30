local disable_fn = function(_, buf)
  local max_filesize = 100 * 1024 -- 100 KB
  local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
  if ok and stats and stats.size > max_filesize then
    vim.notify_once(
      "* treesitter off",
      vim.log.levels.WARN,
      { title = "File is too large! (" .. stats.size .. " > " .. max_filesize .. " bytes)" }
    )

    return true
  end
end

return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      -- FIXME: These two plugins, are slow, on big files
      highlight = {
        -- enable = false,
        disable = disable_fn,
      },
      indent = {
        -- enable = false,
        disable = disable_fn,
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
    },
  },
}
