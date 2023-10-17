-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

if vim.env.NVIM_TERMINAL ~= nil then
  vim.api.nvim_create_autocmd("TermOpen", {
    callback = function()
      vim.cmd("startinsert")
    end,
  })

  vim.api.nvim_create_autocmd("TermClose", {
    callback = function()
      vim.cmd("qa!")
    end,
  })

  vim.opt.laststatus = 0
  vim.cmd("terminal")
end
