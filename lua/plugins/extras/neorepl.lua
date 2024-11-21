return {
  "ii14/neorepl.nvim",
  config = false,
  keys = {
    {
      "<c-s-;>",
      function()
        local is_open = false

        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
          local buf_ft = vim.bo[buf].filetype
          if buf_ft == "neorepl" then
            vim.api.nvim_buf_delete(buf, { force = true })
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc>", true, false, true), "n", true)
            is_open = true
          end
        end

        if not is_open then
          local s = Snacks.win({ position = "bottom", height = 0.3 })

          require("neorepl").new({ lang = "lua", startinsert = true, indent = 2, buf = s.buf, win = s.win })
        end
      end,
      mode = { "i", "n" },
      desc = "Open repl",
    },
    { "<C-Space>", "<Plug>(neorepl-complete)", mode = "i", desc = "Trigger completion" },
  },
}
