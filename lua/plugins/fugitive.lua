return {
  "tpope/vim-fugitive",
  event = "BufReadPost",
  cmd = "Git",
  dependencies = {
    "tpope/vim-git",
  },
}
