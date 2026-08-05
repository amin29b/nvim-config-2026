require("vim._core.ui2").enable({});
local vim = vim;
local o = vim.opt;
local g = vim.g;
local map = vim.keymap.set;
local autocmd = vim.api.nvim_create_autocmd;
local augroup = vim.api.nvim_create_augroup("user.cfg", { clear = true });
local usercmd = vim.api.nvim_create_user_command;
local path_nvim_data = vim.fn.stdpath('data');


local augroup = vim.api.nvim_create_augroup("user.cfg", { clear = true });
local usercmd = vim.api.nvim_create_user_command;
local path_nvim_data = vim.fn.stdpath('data');
-- :lua vim.pack.update()
-- :lua vim.pack.del()
vim.pack.add({
    { src = "https://github.com/nvim-lua/plenary.nvim", },
    { src = "https://github.com/mofiqul/vscode.nvim", },
    { src = "https://github.com/miversen33/sunglasses.nvim", },
    { src = "https://github.com/junegunn/fzf", },
    { src = "https://github.com/junegunn/fzf.vim", },

    -- { src = "https://github.com/kdheepak/lazygit.nvim", },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter", },

    { src = "https://github.com/neovim/nvim-lspconfig", },
    { src = "https://github.com/mason-org/mason.nvim", },
    { src = "https://github.com/seblyng/roslyn.nvim", },

    { src = "https://github.com/nvim-mini/mini.nvim",             version = "stable" },
    { src = "https://github.com/sphamba/smear-cursor.nvim", },
    { src = "https://github.com/sindrets/diffview.nvim", },

});

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


require("options");
require("terminal").setup();
local MiniGit = require("mini.git");
MiniGit.setup();
vim.keymap.set('n', '<leader>gd', function()
        MiniGit.show_diff_source({ target = 'both', split = 'vertical', });
        vim.cmd("1wincmd c");
        vim.cmd("windo diffthis");
    end,
    { desc = 'Git diff side-by-side' });

pcall(function()
    require("mini-configs.mini-all-config");
    require("mini-configs.minifiles-config");
end);








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
-- pcall(require, "oil_setup")
pcall(require, "file_search")
-- pcall(require, "autocomplete")
pcall(require, "my_find")
pcall(require, "todolist_cmd")
pcall(require, "cursor_word_highlight")

keymaps_setup()
-- fzf_lua_setup()
fzf_vim_setup()
require("tabular").setup();
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


require("mason").setup({
    install_root_dir = path_nvim_data .. "/../nvim-data-00/nvim-data-mason",
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




require("lsps.lua_ls").setup();
require("lsps.roslyn_ls").setup();
-- require("lsps.c_ls").setup();
-- require("lsps.lua_ls").setup();
-- require("lsps.html_ls").setup();
-- require("lsps.ts_ls").setup();
-- require("lsps.css_ls").setup();
-- require("lsps.json_ls").setup();
vim.lsp.enable("yamlls");


require("colors2").setup();


require('nvim-treesitter').setup({
    -- Directory to install parsers and queries to (prepended to `runtimepath` to have priority)
    install_dir = path_nvim_data .. '/../nvim-data-00/nvim-data-treesitter',
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
