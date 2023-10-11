return {
  {
    "rcarriga/nvim-notify",
    opts = {
      render = "default",
      timeout = 500,
      on_open = function(win)
        if vim.api.nvim_win_is_valid(win) then
          vim.api.nvim_win_set_config(win, { border = "single" })
        end
      end,
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
        dashboard.button("n", " " .. " new file", "<cmd>ene <bar> startinsert <cr>"),
        dashboard.button("r", " " .. " recent files", "<cmd>Telescope oldfiles <cr>"),
        dashboard.button("s", " " .. " load session", [[<cmd>lua require("persistence").load() <cr>]]),
        dashboard.button("f", " " .. " find file", "<cmd>Telescope find_files <cr>"),
        dashboard.button("o", " " .. " smart open", "<cmd>Telescope smart_open <cr>"),
        dashboard.button("g", " " .. " grep text", "<cmd>Telescope live_grep <cr>"),
        dashboard.button("c", " " .. " config", "<cmd>e $MYVIMRC <cr>"),
        dashboard.button("l", " " .. " lazy", "<cmd>Lazy<cr>"),
        dashboard.button("t", " " .. " terminal", "<cmd>lua require('lazyvim.util').float_term()<cr>"),
        dashboard.button("d", " " .. " database", "<cmd>enew<cr><cmd>DBUI<cr>"),
        dashboard.button("q", " " .. " quit", "<cmd>qa<cr>"),
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
      local utils = require("utils")

      return {
        options = {
          theme = utils.ui.lualine_theme(),
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
              ---@diagnostic disable-next-line: undefined-field
              function() return require("noice").api.status.command.get() end,
              ---@diagnostic disable-next-line: undefined-field
              cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
            },
            -- stylua: ignore
            {
              ---@diagnostic disable-next-line: undefined-field
              function() return require("noice").api.status.mode.get() end,
              ---@diagnostic disable-next-line: undefined-field
              cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
            },
            {
              require("lazy.status").updates,
              cond = require("lazy.status").has_updates,
            },
            "encoding",
            {
              "filetype",
              icon_only = true,
            },
            "fileformat",
          },
          lualine_y = { "location" },
          lualine_z = { "progress" },
        },
        extensions = { "neo-tree" },
      }
    end,
    keys = {
      {
        "<leader>S",
        function()
          if vim.opt.laststatus:get() == 0 then
            vim.opt.laststatus = 3
          else
            vim.opt.laststatus = 0
          end
        end,
        desc = "Toggle Statusline",
      },
    },
  },
  {
    "norcalli/nvim-colorizer.lua",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "ColorizerToggle", "ColorizerAttachToBuffer", "ColorizerReloadAllBuffers" },
    init = function()
      vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
        group = vim.api.nvim_create_augroup("ColorizerReload", { clear = true }),
        callback = function()
          vim.cmd("ColorizerAttachToBuffer")
        end,
      })
    end,
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
      { "<M-c>", "<cmd>PickColor<cr>", desc = "Pick Color" },
      { "<M-c>", "<cmd>PickColorInsert<cr>", desc = "Pick Color", mode = "i" },
    },
  },
  {
    "folke/zen-mode.nvim",
    dependencies = {
      {
        "folke/twilight.nvim",
        event = { "BufReadPost", "BufNewFile" },
        cmd = { "Twilight", "TwilightEnable" },
        opts = {
          dimming = {
            inactive = true,
          },
        },
        keys = {
          {
            "<leader>t", -- Enable Twilight
            function()
              require("twilight").toggle()
            end,
            desc = "Toggle Twilight",
          },
        },
      },
    },
    event = { "BufReadPost", "BufNewFile" },
    cmd = "ZenMode",
    keys = {
      {
        "<leader>z",
        function()
          if require("zen-mode.view").is_open() then
            require("zen-mode").toggle()
            return
          end

          if vim.g.zen_mode_width then
            require("zen-mode").toggle({
              window = {
                width = tonumber(vim.g.zen_mode_width),
              },
            })
            return
          end

          require("zen-mode").toggle()
        end,
        desc = "Toggle Zen Mode",
      },
      {
        "<leader>Z",
        function()
          if require("zen-mode.view").is_open() then
            require("zen-mode").toggle()
            return
          end

          local width = vim.fn.input({ prompt = "Zen mode width: ", default = "100", cancelreturn = "100" })

          require("zen-mode").toggle({
            window = {
              width = tonumber(width),
            },
          })

          vim.g.zen_mode_width = width
        end,
        desc = "Toggle Zen Mode With Custom Width",
      },
    },
    opts = {
      window = {
        width = 100,
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
          enabled = true,
          font = "+2",
        },
        alacritty = {
          enabled = true,
          font = "+2",
        },
      },
      on_open = function(_)
        vim.opt.laststatus = 0
        vim.o.winbar = ""
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
      views = {
        cmdline_popup = {
          border = { style = "single" },
        },
        notify = {
          border = { style = "single" },
        },
        popup = {
          border = { style = "single" },
        },
        confirm = {
          border = { style = "single" },
        },
        hover = {
          border = { style = "single" },
        },
        popupmenu = {
          border = { style = "single" },
        },
      },
      lsp = {
        override = {
          ["cmp.entry.get_documentation"] = true,
        },
      },
      popupmenu = {
        backend = "cmp",
      },
    },
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "kkharji/sqlite.lua",
      "nvim-telescope/telescope-smart-history.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
      "danielfalk/smart-open.nvim",
      "ghassan0/telescope-glyph.nvim",
      "xiyaowong/telescope-emoji.nvim",
      "nvim-telescope/telescope-fzy-native.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    -- stylua: ignore
    enabled = not vim.o.diff,
    opts = function()
      local actions = require("telescope.actions")
      local themes = require("telescope.themes")

      local function telescope_paste_char(char)
        vim.api.nvim_put({ char.value }, "c", false, true)
      end

      return {
        defaults = {
          preview = {
            treesitter = false,
          },
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
          -- borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" }, -- rounded
          borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" }, -- straight
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
          fzy_native = {
            override_generic_sorter = false,
            override_file_sorter = true,
          },
          ["ui-select"] = {
            themes.get_dropdown({
              -- borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" }, -- rounded
              borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" }, -- straight
            }),
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
      telescope.load_extension("fzy_native")
      telescope.load_extension("fzf")

      if package.loaded["noice"] then
        telescope.load_extension("noice")
      end
    end,
    keys = {
      { "<leader><leader>", nil, desc = "Smart Open" },
      { "<leader>fs", "<cmd>Telescope smart_open<cr>", desc = "Smart Open" },
      { "<leader>ss", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Goto Symbol" },
      { "<leader>sS", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", desc = "Goto Symbol (Workspace)" },
    },
  },
  {
    "williamboman/mason.nvim",
    opts = {
      pip = {
        upgrade_pip = true,
      },
      ui = {
        border = "single",
        winhighlight = "Normal:Normal,FloatBorder:VertSplit,CursorLine:CursorLine,Search:Search",
      },
    },
  },
  {
    "folke/which-key.nvim",
    opts = {
      window = {
        position = "top",
        -- border = "rounded",
        margin = { 0, 0, 0, 0 },
        padding = { 1, 0, 1, 0 },
        winblend = 5,
      },
    },
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show()
        end,
        desc = "Show Which Key",
      },
    },
  },
  {
    "SmiteshP/nvim-navic",
    config = function(_, opts)
      require("nvim-navic").setup(opts)

      vim.o.winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"
    end,
    opts = {
      safe_output = true,
      click = true,
      lsp = {
        auto_attach = true,
      },
    },
  },
}
