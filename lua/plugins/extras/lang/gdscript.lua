if lazyvim_docs then
  -- start Neovim with `--listen /tmp/godot.pipe` to use.
end

return {
  desc = "Godot",
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = { ensure_installed = { "gdscript", "gdshader" } },
  },
  {
    "neovim/nvim-lspconfig",
    ft = "gdscript",
    opts = { servers = { gdscript = {} } },
  },
  {
    "Lommix/godot.nvim",
    cmd = { "GodotDebug", "GodotBreakAtCursor", "GodotStep", "GodotQuit", "GodotContinue" },
    opts = { bin = vim.fn.exepath("godot4") },
    keys = {
      { "<F5>", "<cmd>GodotDebug<cr>", desc = "Godot Debug", ft = "gdscript" },
      { "<F6>", "<cmd>GodotContinue<cr>", desc = "Godot Continue", ft = "gdscript" },
      { "<F7>", "<cmd>GodotBreakAtCursor<cr>", desc = "Godot Break At Cursor", ft = "gdscript" },
      { "<F8>", "<cmd>GodotStep<cr>", desc = "Godot Step", ft = "gdscript" },
      { "<F9>", "<cmd>GodotQuit<cr>", desc = "Godot Quit", ft = "gdscript" },
    },
  },
}
