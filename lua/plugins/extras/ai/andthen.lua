return {
  desc = "DeepSeek completion",
  {
    "igorgue/andthen.nvim",
    dir = "~/Code/andthen.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      suggest_hl_group = "Special",
      model = "deepseek-coder",
    },
    keys = {
      {
        "<m-d>",
        function()
          Andthen.completion.complete()
        end,
        desc = "Complete 1 lines",
        mode = "i",
      },
      {
        "<m-D>",
        function()
          -- TODO: doesnt' work well it inserts the text wrongly
          Andthen.completion.complete(10)
        end,
        desc = "Complete 10 lines",
        mode = "i",
      },
      {
        "<m-y>",
        function()
          Andthen.completion.accept_completion()
        end,
        desc = "Accept suggestion",
        mode = "i",
      },
    },
  },
  {
    "folke/lazydev.nvim",
    ft = "lua",
    cmd = "LazyDev",
    optional = true,
    opts = function(_, opts)
      local item = { path = "andthen.nvim", words = { "Andthen" } }

      if type(opts.library) == "table" then
        vim.list_extend(opts.library, { item })
      else
        opts.library = { item }
      end
    end,
  },
}
