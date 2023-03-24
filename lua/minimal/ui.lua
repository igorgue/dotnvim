local lazyvim_util = require("lazyvim.util")

return {
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
                vim.cmd("DiffviewOpen")
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
}
