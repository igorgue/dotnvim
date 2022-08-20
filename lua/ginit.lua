function set_font(name, size)
	if vim.fn.exists(":GuiFont") ~= 0
	then
		vim.api.nvim_command("GuiFont! " .. name .. ":h" .. size)
	end
end

set_font("Iosevka", 16)
