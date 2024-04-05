local M = {}

function M.check()
  vim.health.start("Local configuration")

  if vim.fn.has("nvim-0.9.0") == 1 then
    vim.health.ok("Using Neovim >= 0.9.0")
  else
    vim.health.error("Neovim >= 0.9.0 is required")
  end

  for _, cmd in ipairs({ "ranger", "nap", "cloc", "btop" }) do
    local name = type(cmd) == "string" and cmd or vim.inspect(cmd)
    local commands = type(cmd) == "string" and { cmd } or cmd
    ---@cast commands string[]
    local found = false

    for _, c in ipairs(commands) do
      if vim.fn.executable(c) == 1 then
        name = c
        found = true
      end
    end

    if found then
      vim.health.ok(("`%s` is installed"):format(name))
    else
      vim.health.warn(("`%s` is not installed"):format(name))
    end
  end
end

return M
