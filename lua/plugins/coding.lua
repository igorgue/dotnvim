return {
  {
    "saghen/blink.cmp",
    optional = true,
    dependencies = {
      "moyiz/blink-emoji.nvim",
      { "saghen/blink.compat", version = "*" },
    },
    opts = {
      enabled = function()
        return not vim.tbl_contains(vim.g.cmp_disabled_filetypes, vim.bo.filetype)
      end,
      completion = {
        list = {
          selection = {
            preselect = true,
            auto_insert = false,
          },
        },
        accept = {
          auto_brackets = {
            enabled = true,
          },
        },
        menu = {
          border = "rounded",
          auto_show = false,
        },
        documentation = {
          window = {
            border = "rounded",
          },
        },
        trigger = {
          show_in_snippet = true,
        },
      },
      signature = {
        enabled = false,
        trigger = {
          show_on_insert_on_trigger_character = false,
        },
        window = {
          border = "rounded",
        },
      },
      keymap = {
        preset = "enter",
        ["<C-space>"] = { "show" },
        ["<C-y>"] = { "show", "select_and_accept", "fallback" },
        ["<Tab>"] = {},
        ["<C-e>"] = { "hide" },
        ["<C-j>"] = {
          LazyVim.cmp.map({ "snippet_forward", "ai_accept" }),
          "show",
          "select_and_accept",
          "fallback",
        },
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer", "emoji" },
        providers = {
          emoji = {
            module = "blink-emoji",
            name = "Emoji",
            score_offset = 15,
          },
          snippets = {
            opts = {
              extended_filetypes = {
                jinja = { "html", "djangohtml" },
              },
            },
          },
        },
      },
    },
  },
  {
    "hrsh7th/nvim-cmp",
    optional = true,
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      "hrsh7th/cmp-cmdline",
      {
        "folke/noice.nvim",
        opts = {
          popupmenu = {
            backend = "cmp",
          },
        },
      },
    },
    opts = function(_, opts)
      local cmp = require("cmp")

      local sources = {
        {
          { name = "nvim_lsp" },
          { name = "nvim_lua" },
          { name = "luasnip" },
          -- XXX: these two need to be on their own plugin spec
          { name = "pypi", keyword_length = 4 },
          { name = "sonicpi" },
        },
        {
          { name = "buffer" },
          { name = "path" },
        },
      }

      local mappings = {
        ["<C-b>"] = cmp.mapping.scroll_docs(-3),
        ["<C-f>"] = cmp.mapping.scroll_docs(3),
        ["<C-n>"] = cmp.mapping.select_next_item({
          behavior = cmp.SelectBehavior.Insert,
        }),
        ["<C-p>"] = cmp.mapping.select_prev_item({
          behavior = cmp.SelectBehavior.Insert,
        }),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<CR>"] = LazyVim.cmp.confirm({ select = true }),
        ["<C-y>"] = LazyVim.cmp.confirm({ select = true }),
        ["<S-CR>"] = LazyVim.cmp.confirm({
          behavior = cmp.ConfirmBehavior.Replace,
        }),
        ["<C-CR>"] = function(fallback)
          cmp.abort()
          fallback()
        end,
        ["<C-j>"] = cmp.mapping(function(fallback)
          local luasnip = require("luasnip")

          if luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end),
        ["<C-k>"] = cmp.mapping(function(fallback)
          local luasnip = require("luasnip")

          if luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end),
      }

      local winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:CursorLine,Search:Search"

      cmp.setup.filetype("gitcommit", {
        sources = cmp.config.sources({
          { name = "cmp_git" },
          { name = "nvim_lsp" },
          { name = "nvim_lua" },
          { name = "buffer" },
          { name = "path" },
        }),
      })

      local cmd_mappings = {
        ["<Tab>"] = cmp.mapping.confirm({
          behavior = cmp.ConfirmBehavior.Replace,
          select = true,
        }),
      }

      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(cmd_mappings),
        sources = {
          { name = "nvim_lsp" },
          { name = "buffer" },
          { name = "path" },
        },
        ---@diagnostic disable-next-line: missing-fields
        view = { entries = { follow_cursor = false } },
      })

      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(cmd_mappings),
        sources = cmp.config.sources({
          { name = "cmdline" },
          { name = "path" },
          { name = "buffer" },
        }),
        ---@diagnostic disable-next-line: missing-fields
        view = { entries = { follow_cursor = false } },
      })

      opts.window = {
        completion = cmp.config.window.bordered({
          winhighlight = winhighlight,
          border = "rounded",
        }),
        documentation = cmp.config.window.bordered({
          winhighlight = winhighlight,
          border = "rounded",
        }),
        preview = cmp.config.window.bordered({
          winhighlight = winhighlight,
          border = "rounded",
        }),
      }

      opts.sources = cmp.config.sources(sources[1], sources[2])

      opts.mapping = cmp.mapping.preset.insert(mappings)
      opts.experimental = {}
      opts.view = { docs = { auto_open = true }, entries = { follow_cursor = true } }
      opts.completion = { autocomplete = false }

      return opts
    end,
  },
  {
    "nvim-pack/nvim-spectre",
    opts = {
      highlight = {
        ui = "String",
        search = "IncSearch",
        replace = "DiffChange",
        border = "FloatBorder",
      },
    },
  },
  {
    "numToStr/Comment.nvim",
    event = { "BufReadPost", "BufNewFile" },
    -- FIXME: this doesn't quite work with kittyscrollback
    -- enabled = vim.fn.has("nvim-0.10.0") == 0,
    config = true,
  },
  {
    "folke/todo-comments.nvim",
    opts = {
      signs = false,
    },
  },
}
