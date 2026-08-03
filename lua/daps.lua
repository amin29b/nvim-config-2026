local function setup()
    local dap = require("dap");
    dap.adapters.coreclr = {
        type = 'executable',
        command = path_config .. "/mason_lsps/packages/netcoredbg/netcoredbg/netcoredbg.exe",
        args = {'--interpreter=vscode'}
    };

    dap.configurations.cs = {
        type = "coreclr",
        name = "launch - netcoredbg",
        request = "launch",
        program = function()
            return vim.fn.input(
                'Executable: ',
                vim.fn.getcwd() .. '/bin/Debug/',
                'file');
            end,
        };


end

return {
    setup = function()
        pcall(setup);
    end
}

