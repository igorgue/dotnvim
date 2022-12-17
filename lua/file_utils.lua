local M = {}

local conf_dir = vim.fn.stdpath('config')

function M.cd_conf()
    vim.cmd("cd " .. conf_dir)
end

function M.edit_dbs_config()
    vim.cmd("e " .. conf_dir .. "/lua/dbs_local.lua")
end

function M.edit_init()
    vim.cmd("e ".. conf_dir .. "/init.lua")
end

function M.edit_settings()
    vim.cmd("e " .. conf_dir .. "/lua/settings.lua")
end

function M.edit_plugins()
    vim.cmd("e " .. conf_dir .. "/lua/plugins.lua")
end

function M.refresh_dir()
    vim.cmd([[
        cd
        cd -
    ]])
end

return M
