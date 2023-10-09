local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  -- bootstrap lazy.nvim
  -- stylua: ignore
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable",
    lazypath })
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

require("lazy").setup({
  spec = {
    -- import LazyVim plugins
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    -- import extras from LazyVim
    { import = "lazyvim.plugins.extras.dap.core" },
    { import = "lazyvim.plugins.extras.dap.nlua" },
    { import = "lazyvim.plugins.extras.lang.clangd" },
    { import = "lazyvim.plugins.extras.lang.docker" },
    { import = "lazyvim.plugins.extras.lang.java" },
    { import = "lazyvim.plugins.extras.lang.json" },
    { import = "lazyvim.plugins.extras.lang.python" },
    { import = "lazyvim.plugins.extras.lang.python-semshi" },
    { import = "lazyvim.plugins.extras.lang.rust" },
    { import = "lazyvim.plugins.extras.lang.tailwind" },
    -- { import = "lazyvim.plugins.extras.lang.typescript" },
    -- import extras from config
    { import = "plugins" },
    { import = "plugins.extras.conjure" },
    { import = "plugins.extras.dap" },
    { import = "plugins.extras.lang.c" },
    { import = "plugins.extras.lang.clojure" },
    { import = "plugins.extras.lang.dart" },
    { import = "plugins.extras.lang.elixir" },
    { import = "plugins.extras.lang.html_css" },
    { import = "plugins.extras.lang.mojo" },
    { import = "plugins.extras.lang.odin" },
    { import = "plugins.extras.lang.python" },
    { import = "plugins.extras.lang.rust" },
    { import = "plugins.extras.lang.sh" },
    { import = "plugins.extras.lang.sml" },
    { import = "plugins.extras.lang.sql" },
    { import = "plugins.extras.lang.swift" },
    { import = "plugins.extras.lang.vim" },
    { import = "plugins.extras.lang.zig" },
    { import = "plugins.extras.lspsaga" },
    -- WARNING: plugins are kinda broken
    { import = "plugins.extras.lang.nim" },
    { import = "plugins.extras.lang.v" },
    { import = "plugins.extras.leetcode" },
    -- FIXME: plugins that are not working
    -- { import = "plugins.extras.sg" },
    -- { import = "plugins.extras.sonarlint" },
  },
  defaults = {
    -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
    -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
    lazy = true,
    -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
    -- have outdated releases, which may break your Neovim install.
    version = false, -- always use the latest git commit
    -- version = "*", -- try installing the latest stable version for plugins that support semver
  },
  install = { colorscheme = { "danger" } },
  checker = { enabled = false }, -- automatically check for plugin updates
  ui = {
    border = "single",
  },
  diff = { cmd = "diffview.nvim" },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
