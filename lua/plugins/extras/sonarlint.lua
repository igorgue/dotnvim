return {
  desc = "Sonarlint",
  {
    "mason.nvim",
    opts = {
      ensure_installed = {
        "sonarlint-language-server",
      },
    },
  },
  {
    "schrieveslaach/sonarlint.nvim",
    url = "https://gitlab.com/schrieveslaach/sonarlint.nvim.git",
    ft = { "python", "java", "c", "cpp" },
    opts = {
      server = {
        cmd = {
          "sonarlint-language-server",
          "-stdio",
          "-analyzers",
          vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarpython.jar"),
          vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarcfamily.jar"),
          vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarjava.jar"),
        },
      },
      filetypes = {
        "python",
        "cpp",
        "java",
      },
    },
  },
}
