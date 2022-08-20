-- VSCode has a smaller configuration since it does all the file managing and lsp for you
if vim.g.vscode then
	require("vscode_plugins")
	require("vscode") -- vscode only settings

	-- vscode local settings
	if vim.api.nvim_get_runtime_file("lua/vscode_local.lua", false)[1] then
	    require "vscode_local"
	end

	-- exit early to prevent launching all the rest of the config that vscode don't care about
	do return end
end

require("plugins")
require("settings")

-- Load ginit.lua only for UI
vim.api.nvim_create_autocmd("UIEnter", { once = true, callback = function() require "ginit" end })

-- Load UI local settings
if vim.api.nvim_get_runtime_file("lua/ginit_local.lua", false)[1] then
	vim.api.nvim_create_autocmd("UIEnter", { once = true, callback = function() require "ginit_local" end })
end

-- Load final overrites or local settings
if vim.api.nvim_get_runtime_file("lua/init_local.lua", false)[1] then
	require "init_local"
end
