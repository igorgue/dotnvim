return {
  "nvim-treesitter/nvim-treesitter",
  dependencies = {
    "nvim-treesitter/playground",
    "David-Kunz/markid",
    "p00f/nvim-ts-rainbow",
    "nvim-treesitter/nvim-treesitter-refactor",
    "nvim-treesitter/nvim-treesitter-context",
    "theHamsta/nvim-treesitter-pairs",
    "theHamsta/nvim-dap-virtual-text",
    "windwp/nvim-ts-autotag",
    "andymass/vim-matchup",
  },
  config = function(_, opts)
    require("nvim-treesitter.configs").setup(opts)

    require("treesitter-context").setup()
    require("nvim-dap-virtual-text").setup({})

    -- enable html parser in htmldjango file
    local import_parsers, parsers = pcall(require, "nvim-treesitter.parsers")
    if import_parsers then
      local parsername = parsers.filetype_to_parsername
      parsername.htmldjango = "html"
    end

    local import_tag, autotag = pcall(require, "nvim-ts-autotag")
    if not import_tag then
      return
    end
    autotag.setup({
      autotag = {
        enable = true,
      },
      filetypes = {
        "html",
        "htmldjango",
      },
    })
  end,
  opts = {
    auto_install = true,
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "gnn",
        node_incremental = "grn",
        scope_incremental = "grc",
        node_decremental = "grm",
      },
    },
    indent = {
      enable = true,
    },
    markid = {
      enable = true,
      -- queries = {
      --     default = [[
      --         (
      --          (identifier) @markid
      --          (#not-has-parent? @markid function_definition class_definition dotted_name)
      --         )
      --     ]],
      -- },
    },
    rainbow = {
      enable = true,
      extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
      max_file_lines = nil, -- Do not enable for files with more than n lines, int
    },
    refactor = {
      enable = true,
      clear_on_cursor_move = false,
      highlight_definitions = { enable = true },
    },
    pairs = {
      enable = true,
    },
    autotag = {
      enable = true,
    },
    matchup = {
      enable = true,
    },
  },
  keys = {
    { "<leader>ux", "<Cmd>TSHighlightCapturesUnderCursor<CR>", desc = "Show TS and VIM highlight groups" },
  },
}
