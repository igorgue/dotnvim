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
      highlight = {
        disable = disable_fn,
      },
      indent = {
        disable = disable_fn,
      },
      incremental_selection = {
        disable = disable_fn,
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
