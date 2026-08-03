local M = {}

local uv = vim.uv
local fs = vim.fs
local name_lsp = "roslyn"
local offset_encoding = 'utf-8'
local filetypes = { 'cs' }

local function setup()
    vim.lsp.config("roslyn", {
        capabilities = require("blink.cmp").get_lsp_capabilities(),
    });
    vim.lsp.enable('roslyn');
    vim.g.dotnet_errors_only = true;
    vim.g.dotnet_show_project_file = false;
end

local function BuildCSharpProject()
    local now = os.date("%Y-%m-%d %H:%M:%S")
    local root_markers = { '*.root', '*.sln', '.git' }
    local project_root = require("utils").FindProjectRoot(root_markers)
    project_root = vim.fn.shellescape(project_root)
    require("utils").save_csharp_buffers()
    vim.cmd [[
                                        set cmdheight=4
                                        highlight BuildS guifg=#00FF00
                                        highlight BuildF guifg=#FF0000
                                        ]]

    local messages = {}
    local m1 = "==========  " .. now .. "   =========="
    local m2 = "==========  Building ...          =========="
    table.insert(messages, m1);
    table.insert(messages, m2);
    vim.api.nvim_echo({ { table.concat(messages, "\n"), "" } }, false, {})

    vim.fn.jobstart(
        "msbuild  /m  " ..
        project_root .. "   /p:WarningLevel=0" .. "   /clp:ErrorsOnly" .. "   /nologo " .. "/verbosity:quiet"
        , {
            stdout_buffered = true,
            stderr_buffered = true,
            on_stdout = function(_, data)
                vim.cmd('set cmdheight=4')
                if #data == 1 and data[1] == "" then
                    local now = os.date("%Y-%m-%d %H:%M:%S")
                    local message1 = "==========  " .. now .. "   =========="
                    local message2 = "==========  🗹  Build succeeded.   =========="
                    table.insert(messages, message1);
                    table.insert(messages, message2);
                    -- table.insert(messages, vim.inspect(data));
                    vim.api.nvim_echo({ { table.concat(messages, "\n"), "BuildS" } }, false, {})
                    vim.fn.setqflist({}, "r")
                    vim.cmd('cwindow')
                else
                    local now = os.date("%Y-%m-%d %H:%M:%S")
                    local message1 = "==========  " .. now .. "   =========="
                    local message2 = "==========  ⮽ Build failed        ==========" ..
                        "   Error Count : " .. (#data - 1)
                    table.insert(messages, message1);
                    table.insert(messages, message2);
                    -- table.insert(messages, vim.inspect(data));
                    vim.api.nvim_echo({ { table.concat(messages, "\n"), "BuildF" } }, false, {})


                    local qf_lines = {}
                    for _, line in ipairs(data) do
                        if line ~= "" then
                            line = line:gsub("%s*%[.-%]%s*$", "")
                            table.insert(qf_lines, line)
                        end
                    end

                    local efm = '%f(%l\\,%c):\\ %t%*[^\\ ]%m'
                    vim.fn.setqflist({}, "r", {
                        lines = qf_lines,
                        efm = efm
                    })


                    vim.api.nvim_create_augroup("GroupChangeCmdHeight", { clear = true })
                    vim.cmd('copen')
                    vim.cmd('setlocal wrap')
                    vim.cmd('wincmd p')
                end

                local group = vim.api.nvim_create_augroup("GroupChangeCmdHeight", { clear = true })
                -- Create the autocmd in this group
                vim.api.nvim_create_autocmd("CursorMoved", {
                    group = group,
                    pattern = "*",
                    callback = function()
                        vim.cmd('set cmdheight=2')
                        vim.cmd('redraw!')
                        vim.api.nvim_create_augroup("GroupChangeCmdHeight", { clear = true })
                    end,
                })
            end,
            on_stderr = function(_, data)
            end,
            on_exit = function(_, code)
            end
        })
end

local function FindProjectSlnFile(filepath)
    local root_markers = { '*.sln' }
    -- Start from the directory of the current file or current working directory
    local current_dir = vim.fn.expand(filepath)
    -- print(current_dir)

    -- Convert to absolute path and normalize
    current_dir = vim.fn.fnamemodify(current_dir, ':p')

    -- Traverse upwards until we find a marker
    local root = ''
    local dir = current_dir

    while (dir ~= '/') do
        -- Check for any marker in current directory
        for _, marker in ipairs(root_markers) do
            local marker_files = vim.fn.glob(dir .. '\\' .. marker, true, true)
            if vim.fn.len(marker_files) > 0 then
                root = marker_files[1]
                break
            end
        end

        if (root ~= '') then
            break
        end

        -- Move to parent directory
        local parent = vim.fn.fnamemodify(dir, ':h')
        if (parent == dir) then -- We've reached the filesystem root
            break
        end

        dir = parent
    end

    -- print(root)
    return root
end

local function get_configs_from_sln(sln)
    local configs = {}
    for line in io.lines(sln) do
        -- print(line)
        local cfg = line:match("^%s*([^|]+)|Any CPU%s*=")
        if cfg then
            -- print(cfg)
            configs[cfg] = true
        end
    end
    return vim.tbl_keys(configs)
end

local function select_build_config(callback, filepath)
    local slnfile = FindProjectSlnFile(filepath)
    -- print(slnfile)
    local configs = get_configs_from_sln(slnfile)
    table.sort(configs)
    -- local configs =
    -- {
    --     "Debug"
    --     , "Release"
    -- } -- put your custom ones here

    vim.ui.select(configs, {
        prompt = "Select build configuration:",
    }, function(choice)
        if not choice then
            return
        end
        callback(choice)
    end)
end

local function get_env(filepath)
    local configuration = ""
    local platform = "AnyCPU"
    select_build_config(function(config)
        configuration = config
    end, filepath)
    -- print(configuration)

    return {
        Configuration = configuration,
        Platform = platform,
    }
end

vim.api.nvim_create_autocmd("FileType", {
    pattern = "cs",
    once = true,
    callback = function(args)
        local bufnr = args.buf;
        local filepath = vim.api.nvim_buf_get_name(bufnr);
        -- print("C# file:", filepath)
        vim.lsp.config[name_lsp].cmd_env = get_env(filepath);
    end,
});

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        vim.api.nvim_create_user_command("Build", BuildCSharpProject, {})
        vim.keymap.set("n", "<leader>bb", "<CMD>Build<CR>", {})
    end,
})


M.setup = function()
    pcall(setup);
end
return M;
