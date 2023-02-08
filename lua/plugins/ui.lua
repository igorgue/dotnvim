return {
  { "igorgue/danger", priority = 19001 },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "danger",
    },
  },
  -- {
  --   "folke/tokyonight.nvim",
  --   lazy = false,
  --   -- config = function() end,
  -- },
  -- {
  --   "igorgue/tokyonight.nvim",
  --   name = "tokyonight-danger",
  --   priority = 1,
  --   config = function()
  --     vim.cmd("colorscheme tokyonight-danger")
  --   end,
  -- },
  -- {
  --   "LazyVim/LazyVim",
  --   opts = {
  --     colorscheme = "tokyonight",
  --   },
  -- },
  { "akinsho/bufferline.nvim", enabled = false },
  {
    "lukas-reineke/indent-blankline.nvim",
    enabled = false,
  },
  {
    "echasnovski/mini.indentscope",
    enabled = false,
  },
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

      local logo = "neovim " .. version

      dashboard.section.header.val = vim.split(logo, "\n")

      dashboard.section.buttons.val = {
        { type = "padding", val = 1 },
        dashboard.button("e", " " .. " New file", ":ene<cr>"),
        dashboard.button("f", " " .. " Find file", ":Telescope find_files <cr>"),
        dashboard.button("j", " " .. " Smart open", ":Telescope smart_open <cr>"),
        dashboard.button("r", " " .. " Recent files", ":Telescope oldfiles <cr>"),
        dashboard.button("g", " " .. " Find text", ":Telescope live_grep <cr>"),
        dashboard.button("c", " " .. " Config", ":e $MYVIMRC <cr>"),
        dashboard.button("s", "勒" .. " Restore Session", [[:lua require("persistence").load() <cr>]]),
        dashboard.button("l", "鈴" .. " Lazy", ":Lazy<cr>"),
        dashboard.button("t", " " .. " Terminal", "<cmd>terminal<cr>i"),
        dashboard.button("d", " " .. " Database Manager", "<cmd>enew<cr><cmd>DBUI<cr>"),
        dashboard.button("q", " " .. " Quit", ":qa<cr>"),
        { type = "padding", val = 1 },
      }
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
          red = hi_co("Errorg", "fg"),
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
    priority = 1,
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
    config = function(_, _)
      require("color-picker").setup()
    end,
    keys = {
      { "<M-c>", "<cmd>PickColor<cr>", desc = "Pick color" },
      { "<M-c>", "<cmd>PickColorInsert<cr>", desc = "Pick color", mode = "i" },
    },
  },
  "mattn/webapi-vim",
}
