return {
  "ii14/neorepl.nvim",
  config = false,
  cmd = { "Repl" },
  keys = {
    {
      "<c-s-/>",
      function()
        local repl_buf = nil
        local buf_found = false

        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
          if vim.bo[buf].filetype == "neorepl" then
            repl_buf = buf
            buf_found = true
          end
        end

        if buf_found then
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            if vim.api.nvim_win_get_buf(win) == repl_buf then
              vim.api.nvim_win_close(win, true)
              return
            end
          end
        else
          repl_buf = vim.api.nvim_create_buf(false, true)

          vim.api.nvim_buf_call(repl_buf, function()
            require("neorepl").new({ lang = "lua", indent = 2 })
          end)
        end

        Snacks.win({
          position = "bottom",
          height = 0.3,
          buf = repl_buf,
          minimal = false,
          ft = "lua",
          on_win = function(_)
            if vim.api.nvim_get_mode().mode == "n" then
              vim.api.nvim_command("startinsert")
            end
          end,
          on_close = function(_)
            if vim.api.nvim_get_mode().mode == "i" then
              vim.api.nvim_command("stopinsert")
            end
          end,
        })
      end,
      mode = { "i", "n" },
      desc = "Open Neovim's Lua repl",
    },
    { "<C-Space>", "<Plug>(neorepl-complete)", mode = "i", desc = "Trigger completion", ft = "neorepl" },
    {
      "<cr>",
      [[pumvisible() ? (complete_info().selected != -1 ? '<C-Y>' : '<C-N><C-Y>') : '<Plug>(neorepl-complete)']],
      mode = "i",
      desc = "Accept completion",
      ft = "neorepl",
      expr = true,
    },
  },
}
