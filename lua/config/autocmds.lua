-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- NOTE: vscode plugin don't need to do this...
if vim.g.vscode then
  return
end

vim.api.nvim_create_autocmd("TermOpen", {
  callback = function()
    vim.opt_local.cursorline = false
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt_local.spell = false
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "hyprlang",
  callback = function()
    vim.opt_local.commentstring = "# %s"
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "typescript", "javascript" },
  callback = function()
    vim.opt_local.commentstring = "// %s"
  end,
})

if vim.lsp.inlay_hint ~= nil then
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)

      -- clangd has its own implementation, check c.lua extra
      if client and client.name == "clangd" then
        return
      end

      if client ~= nil and client.server_capabilities.inlayHintProvider then
        vim.lsp.inlay_hint.enable(false)
      end
    end,
  })
end

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

vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged", "TextChangedI" }, {
  callback = function()
    require("lint").try_lint()
  end,
})

-- plugins.extras.* includes more autocmds, specific for certain files
