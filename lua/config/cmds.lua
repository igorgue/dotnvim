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
  Snacks.terminal(
    { "chess-tui" },
    { cwd = Util.root.get(), border = "rounded", args = { "-e", vim.fn.exepath("stockfish") } }
  )
end, {})

vim.api.nvim_create_user_command("Cloc", function()
  vim.schedule(function()
    local out = vim.fn.system("cloc --quiet --vcs=git --exclude-ext=json,toml,ini,txt")
    local buf = vim.api.nvim_create_buf(false, true)

    vim.api.nvim_buf_call(buf, function()
      vim.api.nvim_paste(out, false, -1)
    end)

    Snacks.win({
      buf = buf,
      title = " cloc ",
      title_pos = "center",
      border = "rounded",
      ft = "markdown",
      relative = "editor",
      position = "float",
      footer = " 'q' to close ",
      footer_pos = "center",
      width = 0.8,
      height = 0.3,
    })
  end)
end, {})

vim.api.nvim_create_user_command("Notifications", function()
  vim.schedule(Snacks.notifier.show_history)
end, {})

vim.cmd([[
  command! Delmarks silent execute 'delmarks '.join(map(filter(filter(map(split(execute('marks'),"\n"),'split(v:val)'), 'v:val[1]==line(".")&&v:val[0]!~#"[A-Z]"'), 'v:val[1]==line(".")&&v:val[0]!~#"[A-Z]"'), 'v:val[0]'))
]])
