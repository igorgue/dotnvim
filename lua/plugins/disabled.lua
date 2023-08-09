return {
  { "akinsho/bufferline.nvim", enabled = false },
  { "echasnovski/mini.ai", enabled = false },
  { "echasnovski/mini.comment", enabled = false },
  { "echasnovski/mini.indentscope", enabled = false },
  { "echasnovski/mini.pairs", enabled = false },
  { "folke/flash.nvim", enabled = false },
  { "ggandor/flit.nvim", enabled = false },
  { "ggandor/leap.nvim", enabled = false },
  {
    "nvim-treesitter/nvim-treesitter",
    enabled = true,
    opts = { ensure_installed = {}, highlights = { disabled = { "zig" } } },
  },
  { "nvim-treesitter/nvim-treesitter-textobjects", enabled = false },
}
