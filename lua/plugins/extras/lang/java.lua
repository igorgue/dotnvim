return {
  {
    "neovim/nvim-lspconfig",
    dependencies = { "mfussenegger/nvim-jdtls" },
    ft = { "java" },
    opts = {
      setup = {
        -- stylua: ignore
        jdtls = function()
          vim.api.nvim_create_autocmd("FileType", {
            pattern = "java",
            callback = function()
              local jdtls = require("jdtls")
              local wk = require("which-key")

              -- stylua: ignore start
              local extract_variable = function() jdtls.extract_variable(true) end
              local extract_method = function() jdtls.extract_method(true) end
              -- stylua: ignore end

              wk.register({
                i = { jdtls.organize_importsorganize_imports, "Java organize imports" },
                t = { jdtls.test_class, "Java test class" },
                n = { jdtls.test_nearest_method, "Java test nearest method" },
                e = { extract_variable, "Java extract variable" },
                M = { extract_method, "Java extract method" },
              }, {
                prefix = "<leader>c",
                buffer = vim.api.nvim_get_current_buf(),
              })

              wk.register({
                e = { extract_variable, "Java extract variable" },
                M = { extract_method, "Java extract method" },
              }, {
                mode = "v",
                prefix = "<leader>c",
                buffer = vim.api.nvim_get_current_buf(),
              })

              jdtls.start_or_attach({
                cmd = { "jdtls" },
                settings = {
                  java = {},
                },
                root_dir = jdtls.setup.find_root({ ".git", "mvnw", "gradlew", "build.gradle" })
              })

              jdtls.setup_dap({ hotcodereplace = "auto" })
            end
          })

          return true
        end,
      },
    },
  },
}
