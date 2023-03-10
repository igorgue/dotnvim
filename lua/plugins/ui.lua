return {
  {
    "LazyVim/LazyVim",
    -- extra global keys
    keys = {
      { "<leader>L", "<cmd>Lazy<cr>", desc = "Lazy" },
      {
        "<leader>r",
        function()
          vim.cmd("cd ~")
          vim.cmd("cd -")
          vim.cmd("nohlsearch")
          vim.cmd("diffupdate")
          vim.cmd("normal! <C-L>")
          -- stylua: ignore
          pcall(function() vim.cmd("DBUIHideNotifications") end)
          require("notify").dismiss({})
        end,
        desc = "Refresh",
      },
      { "<leader><tab>j", "<cmd>tabprevious<cr>", desc = "Previous tab" },
      { "<leader><tab>k", "<cmd>tabnext<cr>", desc = "Next tab" },
      { "<leader><tab>h", "<cmd>tabfirst<cr>", desc = "First tab" },
      { "<leader><tab>l", "<cmd>tablast<cr>", desc = "Last tab" },
      { "<leader><tab>n", "<cmd>tabnew<cr>", desc = "New tab" },
      { "<leader><tab>1", "<cmd>tabfirst<cr>", desc = "First tab" },
      { "<leader><tab>2", "<cmd>tabnext 2<cr>", desc = "Second tab" },
      { "<leader><tab>3", "<cmd>tabnext 3<cr>", desc = "Third tab" },
      { "<leader><tab>4", "<cmd>tabnext 4<cr>", desc = "Fourth tab" },
      { "<leader><tab>5", "<cmd>tabnext 5<cr>", desc = "Fifth tab" },
      { "<leader><tab>6", "<cmd>tabnext 6<cr>", desc = "Sixth tab" },
      { "<leader><tab>7", "<cmd>tabnext 7<cr>", desc = "Seventh tab" },
      { "<leader><tab>8", "<cmd>tabnext 8<cr>", desc = "Eighth tab" },
      { "<leader><tab>9", "<cmd>tabnext 9<cr>", desc = "Ninth tab" },
      { "<leader><tab>0", "<cmd>tablast<cr>", desc = "Last tab" },
    },
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    keys = {
      {
        "<leader>l",
        function()
          if vim.opt.list:get() then
            vim.opt.list = false
            vim.g.miniindentscope_disable = true
            -- vim.opt.cursorline = false
            vim.opt.number = false
            -- vim.opt.relativenumber = false
          else
            vim.opt.list = true
            vim.g.miniindentscope_disable = false
            -- vim.opt.cursorline = true
            vim.opt.number = true
            -- vim.opt.relativenumber = true
          end
        end,
        desc = "Toggle list / indent lines",
      },
    },
  },
  {
    "rcarriga/nvim-notify",
    opts = {
      render = "default",
      fps = 120,
      timeout = 500,
    },
  },
  {
    "goolord/alpha-nvim",
    opts = function(_, _)
      local dashboard = require("alpha.themes.dashboard")
      local logo = "NVIM " .. require("utils").version()

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

      return {
        options = {
          theme = require("utils").ui.lualine_theme(),
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
    config = function()
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
    event = { "BufReadPost", "BufNewFile" },
  },
  {
    "s1n7ax/nvim-window-picker",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("window-picker").setup()
    end,
  },
  {
    "folke/zen-mode.nvim",
    dependencies = {
      { "folke/twilight.nvim", event = { "BufReadPost", "BufNewFile" }, cmd = { "Twilight", "TwilightEnable" } },
    },
    event = { "BufReadPost", "BufNewFile" },
    cmd = "ZenMode",
    keys = {
      { "<leader>z", "<cmd>ZenMode<cr>", desc = "Zen mode" },
      {
        "<leader>Z",
        function()
          if require("zen-mode.view").is_open() then
            require("zen-mode").toggle()
            return
          end

          local width = vim.fn.input({ prompt = "Zen mode width: ", default = "80", cancelreturn = "80" })

          require("zen-mode").toggle({
            window = {
              width = tonumber(width),
            },
          })
        end,
        desc = "Zen mode with custom width",
      },
    },
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
          enabled = false, -- NOTE: performs poorly
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
        vim.opt.winbar = ""
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
          ["cmp.entry.get_documentation"] = true,
        },
      },
    },
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-telescope/telescope-smart-history.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
      "danielfalk/smart-open.nvim",
      "ghassan0/telescope-glyph.nvim",
      "kkharji/sqlite.lua",
      "nvim-telescope/telescope-symbols.nvim",
      "xiyaowong/telescope-emoji.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
    },
    -- stylua: ignore
    cond = function() return vim.o.diff == false end,
    opts = function()
      local actions = require("telescope.actions")
      local themes = require("telescope.themes")

      local function telescope_paste_char(char)
        vim.api.nvim_put({ char.value }, "c", true, true)
      end

      return {
        defaults = {
          prompt_prefix = "   ",
          selection_caret = "   ",
          mappings = {
            i = {
              ["<esc>"] = actions.close,
              ["<C-c>"] = actions.close,
              ["<C-j>"] = actions.cycle_history_next,
              ["<C-k>"] = actions.cycle_history_prev,
              ["<C-b>"] = actions.preview_scrolling_up,
              ["<C-f>"] = actions.preview_scrolling_down,
            },
          },
          layout_config = {
            prompt_position = "top",
          },
          history = {
            path = vim.fn.stdpath("data") .. "/smart_history.sqlite3",
            cycle_wrap = true,
            limit = 100,
          },
        },
        extensions = {
          emoji = {
            action = telescope_paste_char,
          },
          glyph = {
            action = telescope_paste_char,
          },
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
          ["ui-select"] = {
            themes.get_dropdown({}),
          },
        },
      }
    end,
    config = function(_, opts)
      local telescope = require("telescope")
      local wk = require("which-key")

      wk.register({
        ["<leader><leader>"] = { "<cmd>Telescope smart_open<cr>", "Smart open" },
      })

      telescope.setup(opts)

      telescope.load_extension("notify")
      telescope.load_extension("ui-select")
      telescope.load_extension("glyph")
      telescope.load_extension("emoji")
      telescope.load_extension("smart_open")
      telescope.load_extension("fzf")

      if package.loaded["noice"] then
        telescope.load_extension("noice")
      end
    end,
    keys = {
      { "<leader>o", "<cmd>Telescope smart_open<cr>", desc = "Smart open" },
      { "<leader><leader>", nil, desc = "Smart open" },
      { "<leader>fs", "<cmd>Telescope smart_open<cr>", desc = "Smart open" },
    },
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ui = {
        border = "rounded",
        winhighlight = "Normal:Normal,FloatBorder:VertSplit,CursorLine:CursorLine,Search:Search",
      },
    },
  },
}
