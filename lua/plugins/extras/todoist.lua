vim.g.loaded_node_provider = nil
vim.g.node_host_prog = vim.fn.exepath("neovim-node-host")
vim.g.todoist = {
  icons = {
    unchecked = "  ",
    checked = "  ",
    loading = "  ",
    error = "  ",
  },
}
local function toggle()
  local todoist_buf = nil
  local buf_found = false

  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[buf].filetype == "todoist" then
      todoist_buf = buf
      buf_found = true
    end
  end

  if buf_found then
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      if vim.api.nvim_win_get_buf(win) == todoist_buf then
        vim.api.nvim_win_close(win, true)
        return
      end
    end
  else
    todoist_buf = vim.api.nvim_create_buf(false, true)

    vim.api.nvim_buf_call(todoist_buf, function()
      vim.cmd("Todoist")
    end)
  end

  Snacks.win({ position = "bottom", buf = todoist_buf })
end

return {
  "romgrk/todoist.nvim",
  build = ":TodoistInstall",
  desc = "Integration with Todoist",
  lazy = false,
  keys = {
    { "<m-t>", toggle, mode = { "i", "n" }, desc = "Todoist toggle" },
  },
}
