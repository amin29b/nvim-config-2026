require("vim._core.ui2").enable({});

-- :lua vim.pack.update()
-- :lua vim.pack.del()
vim.pack.add({
    { src = "https://github.com/nvim-lua/plenary.nvim", },
    { src = "https://github.com/mofiqul/vscode.nvim", },
    { src = "https://github.com/miversen33/sunglasses.nvim", },
    { src = "https://github.com/junegunn/fzf", },
    { src = "https://github.com/junegunn/fzf.vim", },

    { src = "https://github.com/kdheepak/lazygit.nvim", },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter", },

    { src = "https://github.com/neovim/nvim-lspconfig", },
    { src = "https://github.com/mason-org/mason.nvim", },
    { src = "https://github.com/seblyng/roslyn.nvim", },

    { src = "https://github.com/nvim-mini/mini.nvim",             version = "stable" },
    { src = "https://github.com/sphamba/smear-cursor.nvim", },

});

require("options");

pcall(function()
    if vim.loop.os_uname().sysname == "Windows_NT" then
        vim.o.shell = "powershell.exe"
        vim.opt.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command"
        vim.opt.shellquote = ""
        vim.opt.shellxquote = ""
        vim.cmd([[
            cnoreabbrev powershell powershell -nologo
            cnoreabbrev sh powershell -nologo -NoProfile -Command -
            ]])
    end
end);

require("terminal").setup();




vim.diagnostic.config({
    severity_sort = true,
    update_in_insert = false,
    virtual_lines = false,
    virtual_text = false,
    underline = {
        severity = { min = vim.diagnostic.severity.WARN },
    },
    signs = {
        severity = { min = vim.diagnostic.severity.WARN }
    },
    jump = {
        severity = { min = vim.diagnostic.severity.WARN }
    }
});



require("sunglasses").setup({
    filter_type = "SHADE",
    filter_percent = 0.3,
    -- filter_type = "TINT",
    -- filter_percent = 0.5,
});

local function keymaps_setup()
    local keymaps = require("keymaps");
    keymaps.setup();
end


local function fzf_vim_setup()
    local fzf_vim = require("fzf_vim_setup");
    fzf_vim.setup();
    require("keymaps").fzf_vim();
end

-- pcall(fzf_lua_setup)
pcall(require, "statusline_setup")
pcall(require, "my_jumps")
pcall(require, "my_projects")
pcall(require, "my_project_jumps")
pcall(require, "my_snippets")
pcall(require, "comment")
pcall(require, "oil_setup")
pcall(require, "file_search")
-- pcall(require, "autocomplete")
pcall(require, "my_find")
pcall(require, "todolist_cmd")
pcall(require, "cursor_word_highlight")

keymaps_setup()
-- fzf_lua_setup()
fzf_vim_setup()
require("tabular").setup();


-- colors_setup()
-- vim.api.nvim_create_autocmd("ColorScheme", {
--     callback = function()
--         colors_setup()
--     end,
-- })




local path_nvim_data = vim.fn.stdpath('data');

require("mason").setup({
    install_root_dir = path_nvim_data .. "/../nvim-data-mason",
    registries = {
        "github:mason-org/mason-registry",
        "github:Crashdummyy/mason-registry",
    },
});

local registry = require("mason-registry")
registry.refresh(function()
    for _, name in ipairs({
        "roslyn",
        "clangd",
        "lua-language-server",
    }) do
        local package = registry.get_package(name)

        if not package:is_installed() then
            package:install();
        end
    end
end);

--vim.lsp.semantic_tokens.enable(false);


-- require("mini.icons").setup();
require("mini.icons").tweak_lsp_kind();
require("mini.cmdline").setup({
    autocorrect = { enable = false, },
});

local MiniFiles = require("mini.files");
local MiniPick = require("mini.pick");
local MiniExtra = require("mini.extra");
local MiniCompletion = require('mini.completion');


MiniFiles.setup({
    content = {
        prefix = function()
            return ""
        end,
    },
    mappings = {
        go_in       = "<CR>",
        go_in_plus  = "L",
        go_out      = "_",
        go_out_plus = "H",
    },
});


