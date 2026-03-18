return {
  {
    "igorgue/anya",
    dir = "~/Code/anya",
    build = ":UpdateRemotePlugins",
    lazy = true,
    config = function(_, opts)
      require("anya").setup(opts)
    end,
    opts = {
      -- start_in_insert = true,
    },
    dependencies = {
      "j-hui/fidget.nvim",
      {
        "MeanderingProgrammer/render-markdown.nvim",
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
        "<C-;>",
        "<cmd>Anya pane<cr>",
        desc = "Toggle Anya pane",
        mode = { "n", "i" },
      },
      {
        "<C-;>",
        ":Anya pane<cr>",
        desc = "Add code to Anya prompt in the pane",
        mode = "v",
        silent = true,
      },
      {
        "<leader>gc",
        function()
          local buf_content = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n")
          local prompt = "You are an expert at following the Conventional Commit specification. "
            .. "Here is the git commit message draft buffer content:\n\n"
            .. buf_content
            .. "\n\nGenerate a commit message for me, write your commit top of the file at the header level. "
            .. "Do not read any other file, use the content it was provided in the prompt for you here. "
            .. "Make sure to preserve the whole content of the current buffer, so just prepend your content."

          vim.fn.AnyaDo(prompt)
        end,
        desc = "Generate a commit message with Anya",
        mode = "n",
        silent = true,
      },
    },
  },
}
