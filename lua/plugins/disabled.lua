-- NOTE: Treesitter is known (at least to me) to be slow, so we disable it,
-- and can be toggled back here.
local enable_ts = vim.env.NVIM_TS_ENABLE ~= nil
local enable_noice = vim.env.NVIM_NOICE_DISABLE == nil

local has_leetcode = false
for _, arg in ipairs(vim.v.argv) do
  if arg == "leetcode.nvim" then
    has_leetcode = true
    break
  end
end

enable_ts = has_leetcode or (enable_ts and not vim.o.diff)

return {
  { "akinsho/bufferline.nvim", enabled = false },
  { "echasnovski/mini.ai", enabled = false },
  { "echasnovski/mini.comment", enabled = false },
  { "echasnovski/mini.indentscope", enabled = false },
  { "echasnovski/mini.pairs", enabled = false },
  { "folke/flash.nvim", enabled = false },
  { "ggandor/flit.nvim", enabled = false },
  { "ggandor/leap.nvim", enabled = false },
  { "lukas-reineke/indent-blankline.nvim", enabled = false },
  { "stevearc/conform.nvim", enabled = not vim.o.diff },
  -- treesitter and deps:
  { "nvim-treesitter/nvim-treesitter", enabled = enable_ts },
  { "nvim-treesitter/nvim-treesitter-context", enabled = false },
  { "nvim-treesitter/nvim-treesitter-textobjects", enabled = false },
  { "JoosepAlviste/nvim-ts-context-commentstring", enabled = false },
  { "windwp/nvim-ts-autotag", enabled = false },
  { "folke/noice.nvim", enabled = enable_noice },
}
