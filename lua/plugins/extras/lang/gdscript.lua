return {
  desc = "Godot",
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = {
      ensure_installed = { "gdscript", "gdshader" },
    },
  },
  {
    "neovim/nvim-lspconfig",
    ft = "gdscript",
    opts = {
      servers = {
        gdscript = {},
      },
    },
  },
  {
    "habamax/vim-godot",
    init = function()
      -- TODO: only for nixos, change? maybe no.
      vim.g.godot_executable = "/run/current-system/sw/bin/godot4"
    end,
    cmd = { "GodotRun", "GodotRunLast", "GodotRunCurrent", "GodotRunFZF" },
    keys = {
      { "<F4>", "<cmd>GodotRunLast<cr>", desc = "Godot Run Last", ft = "gdscript" },
      { "<F5>", "<cmd>GodotRun<cr>", desc = "Godot Run", ft = "gdscript" },
      { "<F6>", "<cmd>GodotRunCurrent<cr>", desc = "Godot Run Current", ft = "gdscript" },
    },
  },
  {
    "Lommix/godot.nvim",
    cmd = { "GodotDebug", "GodotBreakAtCursor", "GodotStep", "GodotQuit", "GodotContinue" },
    keys = {
      { "<F7>", "<cmd>GodotDebug<cr>", desc = "Godot Debug", ft = "gdscript" },
      { "<F8>", "<cmd>GodotBreakAtCursor<cr>", desc = "Godot Break At Cursor", ft = "gdscript" },
      { "<F9>", "<cmd>GodotStep<cr>", desc = "Godot Step", ft = "gdscript" },
      { "<F10>", "<cmd>GodotQuit<cr>", desc = "Godot Quit", ft = "gdscript" },
      { "<F11>", "<cmd>GodotContinue<cr>", desc = "Godot Continue", ft = "gdscript" },
    },
  },
}
