local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  -- bootstrap lazy.nvim
  -- stylua: ignore
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

local spec = {
  -- import LazyVim plugins
  { "LazyVim/LazyVim", import = "lazyvim.plugins" },
  -- import my plugins
  { import = "plugins.extras.lang.c" },
  { import = "plugins.extras.lang.html_css" },
  { import = "plugins.extras.lang.sql" },
  { import = "plugins.extras.lang.lua" },
  { import = "plugins.extras.lang.dart" },
  { import = "plugins.extras.lang.elixir" },
  { import = "plugins.extras.lang.python" },
  { import = "plugins.extras.lang.rust" },
  { import = "plugins.extras.lang.java" },
  { import = "plugins.extras.lang.swift" },
  { import = "plugins.extras.lang.v" },
  { import = "plugins.extras.lang.vim" },
  { import = "plugins.extras.lang.sh" },
  -- import extras
  { import = "lazyvim.plugins.extras.lang.typescript" },
  { import = "lazyvim.plugins.extras.lang.json" },
}
local plugins = {}
local disabled_plugins = {}
local diff_cmd = ""

if vim.env.NVIM_MINIMAL ~= nil then
  plugins = {
    { import = "minimal" },
    { import = "plugins.colorscheme" },
    { import = "plugins.debugging" },
    { import = "plugins.lsp" },
  }
  diff_cmd = "git"
  disabled_plugins = {
    "gzip",
    "netrwPlugin",
    "tarPlugin",
    "tohtml",
    "tutor",
    "zipPlugin",
  }
else
  plugins = {
    { import = "plugins" },
  }
  diff_cmd = "diffview.nvim"
  disabled_plugins = {
    "gzip",
    "matchit",
    "matchparen",
    "netrwPlugin",
    "tarPlugin",
    "tohtml",
    "tutor",
    "zipPlugin",
  }
end

for _, v in ipairs(plugins) do
  table.insert(spec, v)
end

require("lazy").setup({
  spec = spec,
  defaults = {
    -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
    -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
    lazy = true,
    -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
    -- have outdated releases, which may break your Neovim install.
    version = false, -- always use the latest git commit
    -- version = "*", -- try installing the latest stable version for plugins that support semver
  },
  install = { colorscheme = { "tokyonight", "catppuccin", "habamax" } },
  checker = { enabled = true }, -- automatically check for plugin updates
  ui = {
    border = "single",
  },
  diff = { cmd = diff_cmd },
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = disabled_plugins,
    },
  },
})
