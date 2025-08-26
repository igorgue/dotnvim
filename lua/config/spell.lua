-- Spell checking configuration
-- Personal spell exceptions

-- Set spell language
vim.opt.spelllang = "en_us"

-- Add personal spell exceptions
vim.cmd([[
  syntax spell toplevel
  set spellfile=~/.config/nvim/spell/en.utf-8.add
]])

-- Add specific words to spell exceptions
vim.cmd("silent! spellgood " .. vim.env.USERNAME)

-- Optional: Add more words you commonly use
local common_exceptions = {
  "btw",
  "CodeCompanion",
  "deepseek",
  "DeepSeek",
  "Django",
  "LazyVim",
  "mcp",
  "MCPHub",
  "Neovim",
  "vectorcode",
}

for _, word in ipairs(common_exceptions) do
  vim.cmd("silent! spellgood " .. word)
end
