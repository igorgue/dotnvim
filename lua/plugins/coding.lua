return {
  {
    "L3MON4D3/LuaSnip",
    enabled = vim.version().major < 10,
  },
  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      "hrsh7th/cmp-cmdline",
    },
    opts = function(_, opts)
      local cmp = require("cmp")
      local sources = {
        {
          { name = "nvim_lsp" },
          { name = "nvim_lua" },
        },
        {
          { name = "buffer" },
          { name = "path" },
        },
      }

      if vim.version().major < 10 then
        vim.list_extend(sources[1], { { name = "luasnip" } })
      end

      local mappings = {
        ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
        ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
        ["<C-b>"] = cmp.mapping.scroll_docs(-3),
        ["<C-f>"] = cmp.mapping.scroll_docs(3),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        ["<S-CR>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
      }

      if vim.version().major < 10 then
        mappings["<C-j>"] = cmp.mapping(function(fallback)
          local luasnip = require("luasnip")
          if luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end)
        mappings["<C-k>"] = cmp.mapping(function(fallback)
          local luasnip = require("luasnip")
          if luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end)
      else
        mappings["<C-j>"] = {
          function()
            if vim.snippet.active({ direction = 1 }) then
              vim.schedule(function()
                vim.snippet.jump(1)
              end)
              return
            end
            return "<C-j>"
          end,
          expr = true,
          silent = true,
          mode = "i",
        }
        mappings["<C-j>"] = {
          function()
            vim.schedule(function()
              vim.snippet.jump(1)
            end)
          end,
          silent = true,
          mode = "s",
        }
        mappings["<C-k>"] = {
          function()
            if vim.snippet.active({ direction = -1 }) then
              vim.schedule(function()
                vim.snippet.jump(-1)
              end)
              return
            end
            return "<S-Tab>"
          end,
          expr = true,
          silent = true,
          mode = { "i", "s" },
        }
      end

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
        view = { entries = { follow_cursor = false, selection_order = "near_cursor", name = "native" } },
      })

      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(cmd_mappings),
        sources = cmp.config.sources({
          { name = "cmdline" },
          { name = "path" },
          { name = "buffer" },
        }),
        view = { entries = { follow_cursor = false, selection_order = "near_cursor", name = "native" } },
      })

      opts.window = {
        completion = cmp.config.window.bordered({ winhighlight = winhighlight, border = "rounded" }),
        documentation = cmp.config.window.bordered({ winhighlight = winhighlight, border = "rounded" }),
        preview = cmp.config.window.bordered({ winhighlight = winhighlight, border = "rounded" }),
      }

      opts.sources = cmp.config.sources(sources[1], sources[2])

      opts.mapping = cmp.mapping.preset.insert(mappings)
      opts.experimental = {}
      opts.view = { docs = { auto_open = false }, entries = { follow_cursor = true } }
      opts.completion = {
        autocomplete = false,
      }
      opts.formatting = {}

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
    -- FIXME: this doesn't quite  work with kittyscrollback
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
