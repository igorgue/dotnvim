local M = {}

function M.edit_dbs_config()
    vim.cmd("e ~/.config/nvim/lua/dbs_local.lua")
end

function M.cd_conf()
    vim.cmd("cd ~/.config/nvim")
end

function M.edit_init()
    M.cd_conf()
    vim.cmd("e init.lua")
end

function M.edit_settings()
    M.cd_conf()
    vim.cmd("e lua/settings.lua")
end

function M.edit_plugins()
    M.cd_conf()
    vim.cmd("e lua/plugins.lua")
end

return M
