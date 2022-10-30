local ui_utils = require("ui_utils")
local opts = { noremap = true, silent = true }

-- call `SetFont` from the ginit_local.lua file to use your favorite font
vim.api.nvim_create_user_command("SetFont", function(args)
    ui_utils.set_font(unpack(args.fargs))
end, { nargs = "*" })
vim.api.nvim_create_user_command("ShowFont", ui_utils.show_font, {})
vim.api.nvim_create_user_command("DefaultFont", ui_utils.default_font, {})
vim.api.nvim_create_user_command("IncreaseFontSize", ui_utils.increase_font_size, {})
vim.api.nvim_create_user_command("DecreaseFontSize", ui_utils.decrease_font_size, {})

vim.api.nvim_set_keymap("n", "<C-0>", "<Cmd>DefaultFont<CR>", opts)
vim.api.nvim_set_keymap("n", "<C-=>", "<Cmd>IncreaseFontSize<CR>", opts)
vim.api.nvim_set_keymap("n", "<C-+>", "<Cmd>IncreaseFontSize<CR>", opts)
vim.api.nvim_set_keymap("n", "<C-->", "<Cmd>DecreaseFontSize<CR>", opts)
vim.api.nvim_set_keymap("n", "<C-_>", "<Cmd>DecreaseFontSize<CR>", opts)

if vim.fn.exists(":GuiTabline") ~= 0 then
    vim.api.nvim_command("GuiTabline 0")
end

if vim.fn.exists(":GuiPopupmenu") ~= 0 then
    vim.api.nvim_command("GuiPopupmenu 0")
end

if vim.fn.exists(":GuiShowContextMenu") ~= 0 then
    vim.api.nvim_set_keymap("n", "<RightMouse>", ":call GuiShowContextMenu()<CR>", opts)
    vim.api.nvim_set_keymap("i", "<RightMouse>", "<Esc>:call GuiShowContextMenu()<CR>", opts)
    vim.api.nvim_set_keymap("x", "<RightMouse>", ":call GuiShowContextMenu()<CR>gv", opts)
    vim.api.nvim_set_keymap("s", "<RightMouse>", "<C-G><Cmd>GuiShowContextMenu()<CR>gv", opts)
end

if vim.fn.exists(":GuiScrollBar") ~= 0 then
    vim.api.nvim_command("GuiScrollBar 0")
end
