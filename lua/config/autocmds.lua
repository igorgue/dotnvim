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

-- Automatically reload direnv when opening an interactive shell in a terminal buffer
-- This helps ensure the `.envrc` is applied without manually running `direnv reload`.
local direnv_group = vim.api.nvim_create_augroup("DirenvReloadOnTermOpen", { clear = true })

local function direnv_on_term(args)
  -- Prevent multiple runs on the same terminal buffer
  local buf = args.buf
  if vim.b[buf].direnv_reload_done then
    return
  end
  vim.b[buf].direnv_reload_done = true

  -- Only proceed if there's a .envrc file in the current working directory
  local envrc_path = vim.fn.getcwd() .. "/.envrc"
  if vim.fn.filereadable(envrc_path) == 0 then
    return
  end

  local name = vim.api.nvim_buf_get_name(buf) or ""
  local term_cmd = name:match("term://.-//%d+:(.*)$") or ""

  -- Extract just the binary name from the full path
  local binary_name = term_cmd:match("([^/]+)$") or term_cmd
  local shells = { "bash", "zsh", "fish", "sh", "nu", "elvish", "xonsh" }
  local is_shell = term_cmd == ""

  -- Check if the binary name is a known shell
  if not is_shell then
    for _, shell in ipairs(shells) do
      if binary_name == shell then
        is_shell = true
        break
      end
    end
  end

  if not is_shell then
    return
  end

  -- Try to send debug command and then direnv reload once the shell is ready
  local function try_send(delay)
    vim.defer_fn(function()
      local job = vim.b[buf].terminal_job_id
      if job ~= nil then
        pcall(vim.fn.chansend, job, "direnv reload\r")
      end
    end, delay)
  end

  -- Single attempt with reasonable delay
  try_send(200)
end

-- Trigger on multiple events to catch different terminal startup flows
vim.api.nvim_create_autocmd({ "TermOpen", "TermEnter" }, {
  group = direnv_group,
  callback = direnv_on_term,
})

vim.api.nvim_create_autocmd("BufEnter", {
  group = direnv_group,
  pattern = "term://*",
  callback = direnv_on_term,
})

-- plugins.extras.* includes more autocmds, specific for certain files
