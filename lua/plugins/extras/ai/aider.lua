vim.g.lazyvim_aider_model = vim.env.LAZYVIM_AIDER_MODEL

local function open()
  local options = "--analytics-disable --notifications --editor nvim --code-theme solarized-dark"

  if vim.g.lazyvim_aider_model ~= nil then
    options = options .. ' --model "' .. vim.g.lazyvim_aider_model .. '"'
  end

  vim.cmd("AiderOpen " .. options)
end

return {
  "joshuavial/aider.nvim",
  desc = "Aider AI coding assistant",
  opts = {
    auto_manage_context = true,
    default_bindings = false,
    debug = false,
  },
  cmd = { "AiderOpen", "AiderAddModifiedFiles" },
  keys = {
    { "<leader>ai", open, desc = "Aider open" },
  },
}
