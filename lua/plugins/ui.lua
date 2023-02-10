return {
  { dir = "~/Code/danger", event = "VeryLazy" },
  -- { "igorgue/danger", event = "VeryLazy" },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "danger",
    },
  },
  {
    "folke/tokyonight.nvim",
    config = function()
      local colors = require("tokyonight.colors")

      -- create a new palette based on the default colors
      colors.danger = vim.deepcopy(colors.default)

      colors.danger.none = "NONE"

      colors.danger.bg = "#161925"
      colors.danger.bg_dark = "#394160"
      colors.danger.bg_highlight = "#262B40"
      colors.danger.terminal_black = "#161925"

      colors.danger.dark3 = "#454555"
      colors.danger.dark5 = "#394160"

      colors.danger.comment = "#6c6c6c"

      colors.danger.fg = "#dadada"
      colors.danger.fg_dark = "#626262"
      colors.danger.fg_gutter = "#161925"

      colors.danger.magenta2 = "#ffd7ff"
      colors.danger.magenta = "#8787d7"

      colors.danger.orange = "#ff8787"
      colors.danger.purple = "#875fff"

      colors.danger.red1 = "#ff5f00"
      colors.danger.red = "#ff3525"

      colors.danger.teal = "#00af87"
      colors.danger.yellow = "#ffd75f"

      colors.danger.green1 = "#afd7af"
      colors.danger.green2 = "#00524b"
      colors.danger.green = "#cbe6ff"

      colors.danger.cyan = "#cbe6ff"

      colors.danger.blue0 = "#8787d7"
      colors.danger.blue1 = "#c4c9f3"
      colors.danger.blue2 = "#eac9e4"
      colors.danger.blue5 = "#b1a7cd"
      colors.danger.blue6 = "#cbb9ad"
      colors.danger.blue7 = "#c7a0c3"
      colors.danger.blue = "#875fff"

      colors.danger.git = {
        add = "#00af87",
        change = "#ff5f00",
        delete = "#ff3525",
      }

      colors.danger.gitSigns = {
        add = "#00af87",
        change = "#ff5f00",
        delete = "#ff3525",
      }

      -- load your style
      require("tokyonight").load({ style = "danger" })
    end,
  },
  { "akinsho/bufferline.nvim", enabled = false },
  {
    "lukas-reineke/indent-blankline.nvim",
    dependencies = {
      "echasnovski/mini.indentscope",
    },
    keys = {
      {
        "<leader>L",
        function()
          if vim.opt.list:get() then
            vim.opt.list = false
            vim.g.miniindentscope_disable = true
          else
            vim.opt.list = true
            vim.g.miniindentscope_disable = false
          end
        end,
        desc = "Toggle list",
      },
    },
  },
  -- {
  --   "echasnovski/mini.indentscope",
  --   enabled = false,
  -- },
  {
    "rcarriga/nvim-notify",
    opts = {
      render = "default",
      fps = 120,
      timeout = 2500,
      stages = "static",
      background_colour = "#161925",
    },
  },
  {
    "goolord/alpha-nvim",
    opts = function(_, _)
      local dashboard = require("alpha.themes.dashboard")
      local neovim_version = vim.version()

      if neovim_version == nil then
        neovim_version = {
          major = 0,
          minor = 0,
          patch = 0,
          prerelease = true,
        }
      end

      local version = neovim_version.major .. "." .. neovim_version.minor .. "." .. neovim_version.patch
      if neovim_version.prerelease then
        version = version .. "-dev"
      end

      local logo = "NVIM " .. version

      dashboard.section.header.val = vim.split(logo, "\n")

      dashboard.section.buttons.val = {
        { type = "padding", val = 1 },
        dashboard.button("n", " " .. " New file", ":ene <bar> startinsert <cr>"),
        dashboard.button("r", " " .. " Recent files", ":Telescope oldfiles <cr>"),
        dashboard.button("s", "勒" .. " Load Session", [[:lua require("persistence").load() <cr>]]),
        dashboard.button("f", " " .. " Find file", ":Telescope find_files <cr>"),
        dashboard.button("o", " " .. " Smart Open", ":Telescope smart_open <cr>"),
        dashboard.button("g", " " .. " Grep text", ":Telescope live_grep <cr>"),
        dashboard.button("c", " " .. " Config", ":e $MYVIMRC <cr>"),
        dashboard.button("l", "鈴" .. " Lazy", ":Lazy<cr>"),
        dashboard.button("t", " " .. " Terminal", "<cmd>Lspsaga term_toggle<cr>"),
        dashboard.button("d", " " .. " Database", "<cmd>enew<cr><cmd>DBUI<cr>"),
        dashboard.button("q", " " .. " Quit", ":qa<cr>"),
        { type = "padding", val = 1 },
      }

      for _, button in ipairs(dashboard.section.buttons.val) do
        if button.opts ~= nil then
          button.opts.hl = "AlphaButtons"
          button.opts.hl_shortcut = "AlphaShortcut"
        end
      end

      dashboard.section.footer.opts.hl = "AlphaFooter"
      dashboard.section.header.opts.hl = "AlphaHeader"
      dashboard.section.buttons.opts.hl = "AlphaButtons"
      dashboard.opts.layout[1].val = 8

      return dashboard
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_)
      local icons = require("lazyvim.config").icons

      local function hi_co(group, kind)
        return vim.fn.synIDattr(vim.fn.hlID(group), kind)
      end

      local function lualine_theme()
        local lualine_colors = {
          black = hi_co("Normal", "bg"),
          white = hi_co("Normal", "fg"),
          red = hi_co("Error", "fg"),
          green = hi_co("Label", "fg"),
          blue = hi_co("CursorLineNr", "fg"),
          lightblue = hi_co("CursorLineNr", "bg"),
          yellow = hi_co("Function", "fg"),
          gray = hi_co("Pnu", "fg"),
          darkgray = hi_co("LspCodeLens", "fg"),
          lightgray = hi_co("Visual", "bg"),
          inactivegray = hi_co("TabLine", "fg"),
        }

        local theme = {
          normal = {
            a = { bg = lualine_colors.lightblue, fg = lualine_colors.white, gui = "bold" },
            b = { bg = lualine_colors.lightblue, fg = lualine_colors.white },
            c = { bg = lualine_colors.lightblue, fg = lualine_colors.white, gui = "bold" },
            x = { bg = lualine_colors.lightblue, fg = lualine_colors.white },
            y = { bg = lualine_colors.lightblue, fg = lualine_colors.white, gui = "bold" },
            z = { bg = lualine_colors.lightblue, fg = lualine_colors.white, gui = "bold" },
          },
          insert = {
            a = { bg = lualine_colors.blue, fg = lualine_colors.black, gui = "bold" },
            b = { bg = lualine_colors.blue, fg = lualine_colors.black },
            c = { bg = lualine_colors.blue, fg = lualine_colors.black, gui = "bold" },
            x = { bg = lualine_colors.blue, fg = lualine_colors.black },
            y = { bg = lualine_colors.blue, fg = lualine_colors.black, gui = "bold" },
            z = { bg = lualine_colors.blue, fg = lualine_colors.black, gui = "bold" },
          },
          visual = {
            a = { bg = lualine_colors.lightgray, fg = lualine_colors.white, gui = "bold" },
            b = { bg = lualine_colors.lightgray, fg = lualine_colors.white },
            c = { bg = lualine_colors.lightgray, fg = lualine_colors.white, gui = "bold" },
            x = { bg = lualine_colors.lightgray, fg = lualine_colors.white },
            y = { bg = lualine_colors.lightgray, fg = lualine_colors.white, gui = "bold" },
            z = { bg = lualine_colors.lightgray, fg = lualine_colors.white, gui = "bold" },
          },
          replace = {
            a = { bg = lualine_colors.red, fg = lualine_colors.black, gui = "bold" },
            b = { bg = lualine_colors.red, fg = lualine_colors.black },
            c = { bg = lualine_colors.red, fg = lualine_colors.black, gui = "bold" },
            x = { bg = lualine_colors.red, fg = lualine_colors.black },
          },
          command = {
            a = { bg = lualine_colors.green, fg = lualine_colors.black, gui = "bold" },
            b = { bg = lualine_colors.green, fg = lualine_colors.black },
            c = { bg = lualine_colors.green, fg = lualine_colors.black, gui = "bold" },
            x = { bg = lualine_colors.green, fg = lualine_colors.black },
            y = { bg = lualine_colors.green, fg = lualine_colors.black, gui = "bold" },
            z = { bg = lualine_colors.green, fg = lualine_colors.black, gui = "bold" },
          },
          inactive = {
            a = { bg = lualine_colors.darkgray, fg = lualine_colors.gray },
            b = { bg = lualine_colors.darkgray, fg = lualine_colors.gray },
            c = { bg = lualine_colors.darkgray, fg = lualine_colors.gray },
          },
        }

        if vim.api.nvim_win_get_option(0, "diff") then
          local defaults = {
            a = { bg = lualine_colors.black, fg = lualine_colors.inactivegray },
            b = { bg = lualine_colors.black, fg = lualine_colors.inactivegray },
            c = { bg = lualine_colors.black, fg = lualine_colors.inactivegray },
            x = { bg = lualine_colors.black, fg = lualine_colors.inactivegray },
          }

          theme.inactive = defaults
          theme.normal = defaults
          theme.insert = defaults
          theme.visual = defaults
          theme.visual.x = { bg = lualine_colors.blue, fg = lualine_colors.black }
          theme.replace = defaults
          theme.command = defaults
          theme.inactive = defaults
        end

        return theme
      end

      return {
        options = {
          theme = lualine_theme(),
          disabled_filetypes = { statusline = { "dashboard", "lazy", "alpha" } },
          component_separators = "",
          section_separators = { left = "", right = "" },
          globalstatus = true,
        },
        sections = {
          lualine_a = {
            {
              "mode",
              fmt = function(str)
                return str:lower():sub(1, 1)
              end,
            },
          },
          lualine_b = {
            "branch",
            {
              "diff",
              symbols = {
                added = icons.git.added,
                modified = icons.git.modified,
                removed = icons.git.removed,
              },
            },
            {
              "diagnostics",
              symbols = {
                error = icons.diagnostics.Error,
                warn = icons.diagnostics.Warn,
                info = icons.diagnostics.Info,
                hint = icons.diagnostics.Hint,
              },
            },
          },
          lualine_c = {
            "%=",
            {
              "filename",
              path = 1,
              symbols = { modified = "", readonly = "", new = "", unnamed = "" },
            },
          },
          lualine_x = {
            -- stylua: ignore
            {
              function() return require("noice").api.status.command.get() end,
              cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
            },
            -- stylua: ignore
            {
              function() return require("noice").api.status.mode.get() end,
              cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
            },
            {
              require("lazy.status").updates,
              cond = require("lazy.status").has_updates,
            },
            "encoding",
            { "filetype", icon_only = true },
            "fileformat",
          },
          lualine_y = { "location" },
          lualine_z = { "progress" },
        },
        extensions = { "neo-tree" },
      }
    end,
  },
  {
    "norcalli/nvim-colorizer.lua",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "ColorizerToggle", "ColorizerAttachToBuffer", "ColorizerReloadAllBuffers" },
    config = function(_, _)
      require("colorizer").setup({ "*" }, {
        RGB = true, -- #RGB hex codes
        RRGGBB = true, -- #RRGGBB hex codes
        names = true, -- "Name" codes like Blue
        RRGGBBAA = true, -- #RRGGBBAA hex codes
        rgb_fn = true, -- CSS rgb() and rgba() functions
        hsl_fn = true, -- CSS hsl() and hsla() functions
        css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
        css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
        -- Available modes: foreground, background
        mode = "foreground", -- Set the display mode.
      })
    end,
  },
  {
    "ziontee113/color-picker.nvim",
    event = { "BufReadPost", "BufNewFile" },
    config = true,
    keys = {
      { "<M-c>", "<cmd>PickColor<cr>", desc = "Pick color" },
      { "<M-c>", "<cmd>PickColorInsert<cr>", desc = "Pick color", mode = "i" },
    },
  },
  {
    "mattn/webapi-vim",
    event = "BufReadPost",
  },
  {
    "s1n7ax/nvim-window-picker",
    event = "BufReadPost",
    config = function()
      require("window-picker").setup()
    end,
  },
}
