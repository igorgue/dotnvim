return {
  "ii14/neorepl.nvim",
  dependencies = {
    {
      "nvim-treesitter/nvim-treesitter",
      ft = { "neorepl" },
      optional = true,
      opts = function(_, opts)
        vim.treesitter.language.register("lua", "neorepl")

        return opts
      end,
    },
  },
  -- config = false,
  cmd = { "Repl" },
  keys = {
    {
      "<c-s-/>",
      function()
        local repl_buf = nil
        local buf_found = false

        for i = #vim.api.nvim_list_bufs(), 1, -1 do
          local buf = vim.api.nvim_list_bufs()[i]
          if vim.bo[buf].filetype == "neorepl" then
            repl_buf = buf
            buf_found = true
          end
        end

        if buf_found then
          for i = #vim.api.nvim_list_wins(), 1, -1 do
            local win = vim.api.nvim_list_wins()[i]

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

          vim.api.nvim_buf_set_name(repl_buf, "neorepl")
        end

        Snacks.win({
          position = "bottom",
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
    { "<c-space>", "<Plug>(neorepl-complete)", mode = "i", desc = "Trigger completion", ft = "neorepl" },
    {
      "<cr>",
      [[pumvisible() ? (complete_info().selected != -1 ? '<c-y>' : '<c-n><c-y>') : '<cr>']],
      mode = "i",
      desc = "Accept completion",
      ft = "neorepl",
      expr = true,
    },
    {
      "<s-cr>",
      "<Plug>(neorepl-eval-line)",
      mode = "i",
      desc = "Eval line",
      ft = "neorepl",
    },
    {
      "<cr>",
      "<Plug>(neorepl-eval-line)",
      mode = "n",
      desc = "Eval line",
      ft = "neorepl",
    },
    {
      "<cr>",
      function()
        vim.cmd([[
          normal J
        ]])

        vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>(neorepl-eval-line)<cr>", true, true, true))
      end,
      mode = { "v" },
      desc = "Eval block",
      ft = "neorepl",
    },
  },
}
