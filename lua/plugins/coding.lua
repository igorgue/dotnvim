--- Triggers a snippet if full snippet label is typed
--- else just show the completion menu with only snippets
--- useful for ctrl+j and probably <Tab> but I cannot
--- get to keymap that, I don't know how to override its behavior
--- @module "blink.cmp"
--- @param cmp blink.cmp.API
local function trigger_snippet(cmp)
  cmp.show({
    providers = { "snippets" },
    callback = function()
      local line = vim.api.nvim_get_current_line()
      local col = vim.fn.col(".")
      local start_col = col
      local end_col = col

      while start_col > 1 and line:sub(start_col - 1, start_col - 1):match("[%w_]") do
        start_col = start_col - 1
      end

      while end_col <= #line and line:sub(end_col, end_col):match("[%w_]") do
        end_col = end_col + 1
      end

      vim.schedule(function()
        local items = cmp.get_items()
        local word = line:sub(start_col, end_col - 1)
        if #items > 0 and word == items[1].label then
          cmp.accept()
        end
      end)
    end,
  })
end

-- FIXME: This does not work sometimes it stops showing the blink.cmp menu
-- NOTE: Disable default <c-n> and <c-p> to make blink handle this menu only
-- local excluded_filetypes = {
--   "dap-repl",
--   "dapui_console",
--   "dapui_hover",
--   "dapui_scopes",
--   "dapui_stacks",
--   "dapui_watches",
--   "neorepl",
-- }
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "*",
--   callback = function()
--     local ft = vim.bo.filetype
--
--     for _, excluded in ipairs(excluded_filetypes) do
--       if ft == excluded then
--         return
--       end
--     end
--
--     vim.api.nvim_buf_set_keymap(0, "i", "<C-n>", "<Nop>", { noremap = true, silent = true })
--     vim.api.nvim_buf_set_keymap(0, "i", "<C-p>", "<Nop>", { noremap = true, silent = true })
--   end,
-- })

--- Opens next buffer or prev buffer with <c-n> and <c-p>
--- @module "blink.cmp"
--- @param cmp blink.cmp.API
local function simple_complete(cmp)
  cmp.show({
    providers = { "buffer", "path" },
  })
end

return {
  {
    "saghen/blink.cmp",
    optional = true,
    dependencies = {
      { "saghen/blink.compat", version = not vim.g.lazyvim_blink_main and "*" },
    },
    opts = {
      enabled = function()
        return not vim.g.cmp_disabled and not vim.tbl_contains(vim.g.cmp_disabled_filetypes, vim.bo.filetype)
      end,
      completion = {
        list = {
          selection = {
            preselect = true,
            auto_insert = function()
              return not vim.g.focus_mode
            end,
          },
        },
        accept = {
          auto_brackets = {
            enabled = true,
          },
        },
        menu = {
          -- border = "rounded",
          auto_show = function()
            return not vim.g.focus_mode
          end,
          draw = {
            columns = {
              { "kind_icon", "label", gap = 1 },
              { "label_description", "source_id" },
            },
          },
        },
        documentation = {
          window = {
            -- border = "rounded",
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
          -- border = "rounded",
        },
      },
      keymap = {
        preset = "enter",
        -- FIXME: this doesn't work sometimes...
        -- ["<C-p>"] = { "select_prev", simple_complete, "fallback" },
        -- ["<C-n>"] = { "select_next", simple_complete, "fallback" },
        ["<C-p>"] = { "select_prev", "fallback" },
        ["<C-n>"] = { "select_next", "fallback" },
        ["<C-j>"] = { "snippet_forward", trigger_snippet },
        ["<Tab>"] = {
          function(cmp)
            if LazyVim.has("copilot-lsp") and vim.b[vim.api.nvim_get_current_buf()].nes_state then
              cmp.hide()
              return require("copilot-lsp.nes").apply_pending_nes()
            end

            if Snacks.toggle.copilot:get() then
              cmp.hide()

              return
            end

            return cmp.select_and_accept()
          end,
          vim.g.ai_cmp and LazyVim.cmp.map({ "ai_accept", "fallback" }) or "fallback",
        },
        ["<S-Tab>"] = { "fallback" },
      },
      sources = {
        providers = {
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
    "numToStr/Comment.nvim",
    event = { "BufReadPost", "BufNewFile" },
    config = true,
  },
  {
    "folke/todo-comments.nvim",
    opts = {
      signs = false,
    },
  },
}
