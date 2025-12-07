return {
  {
    "igorgue/anya",
    dir = "~/Code/anya",
    build = ":UpdateRemotePlugins",
    -- TODO: to make it lazy, we need to figure out the loading issue we have sometimes
    -- where we are oblicated to run :UpdateRemotePlugins again after startup to make it update
    lazy = false,
    cmd = { "Anya" },
    dependencies = {
      {
        "MeanderingProgrammer/render-markdown.nvim",
        lazy = false,
        opts = {
          file_types = vim.g.render_markdown_fts or { "anya-chat", "markdown" },
          preset = "lazy",
          code = {
            disable_background = true,
          },
          restart_highlighter = false,
          completions = {
            blink = { enabled = false },
            lsp = { enabled = false },
          },
          heading = {
            icons = false,
          },
        },
        ft = vim.g.render_markdown_fts or { "anya-chat", "markdown" },
      },
      {
        "saghen/blink.cmp",
        opts = {
          completion = {
            accept = {
              auto_brackets = {
                kind_resolution = {
                  blocked_filetypes = { "anya-prompt", "anya-content" },
                },
                semantic_token_resolution = {
                  blocked_filetypes = { "anya-prompt", "anya-content" },
                },
              },
            },
          },
          sources = {
            default = { "anya_files", "anya_commands" },
            providers = {
              anya_files = {
                name = "Anya Files",
                module = "anya.blink.files",
                enabled = function()
                  return vim.bo.filetype == "anya-prompt"
                end,
              },
              anya_commands = {
                name = "Anya Commands",
                module = "anya.blink.commands",
                enabled = function()
                  return vim.bo.filetype == "anya-prompt"
                end,
              },
            },
          },
        },
      },
    },
    keys = {
      {
        "<C-c>",
        "<cmd>AnyaCancel<cr>",
        ft = { "anya-prompt", "anya-content" },
        desc = "Cancel Anya request",
      },
      {
        "<C-;>",
        "<cmd>Anya pane<cr>",
        desc = "Toggle Anya pane (right)",
      },
    },
  },
}
