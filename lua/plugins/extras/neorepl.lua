local function toggle()
  local repl_buf = nil
  local buf_found = false

  -- NOTE: we need to walk backwards because sometimes
  -- the repl buffer is the last one and other
  -- buffers with the same file type (float windows)
  -- might be there as well.
  local bufs = vim.api.nvim_list_bufs()
  for i = #bufs, 1, -1 do
    local buf = bufs[i]
    if vim.bo[buf].filetype == "neorepl" then
      repl_buf = buf
      buf_found = true
    end
  end

  if buf_found then
    local wins = vim.api.nvim_list_wins()
    for i = #wins, 1, -1 do
      local win = wins[i]

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
      vim.opt_local.winhighlight = "NormalFloat:MyTermBg"

      if vim.api.nvim_get_mode().mode == "n" then
        vim.api.nvim_command("startinsert")
      end

      vim.api.nvim_set_hl(0, "neoreplValue", {})
    end,
    on_close = function(_)
      if vim.api.nvim_get_mode().mode == "i" then
        vim.api.nvim_command("stopinsert")
      end
    end,
  })
end

return {
  {
    "ii14/neorepl.nvim",
    desc = "Neovim's Lua repl",
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
    cmd = { "Repl" },
    init = function()
      -- TODO: this doesn't work, it's added on blink.cmp config at coding.lua
      vim.tbl_extend("force", vim.g.cmp_disabled_filetypes, { "neorepl" })
    end,
    keys = {
      { "<c-\\>", toggle, mode = { "i", "n" }, desc = "Open Neovim's Lua repl" },
      { "<tab>", "<tab>", mode = "i", ft = "neorepl" },
      { "<c-space>", "<Plug>(neorepl-complete)", mode = "i", desc = "Trigger completion", ft = "neorepl" },
      {
        "<cr>",
        [[pumvisible() ? (complete_info().selected != -1 ? '<c-y>' : '<c-n><c-y>') : '<Plug>(neorepl-eval-line)']],
        mode = "i",
        desc = "Accept completion",
        ft = "neorepl",
        expr = true,
        replace_keycodes = false,
      },
      { "<cr>", "<Plug>(neorepl-eval-line)", mode = "n", desc = "Eval line", ft = "neorepl" },
      {
        "<cr>",
        function()
          vim.cmd("normal J")

          vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>(neorepl-eval-line)<cr>", true, true, true))
        end,
        mode = { "v" },
        desc = "Eval block",
        ft = "neorepl",
      },
      { "<s-cr>", "<cr>", mode = "i", desc = "Insert new line", ft = "neorepl" },
    },
  },
}