MiniPick.setup();
MiniExtra.setup();
MiniCompletion.setup({
    lsp_completion = {
        auto_setup = true,
    },
    proccess_items = function(items, base)
        return MiniCompletion.default_process_items(items, base, { filtersort = "fuzzy" });
    end,
    delay = { completion = 50, info = 50, signature = 50 },

    -- Configuration for action windows:
    -- - `height` and `width` are maximum dimensions.
    -- - `border` defines border (as in `nvim_open_win()`; default "single").
    window = {
        info = { height = 25, width = 80, border = nil },
        signature = { height = 25, width = 80, border = nil },
    },
});

vim.keymap.set("n", "<leader>r", function()
    local entry = MiniFiles.get_fs_entry()
    if entry then
        MiniFiles.set_path(entry.path)
    end
end, { buffer = true })
vim.keymap.set("n", "-", "<cmd>lua MiniFiles.open()<CR>");
vim.keymap.set("n", "<C-[><C-s>", function()
    MiniFiles.open(vim.api.nvim_buf_get_name(0), false);
    MiniFiles.reveal_cwd();
end);

vim.keymap.set("n", "<C-\\><C-e>", function()
    MiniExtra.pickers.diagnostic();
end);







require("lsps.lua_ls").setup();
require("lsps.roslyn_ls").setup();
-- require("lsps.c_ls").setup();
-- require("lsps.lua_ls").setup();
-- require("lsps.html_ls").setup();
-- require("lsps.ts_ls").setup();
-- require("lsps.css_ls").setup();
-- require("lsps.json_ls").setup();


require("colors2").setup();


require('nvim-treesitter').setup({
    -- Directory to install parsers and queries to (prepended to `runtimepath` to have priority)
    install_dir = path_nvim_data .. '/../nvim-data-treesitter',
});

require('nvim-treesitter').install({
    "lua",
    "vim",
    "vimdoc",
    "c",
    "cpp",
    "c_sharp",
    "json",
    "markdown",
}):wait(300000); -- wait max. 5 minutes

vim.api.nvim_create_autocmd("FileType", {
    pattern = { '<filetype>' },
    callback = function()
        vim.treesitter.start();
        vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()';
        vim.wo[0][0].foldmethod = 'expr';
    end,
});

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        -- local client = vim.lsp.get_client_by_id(args.data.client_id);
        local bufnr = args.buf;
        require("keymaps").lsp_mappings(bufnr);
    end,
});

local MiniDiff = require("mini.diff");
MiniDiff.setup({
    view = {
        style = "sign",
    },
});

local MiniStarter = require("mini.starter");
MiniStarter.setup({
    header = "",
    items = {
        MiniStarter.sections.recent_files(10, false, false, function(path)
            return vim.fn.fnamemodify(path, ":~:.")
        end),
    },
    footer = "",
});

require('smear_cursor').setup({
    stiffness = 0.8,                      -- 0.6      [0, 1]
    trailing_stiffness = 0.4,             -- 0.45     [0, 1]
    stiffness_insert_mode = 0.6,          -- 0.5      [0, 1]
    trailing_stiffness_insert_mode = 0.6, -- 0.5      [0, 1]
    damping = 0.85,                       -- 0.85     [0, 1]
    damping_insert_mode = 0.95,           -- 0.9      [0, 1]
    distance_stop_animating = 0.5,        -- 0.1      > 0
    -- Your options
});

vim.api.nvim_create_autocmd('User', {
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

vim.api.nvim_create_autocmd("User", {
    pattern = "MiniFilesWindowUpdate",
    callback = function(args)
        local state = MiniFiles.get_explorer_state();
        if not state then
            return;
        end

        local win = args.data.win_id;
        local config = vim.api.nvim_win_get_config(win);

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
        local right = vim.o.columns - 1;

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

vim.api.nvim_set_hl(0, "MiniDiffSignAdd", {
    fg = "#2f662f",
});

vim.api.nvim_set_hl(0, "MiniDiffSignChange", {
    fg = "#1f3fbb",
});

vim.api.nvim_set_hl(0, "MiniDiffSignDelete", {
    fg = "#883f3f",
});

local MiniHiPatterns = require("mini.hipatterns");
MiniHiPatterns.setup({
    highlighters = {
        fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
        hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
        todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
        note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },
        hex_color = MiniHiPatterns.gen_highlighter.hex_color(),
    },
});
