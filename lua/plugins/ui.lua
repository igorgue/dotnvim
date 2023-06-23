local lazyvim_util = require("lazyvim.util")

return {
  {
    "lukas-reineke/indent-blankline.nvim",
    init = function()
      vim.g.indent_blankline_disable_with_nolist = true
      vim.g.indent_blankline_use_treesitter = false

      -- indent scope
      vim.g.miniindentscope_disable = true
    end,
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
        desc = "Toggle List & Indent Lines",
      },
    },
  },
  {
    "rcarriga/nvim-notify",
    opts = {
      render = "default",
      fps = 120,
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
        dashboard.button("n", " " .. " new file", ":ene <bar> startinsert <cr>"),
        dashboard.button("r", " " .. " recent files", ":Telescope oldfiles <cr>"),
        dashboard.button("s", " " .. " load session", [[:lua require("persistence").load() <cr>]]),
        dashboard.button("f", " " .. " find file", ":Telescope find_files <cr>"),
        dashboard.button("o", " " .. " smart open", ":Telescope smart_open <cr>"),
        dashboard.button("g", " " .. " grep text", ":Telescope live_grep <cr>"),
        dashboard.button("c", " " .. " config", ":e $MYVIMRC <cr>"),
        dashboard.button("l", "鈴" .. " lazy", ":Lazy<cr>"),
        -- stylua: ignore
        dashboard.button("t", " " .. " terminal", ":lua require('lazyvim.util').float_term()<cr>"),
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
    init = function()
      vim.api.nvim_create_autocmd("Colorscheme", {
        callback = function()
          if vim.o.diff ~= false then
            return
          end

          local config = require("lualine").get_config()

          config.options.theme = require("utils").ui.lualine_theme()

          require("lualine").setup(config)
        end,
      })
    end,
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
            {
              "branch",
              on_click = function()
                local branches = vim.split(vim.api.nvim_exec("silent !git branch", true), "\n")
                local current_branch = vim.split(vim.api.nvim_exec("silent !git branch --show-current", true), "\n")[3]
                local cleanup_re = "^%s*(.-)%s*$"

                -- cleanup branches
                for i = #branches, 1, -1 do
                  if branches[i] == "" or branches[i]:sub(1, 1) == ":" then
                    table.remove(branches, i)
                  elseif branches[i]:sub(1, 1) == "*" then
                    branches[i] = branches[i]:sub(3)
                  end
                end

                -- trim whitespace
                for i = 1, #branches do
                  branches[i] = branches[i]:gsub(cleanup_re, "%1")
                end
                current_branch = current_branch:gsub(cleanup_re, "%1")

                -- sort by current
                for i = 1, #branches do
                  if branches[i] == current_branch then
                    table.remove(branches, i)
                    table.insert(branches, 1, current_branch)
                    break
                  end
                end

                vim.ui.select(branches, { prompt = "Select Branch" }, function(branch)
                  vim.cmd("Git checkout " .. branch)
                end)
              end,
            },
            {
              "diff",
              symbols = {
                added = icons.git.added,
                modified = icons.git.modified,
                removed = icons.git.removed,
              },
              on_click = function()
                local view = require("diffview.lib").get_current_view()

                if view then
                  vim.cmd("DiffviewClose")
                else
                  vim.cmd("DiffviewOpen")
                end
              end,
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
            {
              "encoding",
              on_click = function()
                local current_encoding = vim.opt_local.fileencoding:get()
                local encoding =
                  vim.fn.input({ prompt = "Encoding: ", default = current_encoding, cancelreturn = current_encoding })

                vim.cmd("setlocal fileencoding=" .. encoding)
              end,
            },
            {
              "filetype",
              icon_only = true,
              on_click = function(_, button)
                local filetype = vim.bo.filetype

                vim.cmd("LspInfo")

                vim.notify(filetype, vim.log.levels.INFO, { title = "Filetype" })
                -- vim.ui.select({
                --   "Restart",
                --   "Stop",
                --   "Start",
                -- }, {
                --   prompt = "LSP Server:",
                -- }, function(choice)
                --   vim.cmd("Lsp" .. choice)
                -- end)
              end,
            },
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
      { "folke/twilight.nvim", event = { "BufReadPost", "BufNewFile" }, cmd = { "Twilight", "TwilightEnable" } },
    },
    event = { "BufReadPost", "BufNewFile" },
    cmd = "ZenMode",
    keys = {
      { "<leader>z", "<cmd>ZenMode<cr>", desc = "Zen Mode" },
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
        desc = "Zen Mode With Custom Width",
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
      "nvim-telescope/telescope-smart-history.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
      "danielfalk/smart-open.nvim",
      "ghassan0/telescope-glyph.nvim",
      "kkharji/sqlite.lua",
      "nvim-telescope/telescope-symbols.nvim",
      "xiyaowong/telescope-emoji.nvim",
      "nvim-telescope/telescope-fzy-native.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
    },
    -- stylua: ignore
    cond = function() return not vim.o.diff end,
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
      { "<leader>o", "<cmd>Telescope smart_open<cr>", desc = "Smart Open" },
      { "<leader><leader>", nil, desc = "Smart Open" },
      { "<leader>fs", "<cmd>Telescope smart_open<cr>", desc = "Smart Open" },
      { "<leader>ss", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Goto Symbol" },
      { "<leader>sS", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", desc = "Goto Symbol (Workspace)" },
    },
  },
  {
    "williamboman/mason.nvim",
    opts = {
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
  },
  {
    "SmiteshP/nvim-navic",
    config = function(_, opts)
      require("nvim-navic").setup(opts)

      vim.o.winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"
    end,
  },
}
