local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local make_entry = require("telescope.make_entry")
local conf = require("telescope.config").values

local M = {}

M.filter_grep = function(opts)
  opts = opts or {}
  opts.cwd = opts.cwd or vim.uv.cwd()

  local finder = finders.new_async_job({
    command_generator = function(prompt)
      if not prompt or prompt == "" then
        return nil
      end

      local pieces = vim.split(prompt, "|")
      local args = { "rg" }

      if pieces[1] then
        table.insert(args, "-e")
        pieces[1] = pieces[1]:gsub("^%s*(.-)%s*$", "%1")
        table.insert(args, pieces[1])
      end

      if pieces[2] then
        table.insert(args, "-g")
        pieces[2] = pieces[2]:gsub("^%s*(.-)%s*$", "%1")
        table.insert(args, pieces[2])
      end

      return vim
        .iter({
          args,
          { "--color=never", "--no-heading", "--with-filename", "--column", "--smart-case" },
        })
        :flatten()
        :totable()
    end,
    entry_maker = make_entry.gen_from_vimgrep(opts),
    cwd = opts.cwd,
  })

  pickers
    .new(opts, {
      prompt_title = "Filter Grep",
      finder = finder,
      previewer = conf.grep_previewer(opts),
      sorter = require("telescope.sorters").get_generic_fuzzy_sorter(),
    })
    :find()
end

return M
