vim.api.nvim_create_autocmd({ "FileType" }, {
  group = vim.api.nvim_create_augroup("KittyScrollbackNvimFileType", { clear = true }),
  pattern = { "kitty-scrollback" },
  callback = function()
    vim.opt.laststatus = 0
    return true
  end,
})

return {
  "mikesmithgh/kitty-scrollback.nvim",
  cmd = { "KittyScrollbackGenerateKittens", "KittyScrollbackCheckHealth" },
  event = { "User KittyScrollbackLaunch" },
  config = function()
    require("kitty-scrollback").setup()
  end,
}
