-- FIXME `set_font` can only be called once in the init process
-- if not it would give errors and you can only use it once nvim
-- is started
function SetFont(name, size)
	if vim.fn.exists(":GuiFont") ~= 0 then
		vim.api.nvim_command("GuiFont! " .. name .. ":h" .. size)
	end

    -- TODO Add support for other Neovim GUIs here
end

-- call `set_font` from the ginit_local.lua file to use your favorite font

if vim.fn.exists(":GuiTabline") ~= 0 then
    vim.api.nvim_command("GuiTabline 0")
end

if vim.fn.exists(":GuiPopupmenu") ~= 0 then
    vim.api.nvim_command("GuiPopupmenu 0")

    vim.api.nvim_set_keymap('n', '<RightMouse>', ":call GuiShowContextMenu()<CR>", { noremap = true, silent = true })
    vim.api.nvim_set_keymap('i', '<RightMouse>', "<Esc>:call GuiShowContextMenu()<CR>", { noremap = true, silent = true })
    vim.api.nvim_set_keymap('x', '<RightMouse>', ":call GuiShowContextMenu()<CR>gv", { noremap = true, silent = true })
    vim.api.nvim_set_keymap('s', '<RightMouse>', "<C-G>:call GuiShowContextMenu()<CR>gv", { noremap = true, silent = true })
end

if vim.fn.exists(":GuiScrollBar") ~= 0 then
    vim.api.nvim_command("GuiScrollBar 0")
end
