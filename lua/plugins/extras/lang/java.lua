return {
  {
    "neovim/nvim-lspconfig",
    ft = { "java" },
    opts = {
      setup = {
        -- stylua: ignore
        jdtls = function() return true end,
      },
    },
  },
  {
    "mfussenegger/nvim-jdtls",
    ft = { "java" },
    config = function(_, opts)
      require("lazyvim.util").on_attach(function(_, buffer)
        local wk = require("which-key")

        wk.register({
          i = { require("jdtls").organize_imports, "Organize Imports" },
          t = { require("jdtls").test_class, "Test Class" },
          n = { require("jdtls").test_nearest_method, "Test Nearest Method" },
          -- stylua: ignore
          e = { function() require("jdtls").extract_variable(true) end, "Extract Variable", },
          -- stylua: ignore
          M = { function() require("jdtls").extract_method(true) end, "Extract Method", },
        }, {
          prefix = "<leader>c",
          buffer = buffer,
        })

        wk.register({
          e = {
            function()
              require("jdtls").extract_variable(true)
            end,
            "Extract Variable",
          },
          M = {
            function()
              require("jdtls").extract_method(true)
            end,
            "Extract Method",
          },
        }, {
          prefix = "<leader>c",
          buffer = buffer,
          mode = "v",
        })
      end)

      opts.root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew", "build.gradle" })

      require("jdtls").start_or_attach(opts)
      require("jdtls").setup_dap({ hotcodereplace = "auto" })
    end,
    opts = {
      cmd = { "jdtls" },
      settings = {
        java = {},
      },
    },
  },
}
