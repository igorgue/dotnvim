return {
  {
    "neovim/nvim-lspconfig",
    dependencies = { "mfussenegger/nvim-jdtls" },
    opts = {
      setup = {
        jdtls = function(_, _)
          vim.api.nvim_create_autocmd("FileType", {
            pattern = "java",
            callback = function()
              require("lazyvim.util").on_attach(function(_, buffer)
                local wk = require("which-key")

                wk.register({
                  i = { require("jdtls").organize_imports, "Organize Imports" },
                  t = { require("jdtls").test_class, "Test Class" },
                  n = { require("jdtls").test_nearest_method, "Test Nearest Method" },
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
              local config = {
                cmd = {
                  "jdtls",
                },
                root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew", "build.gradle" }),
                settings = {
                  java = {},
                },
              }
              require("jdtls").start_or_attach(config)
            end,
          })

          return true
        end,
      },
    },
  },
}
