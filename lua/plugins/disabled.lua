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
  { "echasnovski/mini.ai", enabled = false },
  { "nvim-tree/nvim-web-devicons", enabled = vim.env.SSH_TTY == nil },
  { "ggandor/flit.nvim", enabled = false },
  { "ggandor/leap.nvim", enabled = false },
  { "lukas-reineke/indent-blankline.nvim", enabled = false },
  { "RRethy/vim-illuminate", enabled = false },
  { "L3MON4D3/LuaSnip", enabled = vim.g.lazyvim_cmp == "nvim-cmp" },
  { "stevearc/conform.nvim", enabled = not vim.o.diff },
  { "folke/noice.nvim", enabled = enable_noice },
  { "folke/flash.nvim", enabled = false },
  -- treesitter and deps:
  { "nvim-treesitter/nvim-treesitter", enabled = enable_ts },
  { "luckasRanarison/tailwind-tools.nvim", enabled = enable_ts },
  { "JoosepAlviste/nvim-ts-context-commentstring", enabled = enable_ts },
  { "windwp/nvim-ts-autotag", enabled = enable_ts },
  { "nvim-treesitter/nvim-treesitter-context", enabled = enable_ts },
  { "nvim-treesitter/nvim-treesitter-textobjects", enabled = enable_ts },
  -- kitty scrollback:
  { "github/copilot.vim", enabled = vim.env.KITTY_SCROLLBACK_NVIM ~= "true" },
  {
    "neovim/nvim-lspconfig",
    enabled = vim.env.KITTY_SCROLLBACK_NVIM ~= "true",
  },
  {
    "nvim-telescope/telescope.nvim",
    enabled = vim.env.KITTY_SCROLLBACK_NVIM ~= "true",
  },
  { "saghen/blink.cmp", enabled = vim.env.KITTY_SCROLLBACK_NVIM ~= "true" },
  {
    "GCBallesteros/jupytext.nvim",
    enabled = vim.env.KITTY_SCROLLBACK_NVIM ~= "true",
  },
  {
    "nvim-lualine/lualine.nvim",
    enabled = vim.env.KITTY_SCROLLBACK_NVIM ~= "true",
  },
  { "chentoast/marks.nvim", enabled = vim.env.KITTY_SCROLLBACK_NVIM ~= "true" },
  { "andymass/vim-matchup", enabled = vim.env.KITTY_SCROLLBACK_NVIM ~= "true" },
  { "folke/noice.nvim", enabled = vim.env.KITTY_SCROLLBACK_NVIM ~= "true" },
  { "SmiteshP/nvim-navic", enabled = vim.env.KITTY_SCROLLBACK_NVIM ~= "true" },
  { "Rawnly/gist.nvim", enabled = vim.env.KITTY_SCROLLBACK_NVIM ~= "true" },
  {
    "HiPhish/rainbow-delimiters.nvim",
    enabled = vim.env.KITTY_SCROLLBACK_NVIM ~= "true",
  },
  { "romgrk/todoist.nvim", enabled = vim.env.KITTY_SCROLLBACK_NVIM ~= "true" },
  { "tpope/vim-dadbod", enabled = vim.env.KITTY_SCROLLBACK_NVIM ~= "true" },
  {
    "folke/ts-comments.nvim",
    enabled = vim.env.KITTY_SCROLLBACK_NVIM ~= "true",
  },
  { "jez/vim-ispc", enabled = vim.env.KITTY_SCROLLBACK_NVIM ~= "true" },
  {
    "s1n7ax/nvim-window-picker",
    enabled = vim.env.KITTY_SCROLLBACK_NVIM ~= "true",
  },
}
