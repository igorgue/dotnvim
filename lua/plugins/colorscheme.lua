local legacy_colors = {
  "default",
  "vim",
  "zaibatsu",
  "caret",
  "candy",
  "elflord",
  "ir_black",
  "ir_blue",
  "ir_dark",
}

local function fix_colorschemes()
  if vim.tbl_contains(legacy_colors, vim.g.colors_name) then
    vim.cmd("hi SignColumn guibg=NONE")
    vim.cmd("hi! link WinBar Normal")
    vim.cmd("hi! link WinBarNC Normal")
    vim.cmd("hi! link VertSplit Type")
    vim.cmd("hi! link WinSeparator Type")
    vim.cmd("hi! link MatchParen CursorLine")

    vim.cmd("hi! link CmpItemAbbr Identifier")
    vim.cmd("hi! link CmpItemAbbrDeprecated Identifier")
    vim.cmd("hi! link CmpItemAbbrMatch String")
    vim.cmd("hi! link CmpItemAbbrMatchFuzzy String")
    vim.cmd("hi! link CmpItemKind Type")
    vim.cmd("hi! link CmpItemMenu Function")
    vim.cmd("hi! link WhichKeyNormal Normal")

    if vim.tbl_contains({ "zaibatsu", "vim" }, vim.g.colors_name) then
      vim.cmd("hi! link LazyNormal Normal")
      vim.cmd("hi! link NormalFloat Normal")
    end

    vim.api.nvim_set_hl(
      0,
      "TelescopeSelection",
      { bold = true, bg = vim.fn.synIDattr(vim.fn.hlID("CursorLine"), "bg") }
    )
  end

  -- prefer treesitter highlights for these
  if vim.env.NVIM_TS_ENABLE ~= nil then
    vim.api.nvim_set_hl(0, "@lsp.type.variable.python", {})
    vim.api.nvim_set_hl(0, "@lsp.type.parameter.python", {})
  end
end

-- completes a few colorschemes
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = legacy_colors,
  callback = fix_colorschemes,
  once = true,
})

fix_colorschemes()

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    Snacks.toggle({
      name = "Dark Mode",
      get = function()
        return vim.g.colors_name == "danger_dark"
      end,
      set = function(state)
        if state then
          vim.cmd("colorscheme danger_dark")
        else
          vim.cmd("colorscheme danger_light")
        end

        vim.cmd("Lazy reload lualine.nvim")
        require("lualine").refresh()
        vim.opt.laststatus = vim.diagnostic.is_enabled() and 3 or 0
      end,
    }):map("<leader>u.d")
  end,
  once = true,
})

return {
  {
    -- includes catppuccin and tokyonight already
    "LazyVim/LazyVim",
    opts = {
      colorscheme = vim.env.NVIM_COLORSCHEME or "danger_dark",
    },
  },
  {
    "igorgue/danger",
    -- dir = "~/Code/danger",
    opts = {
      style = "dark",
      alacritty = true,
      kitty = false,
    },
  },
  { "loctvl842/monokai-pro.nvim", config = true },
  "projekt0n/caret.nvim",
  { "rose-pine/neovim", name = "rose-pine" },

  -- oldschool colorschemes
  "igorgue/candy.vim",
  "twerth/ir_black", -- oldschool colorscheme
}
