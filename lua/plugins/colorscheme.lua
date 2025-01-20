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
  "monokai-pro",
  "monokai-pro-spectrum",
}

local function fix_colorschemes()
  if vim.tbl_contains(legacy_colors, vim.g.colors_name) then
    vim.cmd("hi SignColumn guibg=NONE")
    vim.cmd("hi! link WinBar Normal")
    vim.cmd("hi! link WinBarNC Normal")

    vim.cmd("hi! link LazyNormal Normal")
    vim.cmd("hi! link NormalFloat Statement")

    if vim.fn.hlexists("VertSplit") ~= 1 then
      vim.cmd("hi! link VertSplit Statement")
    end

    if not vim.tbl_contains({ "zaibatsu", "monokai-pro", "monokai-pro-spectrum" }, vim.g.colors_name) then
      vim.cmd("hi! link WinSeparator Statement")
      vim.cmd("hi! link MatchParen CursorLine")
    end

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
    vim.api.nvim_set_hl(
      0,
      "TelescopeBorder",
      { bg = vim.fn.synIDattr(vim.fn.hlID("Normal"), "bg"), fg = vim.fn.synIDattr(vim.fn.hlID("Statement"), "fg") }
    )

    if LazyVim.has("blink.cmp") then
      if vim.fn.hlexists("FloatBorder") ~= 1 then
        vim.api.nvim_set_hl(0, "FloatBorder", { link = "VertSplit" })
      end

      vim.api.nvim_set_hl(0, "BlinkCmpMenu", { link = "Normal" })
      vim.api.nvim_set_hl(0, "BlinkCmpMenuBorder", { link = "FloatBorder" })
      vim.api.nvim_set_hl(0, "BlinkCmpDocBorder", { link = "FloatBorder" })
      vim.api.nvim_set_hl(0, "BlinkCmpSignatureHelpBorder", { link = "FloatBorder" })
      vim.api.nvim_set_hl(0, "BlinkCmpMenuSelection", { link = "CursorLine" })
      vim.api.nvim_set_hl(0, "BlinkCmpMenuBorder", { link = "FloatBorder" })
      vim.api.nvim_set_hl(0, "BlinkCmpLabelDeprecated", { bg = "none", fg = "none", strikethrough = true })
      vim.api.nvim_set_hl(0, "BlinkCmpLabelMatch", { link = "FloatBorder", bold = true })
      vim.api.nvim_set_hl(0, "BlinkCmpSignatureHelpActiveParameter", { link = "VertSplit", bold = true })
    end

    if LazyVim.has("nvim-navic") then
      local comment_fg = vim.fn.synIDattr(vim.fn.hlID("Comment"), "fg")

      vim.api.nvim_set_hl(0, "NavicText", { italic = true, fg = comment_fg })
      vim.api.nvim_set_hl(0, "NavicSeparator", { fg = "none", bg = "none" })
      vim.api.nvim_set_hl(0, "NavicIconsNamespace", { link = "Special" })
      vim.api.nvim_set_hl(0, "NavicIconsPackage", { link = "Type" })
      vim.api.nvim_set_hl(0, "NavicIconsClass", { link = "Identifier" })
      vim.api.nvim_set_hl(0, "NavicIconsMethod", { link = "Function" })
      vim.api.nvim_set_hl(0, "NavicIconsProperty", { link = "Type" })
      vim.api.nvim_set_hl(0, "NavicIconsField", { link = "Field" })
      vim.api.nvim_set_hl(0, "NavicIconsConstructor", { link = "Constructor" })
      vim.api.nvim_set_hl(0, "NavicIconsEnum", { link = "Enum" })
      vim.api.nvim_set_hl(0, "NavicIconsInterface", { link = "Interface" })
      vim.api.nvim_set_hl(0, "NavicIconsFunction", { link = "Function" })
      vim.api.nvim_set_hl(0, "NavicIconsVariable", { link = "Variable" })
      vim.api.nvim_set_hl(0, "NavicIconsConstant", { link = "Constant" })
      vim.api.nvim_set_hl(0, "NavicIconsString", { link = "String" })
      vim.api.nvim_set_hl(0, "NavicIconsNumber", { link = "Number" })
      vim.api.nvim_set_hl(0, "NavicIconsBoolean", { link = "Boolean" })
      vim.api.nvim_set_hl(0, "NavicIconsArray", { link = "Array" })
      vim.api.nvim_set_hl(0, "NavicIconsObject", { link = "Object" })
      vim.api.nvim_set_hl(0, "NavicIconsKey", { link = "Keyword" })
      vim.api.nvim_set_hl(0, "NavicIconsNull", { link = "Constant" })
      vim.api.nvim_set_hl(0, "NavicIconsEnumMember", { link = "Constant" })
      vim.api.nvim_set_hl(0, "NavicIconsStruct", { link = "Structure" })
      vim.api.nvim_set_hl(0, "NavicIconsEvent", { link = "Event" })
      vim.api.nvim_set_hl(0, "NavicIconsOperator", { link = "Operator" })
      vim.api.nvim_set_hl(0, "NavicIconsTypeParameter", { link = "TypeParameter" })
      vim.api.nvim_set_hl(0, "NavicSeparator", { link = "Delimiter" })
    end
  end

  if LazyVim.has("nvim-treesitter") then
    vim.api.nvim_set_hl(0, "@lsp.type.variable.python", {})
    vim.api.nvim_set_hl(0, "@lsp.type.parameter.python", {})
  end

  if LazyVim.has("todo-comments.nvim") then
    vim.api.nvim_set_hl(0, "Todo", {})
  end

  vim.api.nvim_set_hl(0, "TreesitterContext", { link = "CursorLine" })
end

-- completes a few colorschemes
vim.api.nvim_create_autocmd("ColorScheme", {
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
