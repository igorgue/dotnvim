return {
  "folke/noice.nvim",
  lazy = true,
  opts = {
    cmdline = {
      enabled = true,
    },
    presets = {
      bottom_search = false,
      command_palette = true,
      long_message_to_split = true, -- long messages will be sent to a split
      inc_rename = false, -- enables an input dialog for inc-rename.nvim
      lsp_doc_border = true,
    },
    lsp = {
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      },
    },
  },
}
