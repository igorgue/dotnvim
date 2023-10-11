return {
  {
    "nvim-treesitter/nvim-treesitter",
    ft = { "http" },
    opts = function(_, opts)
      vim.treesitter.language.register("http", "http")

      opts.highlight.additional_vim_regex_highlighting = true

      return opts
    end,
  },
  {
    "bayne/vim-dot-http",
    ft = { "http" },
    init = function()
      vim.g.dot_http_env = "dev"

      vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
        pattern = "*.http",
        callback = function()
          vim.bo.filetype = "http"
        end,
      })

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "http",
        callback = function()
          vim.opt.commentstring = "# %s"
        end,
      })
    end,
    keys = {
      {
        "<leader>ch",
        function()
          vim.cmd("DotHttp")
          -- vim.cmd("wincmd p")
          -- vim.bo.ft = "http"
        end,
        desc = "Run DotHttp Request",
        ft = "http",
      },
      {
        "<leader>cH",
        function()
          local env_name = vim.fn.input("Environment Name: ")

          vim.g.dot_http_env = env_name
        end,
        desc = "Change DotHttp Environment",
        ft = "http",
      },
    },
    cmd = { "DotHttp" },
  },
}
