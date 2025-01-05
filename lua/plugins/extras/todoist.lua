vim.g.loaded_node_provider = nil
vim.g.node_host_prog = vim.fn.exepath("neovim-node-host")

return {
  {
    "romgrk/todoist.nvim",
    lazy = false,
    build = ":TodoistInstall",
  },
}
