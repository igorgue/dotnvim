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

      local items = cmp.get_items()
      local word = line:sub(start_col, end_col - 1)
      if #items > 0 and word == items[1].label then
        cmp.accept()
      end
    end,
  })
end

-- NOTE: Disable default <c-n> and <c-p> to make blink handle this menu only
local excluded_filetypes = { "dap-repl", "dapui_console", "dapui_hover" }
vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    local ft = vim.bo.filetype
    -- Apply the mapping only if the filetype is not excluded.
    local skip_mapping = false
    for _, excluded in ipairs(excluded_filetypes) do
      if ft == excluded then
        skip_mapping = true
        break
      end
    end
    if not skip_mapping then
      vim.api.nvim_buf_set_keymap(0, "i", "<C-n>", "<Nop>", { noremap = true, silent = true })
      vim.api.nvim_buf_set_keymap(0, "i", "<C-p>", "<Nop>", { noremap = true, silent = true })
    end
  end,
})

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
          border = "rounded",
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
        ["<C-p>"] = { "select_prev", simple_complete, "fallback_to_mappings" },
        ["<C-n>"] = { "select_next", simple_complete, "fallback_to_mappings" },
        ["<C-j>"] = { "snippet_forward", trigger_snippet },
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
    "saghen/blink.cmp",
    dependencies = {
      "moyiz/blink-emoji.nvim",
    },
    opts = {
      sources = {
        default = { "emoji" },
        providers = {
          emoji = {
            module = "blink-emoji",
            name = "Emoji",
            score_offset = -15,
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
