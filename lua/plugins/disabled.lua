-- NOTE: Treesitter is known (at least to me) to be very slow,
-- so it can be toggled with an env variable
local enable_ts = vim.env.NVIM_TS_ENABLE ~= nil

-- NOTE: Noice is awesome but some plugins when they install
-- they use something to capture input from the bottom status
-- that doesn't work sometimes, so we can disable it with
-- an env variable
local enable_noice = vim.env.NVIM_NOICE_DISABLE == nil

-- NOTE: The Leetcode plugin requires Treesitter
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
  { "echasnovski/mini.comment", enabled = false },
  { "echasnovski/mini.indentscope", enabled = false },
  { "echasnovski/mini.pairs", enabled = false },
  { "echasnovski/mini.icons", enabled = false },
  { "nvim-tree/nvim-web-devicons", enabled = vim.env.SSH_TTY == nil },
  { "ggandor/flit.nvim", enabled = false },
  { "ggandor/leap.nvim", enabled = false },
  { "lukas-reineke/indent-blankline.nvim", enabled = false },
  { "RRethy/vim-illuminate", enabled = false },
  { "stevearc/conform.nvim", enabled = not vim.o.diff },
  { "folke/noice.nvim", enabled = enable_noice },
  { "folke/flash.nvim", enabled = false },
  -- treesitter and deps:
  { "nvim-treesitter/nvim-treesitter", enabled = enable_ts },
  { "luckasRanarison/tailwind-tools.nvim", enabled = enable_ts },
  { "nvim-treesitter/nvim-treesitter-context", enabled = false },
  { "nvim-treesitter/nvim-treesitter-textobjects", enabled = false },
  { "JoosepAlviste/nvim-ts-context-commentstring", enabled = false },
  { "windwp/nvim-ts-autotag", enabled = false },
}
