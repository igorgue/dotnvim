return {
  {
    "LazyVim/LazyVim",
    -- extra global keys
    keys = {
      { "<leader>L", "<cmd>Lazy<cr>", desc = "Lazy" },
      {
        "<leader>r",
        function()
          require("notify").dismiss({})
          vim.cmd("nohlsearch")
          vim.cmd("cd ~")
          vim.cmd("cd -")
        end,
        desc = "Refresh",
      },
    },
  },
  { "akinsho/bufferline.nvim", enabled = false },
  {
    "lukas-reineke/indent-blankline.nvim",
    dependencies = {
      "echasnovski/mini.indentscope",
    },
    keys = {
      {
        "<leader>l",
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
        dashboard.button("n", " " .. " new file", ":ene <bar> startinsert <cr>"),
        dashboard.button("r", " " .. " recent files", ":Telescope oldfiles <cr>"),
        dashboard.button("s", "勒" .. " load session", [[:lua require("persistence").load() <cr>]]),
        dashboard.button("f", " " .. " find file", ":Telescope find_files <cr>"),
        dashboard.button("o", " " .. " smart open", ":Telescope smart_open <cr>"),
        dashboard.button("g", " " .. " grep text", ":Telescope live_grep <cr>"),
        dashboard.button("c", " " .. " config", ":e $MYVIMRC <cr>"),
        dashboard.button("l", "鈴" .. " lazy", ":Lazy<cr>"),
        dashboard.button("t", " " .. " terminal", "<cmd>Lspsaga term_toggle<cr>"),
        dashboard.button("d", " " .. " database", "<cmd>enew<cr><cmd>DBUI<cr>"),
        dashboard.button("q", " " .. " quit", ":qa<cr>"),
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
        mode = "background", -- Set the display mode.
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
  {
    "folke/zen-mode.nvim",
    dependencies = { { "folke/twilight.nvim", event = "BufReadPost", cmd = { "Twilight", "TwilightEnable" } } },
    event = "BufReadPost",
    cmd = "ZenMode",
    keys = {
      { "<leader>z", "<cmd>ZenMode<cr>", desc = "Zen mode" },
    },
    config = function(_, opts)
      require("zen-mode").setup(opts)
    end,
    opts = {
      window = {
        options = {
          signcolumn = "no", -- disable signcolumn
          number = false, -- disable number column
          relativenumber = false, -- disable relative numbers
          cursorline = false, -- disable cursorline
          cursorcolumn = false, -- disable cursor column
          foldcolumn = "0", -- disable fold column
          list = false, -- disable whitespace characters
        },
      },
      plugins = {
        options = {
          enabled = true,
          ruler = true,
          showcmd = true,
        },
        twilight = {
          enabled = true,
        },
        gitsigns = {
          enabled = true,
        },
        kitty = {
          enabled = false, -- NOTE: this is not working
          font = "+2",
        },
        alacritty = {
          enabled = false, -- NOTE: this is not working, also
          font = "+2",
        },
      },
      on_open = function(_)
        vim.opt.laststatus = 0
      end,
      on_close = function()
        vim.opt.laststatus = 3
      end,
    },
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      window = {
        mappings = {
          ["o"] = "open",
        },
      },
    },
  },
  {
    "folke/noice.nvim",
    opts = {
      cmdline = {
        enabled = true,
      },
      presets = {
        bottom_search = false,
        command_palette = true,
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = false, -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = true,
      },
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
    },
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-telescope/telescope-ui-select.nvim",
      "nvim-telescope/telescope-symbols.nvim",
      "ghassan0/telescope-glyph.nvim",
      "xiyaowong/telescope-emoji.nvim",
      "xiyaowong/telescope-emoji.nvim",
      "danielfalk/smart-open.nvim",
      "kkharji/sqlite.lua",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
    },
    opts = function(_, _)
      local actions = require("telescope.actions")
      local function telescope_paste_char(char)
        vim.api.nvim_put({ char.value }, "c", false, true)
      end

      return {
        defaults = {
          prompt_prefix = "   ",
          selection_caret = "   ",
          mappings = {
            i = {
              ["<esc>"] = actions.close,
              ["<C-c>"] = actions.close,
            },
          },
          layout_config = {
            prompt_position = "top",
          },
        },
        extensions = {
          emoji = {
            action = telescope_paste_char,
          },
          glyph = {
            action = telescope_paste_char,
          },
          symbols = {
            action = telescope_paste_char,
          },
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({}),
          },
        },
      }
    end,
    config = function(_, opts)
      local telescope = require("telescope")

      telescope.setup(opts)

      telescope.load_extension("notify")
      telescope.load_extension("ui-select")
      telescope.load_extension("noice")
      telescope.load_extension("glyph")
      telescope.load_extension("emoji")
      telescope.load_extension("smart_open")
      telescope.load_extension("fzf")
    end,
    keys = {
      { "<leader>fs", "<cmd>Telescope smart_open<cr>", desc = "Smart open" },
      { "<leader>j", "<cmd>Telescope smart_open<cr>", desc = "Smart open" },
    },
  },
}
