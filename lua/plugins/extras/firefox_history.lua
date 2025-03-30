return {
  "dawsers/snacks-picker-firefox.nvim",
  dependencies = {
    "folke/snacks.nvim",
    "kkharji/sqlite.lua",
  },
  lazy = false,
  config = function()
    local firefox = require("firefox")
    -- You need to call setup
    firefox.setup({
      -- These are the default values, usually correct for Linux.
      --
      -- For MacOS or Windows, adapt the configuration, search
      -- where your Firefox profile is. It is usually in these
      -- directories:
      --
      --    MacOS: "Library/Application Support/Firefox"
      --    Windows: "Appdata/Roaming/Mozilla/Firefox"
      --
      -- The url open command is also different depending on the OS,
      -- 'open' (MacOS), 'start firefox' or 'explorer' (Windows)
      --
      url_open_command = "xdg-open",
      firefox_profile_dir = "~/.mozilla/firefox",
      firefox_profile_glob = "*.default*",
    })
    vim.keymap.set({ "n" }, "<leader>Ff", function()
      Snacks.picker.firefox_search()
    end, { silent = true, desc = "Firefox search" })
    vim.keymap.set({ "n" }, "<leader>Fb", function()
      Snacks.picker.firefox_bookmarks()
    end, { silent = true, desc = "Firefox bookmarks" })
    vim.keymap.set({ "n" }, "<leader>Fh", function()
      Snacks.picker.firefox_history()
    end, { silent = true, desc = "Firefox history" })
  end,
}
