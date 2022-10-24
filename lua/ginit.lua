local ui_utils = require("ui_utils")

-- call `SetFont` from the ginit_local.lua file to use your favorite font
vim.api.nvim_create_user_command("SetFont", function(opts)
    ui_utils.SetFont(unpack(opts.fargs))
end, { nargs = "*" })
vim.api.nvim_create_user_command("ShowFont", ui_utils.ShowFont, { nargs = "*" })
vim.api.nvim_create_user_command("DefaultFont", "lua DefaultFont()", {})

local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap("n", "<C-0>", ":DefaultFont<CR>", opts)
vim.api.nvim_set_keymap("n", "<C-=>", ":lua IncreaseFontSize()<CR>", opts)
vim.api.nvim_set_keymap("n", "<C-+>", ":lua IncreaseFontSize()<CR>", opts)
vim.api.nvim_set_keymap("n", "<C-->", ":lua DecreaseFontSize()<CR>", opts)
vim.api.nvim_set_keymap("n", "<C-_>", ":lua DecreaseFontSize()<CR>", opts)

if vim.fn.exists(":GuiTabline") ~= 0 then
    vim.api.nvim_command("GuiTabline 0")
end

if vim.fn.exists(":GuiPopupmenu") ~= 0 then
    vim.api.nvim_command("GuiPopupmenu 0")
end

if vim.fn.exists(":GuiShowContextMenu") ~= 0 then
    vim.api.nvim_set_keymap("n", "<RightMouse>", ":call GuiShowContextMenu()<CR>", { noremap = true, silent = true })
    vim.api.nvim_set_keymap(
        "i",
        "<RightMouse>",
        "<Esc>:call GuiShowContextMenu()<CR>",
        { noremap = true, silent = true }
    )
    vim.api.nvim_set_keymap("x", "<RightMouse>", ":call GuiShowContextMenu()<CR>gv", { noremap = true, silent = true })
    vim.api.nvim_set_keymap(
        "s",
        "<RightMouse>",
        "<C-G>:call GuiShowContextMenu()<CR>gv",
        { noremap = true, silent = true }
    )
end

if vim.fn.exists(":GuiScrollBar") ~= 0 then
    vim.api.nvim_command("GuiScrollBar 0")
end
