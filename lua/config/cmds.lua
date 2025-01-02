local Util = require("lazyvim.util")

vim.api.nvim_create_user_command("Btop", function()
  Snacks.terminal("btop", { border = "none" })
end, {})

vim.api.nvim_create_user_command("Nap", function()
  Snacks.terminal("nap", { border = "rounded" })
end, {})

vim.api.nvim_create_user_command("Yazi", function()
  Snacks.terminal({ "yazi" }, { cwd = Util.root.get(), border = "rounded" })
end, {})

vim.api.nvim_create_user_command("Lazygit", function()
  Snacks.terminal({ "lazygit" }, { cwd = Util.root.get(), border = "none" })
end, {})

vim.api.nvim_create_user_command("ChessTui", function()
  Snacks.terminal({ "chess-tui" }, { cwd = Util.root.get(), border = "rounded", args = { "-e", "/usr/bin/stockfish" } })
end, {})

vim.api.nvim_create_user_command("Cloc", function()
  vim.schedule(function()
    local out = vim.fn.system("cloc --quiet --vcs=git --exclude-ext=json,toml,ini,txt")

    vim.notify(out, vim.log.levels.INFO, { title = "Lines of code in project" })
  end)
end, {})

vim.api.nvim_create_user_command("Notifications", function()
  vim.schedule(Snacks.notifier.show_history)
end, {})

vim.api.nvim_create_user_command("Btop", function()
  Snacks.terminal("btop", { border = "none" })
end, {})


