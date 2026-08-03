local autocmd   = vim.api.nvim_create_autocmd;
local usercmd   = vim.api.nvim_create_user_command;
local map       = vim.keymap.set;

local MiniFiles = require("mini.files");

MiniFiles.setup({
    content = {
        prefix = function(fs_entry)
            if fs_entry.fs_type == "directory" then
                fs_entry.name = fs_entry.name .. "/";
                return "";
            else
                return "";
            end
        end,
    },
    mappings = {
        go_in       = "<CR>",
        go_in_plus  = "H",
        go_out      = "_",
        go_out_plus = "L",
    },
});

autocmd('User', {
    pattern = 'MiniFilesWindowOpen',
    callback = function(args)
        local win_id = args.data.win_id

        -- Customize window-local settings
        vim.wo[win_id].winblend = 20;
        local config = vim.api.nvim_win_get_config(win_id);
        config.border = 'single';
        config.title_pos = 'right';

        vim.api.nvim_win_set_config(win_id, config);
    end,
});

autocmd("User", {
    pattern = "MiniFilesWindowUpdate",
    callback = function(args)
        local state = MiniFiles.get_explorer_state();
        if not state then
            return;
        end

        local win = args.data.win_id;
        local config = vim.api.nvim_win_get_config(win);
        -- local config = vim.api.nvim_win_get_config(args.data.win_id)

        -- Ensure fixed height
        config.height = 40;

        -- Ensure no title padding
        local n = #config.title
        config.title[1][1] = config.title[1][1]:gsub('^ ', '')
        config.title[n][1] = config.title[n][1]:gsub(' $', '')

        -- Find this window's position in the branch
        local index;

        for i, item in ipairs(state.windows) do
            if item.win_id == win then
                index = i;
                break;
            end
        end

        if not index then
            return;
        end

        -- Position columns from RIGHT -> LEFT
        local gap = 1;
        local right = vim.o.columns - 2;

        for i = 1, index do
            local w = state.windows[i].win_id;
            local c = vim.api.nvim_win_get_config(w);

            right = right - c.width;

            if w == win then
                config.col = right;
                config.row = 1;
                vim.api.nvim_win_set_config(win, config);
                break
            end

            right = right - gap;
        end
    end,
});

usercmd("CD",
    function()
        local path = vim.api.nvim_buf_get_name(0);
        local dir = vim.fn.fnamemodify(path, ":p:h");
        vim.fn.chdir(dir);
        -- MiniFiles.open(dir);
    end,
    { desc = '' }
);

map("n", "<leader>r", function()
    local entry = MiniFiles.get_fs_entry()
    if entry then
        MiniFiles.set_path(entry.path)
    end
end, { buffer = true });

map("n", "-", "<cmd>lua MiniFiles.open()<CR>");
map("n", "<C-[><C-s>", function()
    MiniFiles.open(vim.api.nvim_buf_get_name(0), false);
    MiniFiles.reveal_cwd();
end);
