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

  vim.cmd("terminal")
end

if vim.env.NVIM_FOCUS_MODE ~= nil then
  -- done in a defer so we don't block ui that much...
  vim.defer_fn(function()
    require("utils").ui.enable_focus_mode()
  end, 1000)
end
