local function resume_snacks_picker()
  if not require("snacks.picker.core.picker").last then
    Snacks.picker.smart()
  else
    Snacks.picker.resume()
  end
end

return {
  {
    "nvim-tree/nvim-web-devicons",
    opts = {
      variant = "dark",
    },
  },
  {
    "folke/snacks.nvim",
    opts = {
      image = {},
      dashboard = {
        preset = {
          header = "NVIM " .. require("utils").version(),
          -- stylua: ignore
          ---@type snacks.dashboard.Item[]
          keys = {
            { icon = " ", key = "n", desc = "new file", action = ":ene | startinsert" },
            { icon = " ", key = "r", desc = "recent files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
            { icon = " ", key = "s", desc = "restore session", section = "session" },
            { icon = " ", key = "f", desc = "find file", action = ":lua Snacks.dashboard.pick('files')" },
            { icon = " ", key = "o", desc = "smart open", action = ":lua Snacks.picker.smart()" },
            { icon = " ", key = "g", desc = "find text", action = function()
              if vim.g.lazyvim_picker == "telescope" then
                require("plugins.telescope.filter_grep").filter_grep()
              else
                Snacks.dashboard.pick('live_grep')
              end
            end},
            { icon = " ", key = "c", desc = "config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
            { icon = "󰒲 ", key = "l", desc = "lazy", action = ":Lazy" },
            { icon = " ", key = "x", desc = "lazy extras", action = ":LazyExtras" },
            { icon = " ", key = "t", desc = "terminal", action = ":ene | :lua Snacks.terminal()" },
            { icon = " ", key = "d", desc = "database", action = ":ene | DBUI" },
            { icon = " ", key = "q", desc = "quit", action = ":qa" },
          },
        },
      },
      zen = {
        toggles = {
          dim = false,
          git_signs = false,
          diagnostics = false,
          inlay_hints = false,
        },
        win = {
          style = {
            backdrop = { transparent = true, blend = 10 },
          },
        },
      },
      indent = { enabled = false, only_scope = true, only_current = true },
      input = {},
      picker = {
        enabled = vim.g.lazyvim_picker == "snacks",
        ui_select = true,
        matcher = {
          sort_empty = true, -- sort results when the search string is empty
          cwd_bonus = true, -- give bonus for matching files in the cwd
          frecency = true, -- frecency bonus
          history_bonus = true, -- give more weight to chronological order
        },
        formatter = {
          file = {
            filename_first = true, -- display filename before the file path
          },
        },
        jump = {
          jumplist = true, -- save the current position in the jumplist
          tagstack = true, -- save the current position in the tagstack
          reuse_win = true, -- reuse an existing window if the buffer is already open
          close = true, -- close the picker when jumping/editing to a location (defaults to true)
          match = true, -- jump to the first match position. (useful for `lines`)
        },
        win = {
          preview = {
            wo = {
              foldcolumn = "0",
              number = false,
              relativenumber = false,
              signcolumn = "no",
            },
          },
          input = {
            keys = {
              ["<Esc>"] = { "close", mode = { "n", "i" } },
              ["<c-cr>"] = { "close", mode = { "n", "i" } },
              ["<c-j>"] = { "history_back", mode = { "n", "i" } },
              ["<c-k>"] = { "history_forward", mode = { "n", "i" } },
              ["<c-/>"] = { "toggle_focus", mode = { "n", "i" } },
              ["<c-i>"] = { "toggle_focus", mode = { "n", "i" } },
              -- stylua: ignore start
              ["<c-u>"] = { function() vim.cmd("normal! dd") end, mode = { "n", "i" }, },
              ["<c-a>"] = { function() vim.cmd([[normal! ^i]]) end, mode = { "n", "i" }, },
              ["<c-e>"] = { function() vim.cmd([[normal! A]]) vim.api.nvim_input("<right>") end, mode = { "n", "i" }, },
              -- stylua: ignore end
              ["<c-s-a>"] = "select_all",
              ["<c-s-u>"] = { "list_scroll_up", mode = { "i", "n" } },
            },
          },
          list = {
            keys = {
              ["o"] = "confirm",
              ["<Esc>"] = { "close", mode = { "n", "i" } },
              ["<c-cr>"] = { "close", mode = { "n", "i" } },
              ["<c-o>"] = { "confirm", mode = { "n", "i" } },
              ["<c-^>"] = { "confirm", mode = { "n", "i" } },
              ["<c-i>"] = { "toggle_focus", mode = { "n", "i" } },
              ["<c-/>"] = { "toggle_focus", mode = { "n", "i" } },
              ["s"] = { "edit_split" },
              ["S"] = { "edit_vsplit" },
              ["<leader><leader>"] = "close",
            },
          },
        },
        sources = {
          explorer = {
            win = {
              list = {
                keys = {
                  ["o"] = "confirm",
                  ["<Esc>"] = { "close", mode = { "n", "i" } },
                  ["<c-cr>"] = { "close", mode = { "n", "i" } },
                  ["<c-o>"] = { "confirm", mode = { "n", "i" } },
                  ["<c-^>"] = { "confirm", mode = { "n", "i" } },
                  ["<c-i>"] = { "toggle_focus", mode = { "n", "i" } },
                  ["<c-/>"] = { "toggle_focus", mode = { "n", "i" } },
                  ["s"] = { "edit_split" },
                  ["S"] = { "edit_vsplit" },
                  ["<leader><leader>"] = "close",
                },
              },
            },
          },
        },
      },
    },
    keys = {
      -- stylua: ignore start
      { "<leader><leader>", resume_snacks_picker, desc = "Resume" },
      { "<c-cr>", resume_snacks_picker, desc = "Resume", mode = { "n", "i" } },
      { "<leader>r", function() Snacks.picker.recent() end, desc = "Recent" },
      { "<leader>j", function() Snacks.picker.jumps() end, desc = "Jumps" },
      { "<leader><cr>", function() Snacks.picker.smart() end, desc = "Smart" },
      { "<leader>fs", function() Snacks.picker.smart() end, desc = "Smart" },
      -- stylua: ignore end
    },
  },
  {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    optional = true,
    opts = function()
      local logo = "NVIM " .. require("utils").version()

      logo = string.rep("\n", 10) .. logo .. "\n\n"

      local opts = {
        theme = "doom",
        hide = {
          -- this is taken care of by lualine
          -- enabling this messes up the actual laststatus setting after loading a file
          statusline = false,
        },
        config = {
          header = vim.split(logo, "\n"),
          center = {
            { action = "ene | startinsert", desc = " new file", icon = " ", key = "n" },
            { action = "Telescope oldfiles", desc = " recent files", icon = " ", key = "r" },
            { action = 'lua require("persistence").load()', desc = " restore session", icon = " ", key = "s" },
            { action = LazyVim.pick("auto"), desc = " find file", icon = " ", key = "f" },
            { action = "Telescope smart_open", desc = " smart open", icon = " ", key = "o" },
            { action = LazyVim.pick("live_grep"), desc = " find text", icon = " ", key = "g" },
            { action = LazyVim.pick.config_files(), desc = " Config", icon = " ", key = "c" },
            { action = "Lazy", desc = " lazy", icon = "󰒲 ", key = "l" },
            { action = "LazyExtras", desc = " lazy extras", icon = " ", key = "x" },
            { action = "lua require('lazyvim.util').terminal.open()", desc = " terminal", icon = " ", key = "t" },
            { action = "ene | DBUI", desc = " database", icon = " ", key = "d" },
            { action = "qa", desc = " quit", icon = " ", key = "q" },
          },
          footer = function()
            local stats = require("lazy").stats()
            local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
            return {
              "⚡ Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms",
            }
          end,
        },
      }

      for _, button in ipairs(opts.config.center) do
        button.desc = button.desc .. string.rep(" ", 43 - #button.desc)
      end

      -- close Lazy and re-open when the dashboard is ready
      if vim.o.filetype == "lazy" then
        vim.cmd.close()
        vim.api.nvim_create_autocmd("User", {
          pattern = "DashboardLoaded",
          callback = function()
            require("lazy").show()
          end,
        })
      end

      return opts
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
              path = 0,
              symbols = {
                modified = "",
                readonly = "",
                new = "",
                unnamed = "",
              },
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
            {
              "filetype",
              icon_only = true,
            },
          },
          lualine_y = { "location" },
          lualine_z = { "progress" },
        },
        extensions = { "neo-tree" },
      }
    end,
  },
  {
    "catgoose/nvim-colorizer.lua",
    event = { "BufReadPost", "BufNewFile" },
    cmd = {
      "ColorizerToggle",
      "ColorizerAttachToBuffer",
      "ColorizerReloadAllBuffers",
    },
    opts = {
      filetypes = {
        "*",
        "!neorepl",
        "!TelescopePrompt",
        "!TelescopeResults",
        "!codecompanion",
      },
      buftypes = {
        "*",
        "!prompt",
        "!popup",
      },
      user_default_options = {
        RGB = true,
        RRGGBB = true,
        names = true,
        RRGGBBAA = true,
        rgb_fn = true,
        hsl_fn = true,
        css = true,
        css_fn = true,
        mode = "background",
        tailwind = true,
        tailwind_opts = {
          update_names = true,
        },
        -- PERF: this feature is very slow
        sass = { enable = false, parsers = { "css" } },
        always_update = true,
      },
    },
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
    optional = true,
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
            "<leader>ut", -- Enable Twilight
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
        "<leader>uz",
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
        "<leader>uZ",
        function()
          if require("zen-mode.view").is_open() then
            require("zen-mode").toggle()
            return
          end

          local width = vim.fn.input({
            prompt = "Zen mode width: ",
            default = "100",
            cancelreturn = "100",
          })

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
        width = 80,
        options = {
          -- signcolumn = "no", -- disable signcolumn
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
          enabled = false,
        },
        gitsigns = {
          enabled = true,
        },
        kitty = {
          enabled = false, -- messes up with other windows
          font = "+1",
        },
        alacritty = {
          enabled = false, -- I suspect the same as kitty
          font = "+1",
        },
      },
      on_open = function(_)
        -- vim.opt.laststatus = 0
        vim.o.winbar = ""
      end,
      -- on_close = function()
      --   vim.opt.laststatus = 3
      -- end,
    },
  },
  {
    "folke/noice.nvim",
    opts = {
      lsp = {
        hover = {
          silent = true,
        },
        override = {
          ["cmp.entry.get_documentation"] = true,
        },
        signature = {
          auto_open = {
            enabled = false,
          },
        },
      },
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
      -- views = {
      --   cmdline_popup = {
      --     border = { style = "single" },
      --   },
      --   notify = {
      --     border = { style = "single" },
      --   },
      --   popup = {
      --     border = { style = "single" },
      --   },
      --   confirm = {
      --     border = { style = "single" },
      --   },
      --   hover = {
      --     border = { style = "single" },
      --   },
      --   popupmenu = {
      --     border = { style = "single" },
      --   },
      -- },
    },
  },
  {
    "ibhagwan/fzf-lua",
    optional = true,
    opts = {
      previewers = {
        builtin = {
          extensions = {
            -- neovim terminal only supports `viu` block output
            ["png"] = { "viu", "-b" },
            -- by default the filename is added as last argument
            -- if required, use `{file}` for argument positioning
            ["svg"] = { "chafa", "{file}" },
            ["jpg"] = { "ueberzug" },
          },
        },
      },
    },
    keys = {
      { "<leader>r", "<cmd>FzfLua oldfiles<cr>", desc = "Recent" },
    },
  },
  {
    "nvim-telescope/telescope.nvim",
    optional = true,
    enabled = vim.g.lazyvim_picker == "telescope",
    dependencies = {
      "kkharji/sqlite.lua",
      "nvim-telescope/telescope-smart-history.nvim",
      "danielfalk/smart-open.nvim",
      "alduraibi/telescope-glyph.nvim",
      "xiyaowong/telescope-emoji.nvim",
      "nvim-telescope/telescope-symbols.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    lazy = false,
    opts = function()
      local actions = require("telescope.actions")

      local function telescope_paste_char(char)
        vim.api.nvim_put({ char.value }, "c", false, true)
      end

      return {
        pickers = {
          colorscheme = {
            enable_preview = true,
          },
        },
        defaults = {
          preview = {
            treesitter = vim.env.NVIM_TS_ENABLE ~= nil,
          },
          prompt_prefix = " ",
          selection_caret = "▌ ",
          mappings = {
            i = {
              ["<esc>"] = actions.close,
              ["<C-c>"] = actions.close,
              ["<C-b>"] = actions.preview_scrolling_up,
              ["<C-f>"] = actions.preview_scrolling_down,
              ["<C-j>"] = actions.cycle_history_prev,
              ["<C-k>"] = actions.cycle_history_next,
              ["<C-p>"] = actions.move_selection_previous,
              ["<C-n>"] = actions.move_selection_next,
              -- stylua: ignore start
              ["<C-w>"] = function() vim.api.nvim_input("<c-s-w>") end,
              ["<C-a>"] = function() vim.cmd([[normal! ^i]]) end,
              ["<C-e>"] = function() vim.cmd([[normal! A]]) vim.api.nvim_input("<right>") end,
              ["<C-u>"] = function() vim.cmd([[normal! dd]]) end,
              -- stylua: ignore end
            },
          },
          layout_config = {
            prompt_position = "top",
          },
          sorting_strategy = "ascending",
          history = {
            path = vim.fn.stdpath("data") .. "/smart_history.sqlite3",
            cycle_wrap = true,
            limit = 100,
          },
          borderchars = {
            "─",
            "│",
            "─",
            "│",
            "╭",
            "╮",
            "╯",
            "╰",
          }, -- rounded
          -- borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" }, -- straight
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
          smart_open = {
            match_algorithm = "fzf",
          },
        },
      }
    end,
    config = function(_, opts)
      local telescope = require("telescope")

      local function restore()
        if vim.bo.filetype == "TelescopePrompt" then
          require("telescope.actions").close(vim.api.nvim_get_current_buf())
        else
          local cached_pickers = require("telescope.state").get_global_key("cached_pickers")

          if cached_pickers and next(cached_pickers) then
            require("telescope.builtin").resume()
          else
            vim.cmd("Telescope smart_open")
          end
        end
      end

      -- NOTE: this is needed here because it cannot be mapped from the other
      -- place for some reason I don't want to investigate...
      if vim.g.lazyvim_picker == "telescope" then
        require("which-key").add({
          {
            "<c-cr>",
            restore,
            desc = "Telescope Restore / Smart Open",
            mode = { "n", "i" },
          },
          {
            "<leader><leader>",
            restore,
            desc = "Telescope Restore / Smart Open",
            mode = "n",
          },
        })
      end

      telescope.setup(opts)

      telescope.load_extension("glyph")
      telescope.load_extension("emoji")
      telescope.load_extension("smart_open")
      telescope.load_extension("fzf")

      if package.loaded["noice"] then
        telescope.load_extension("noice")
      end
    end,
    keys = {
      {
        "<leader>/",
        function()
          require("plugins.telescope.filter_grep").filter_grep()
        end,
        desc = "Filter Grep",
      },
      { "<leader><cr>", "<cmd>Telescope smart_open<cr>", desc = "Smart Open" },
      { "<leader>fs", "<cmd>Telescope smart_open<cr>", desc = "Smart Open" },
      { "<leader>r", "<cmd>Telescope oldfiles<cr>", desc = "Recent" },
      {
        "<leader>fC",
        function()
          require("plugins.telescope.filter_grep").filter_grep({
            cwd = vim.fn.stdpath("config"),
          })
        end,
        desc = "Config dir's filter grep files",
      },
      {
        "<leader>fl",
        function()
          require("telescope.builtin").find_files({
            cwd = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy"),
          })
        end,
        desc = "Lazy dir's find files",
      },
      {
        "<leader>fL",
        function()
          require("plugins.telescope.filter_grep").filter_grep({
            cwd = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy"),
          })
        end,
        desc = "Lazy dir's filter grep files",
      },
    },
  },
  {
    "williamboman/mason.nvim",
    opts = {
      pip = {
        upgrade_pip = true,
      },
      ui = {
        -- border = "single",
        border = "rounded",
        winhighlight = "Normal:Normal,FloatBorder:VertSplit,CursorLine:CursorLine,Search:Search",
      },
    },
  },
  {
    "SmiteshP/nvim-navic",
    optional = true,
    lazy = false,
    config = function(_, opts)
      require("nvim-navic").setup(opts)

      vim.o.winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"
    end,
    opts = {
      click = true,
    },
  },
  {
    "mattn/webapi-vim",
    event = { "BufReadPost", "BufNewFile" },
  },
  {
    "s1n7ax/nvim-window-picker",
    name = "window-picker",
    event = "VeryLazy",
    optional = true,
    config = function()
      require("window-picker").setup()
    end,
  },
}
