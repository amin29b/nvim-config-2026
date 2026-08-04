local vim            = vim;
local o              = vim.opt;
local g              = vim.g;
local map            = vim.keymap.set;
local autocmd        = vim.api.nvim_create_autocmd;
local augroup        = vim.api.nvim_create_augroup("user.cfg", { clear = true });
local usercmd        = vim.api.nvim_create_user_command;
local path_nvim_data = vim.fn.stdpath('data');

local MiniIcons      = require("mini.icons");
local MiniCmdLine    = require("mini.cmdline");
local MiniPick       = require("mini.pick");
local MiniExtra      = require("mini.extra");
local MiniCompletion = require('mini.completion');
local MiniDiff       = require("mini.diff");
local MiniStarter    = require("mini.starter");



-- MiniIcons.setup();
MiniIcons.tweak_lsp_kind();
MiniCmdLine.setup({
    autocorrect = { enable = false, },
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
MiniDiff.setup(
    {
        view = {
            style = "sign",
        },
        options = {
            -- Diff algorithm (see `:h vim.text.diff()`)
            -- algorithm = 'histogram',
            -- algorithm = 'myers',
            algorithm = 'patience',
        }
    }
);

map("n", "<leader>go", MiniDiff.toggle_overlay);
map("n", "<leader>td", function()
    vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { desc = "Toggle diagnostics" })

usercmd("ToggleDiagnostics", function()
    vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, {});
usercmd("ToggleDiff", function()
    MiniDiff.toggle_overlay();
end, {});


MiniStarter.setup({
    header = "",
    items = {
        MiniStarter.sections.recent_files(10, false, false, function(path)
            return vim.fn.fnamemodify(path, ":~:.")
        end),
    },
    footer = "",
});

map("n", "<C-\\><C-e>", MiniExtra.pickers.diagnostic);



local hl = vim.api.nvim_set_hl;
hl(0, "MiniDiffSignAdd", { fg = "#2f662f", });
hl(0, "MiniDiffOverAdd", { bg = "#0d4928", });

hl(0, "MiniDiffSignChange", { fg = "#1f3fbb", });
hl(0, "MiniDiffOverChange", { bg = "#1f3f99", });
hl(0, "MiniDiffOverChangeBuf", { bg = "#1f3f99", });

hl(0, "MiniDiffSignDelete", { fg = "#662f2f", });
hl(0, "MiniDiffOverDelete", { bg = "#662f2f", });
hl(0, "MiniDiffOverDeleteBuf", { bg = "#662f2f", });

local normal = vim.api.nvim_get_hl(0, { name = "Normal" });
hl(0, "MiniDiffOverContext", { bg = "#005555", });
hl(0, "MiniDiffOverContextBuf", { bg = normal.guibg, });

local MiniHiPatterns = require("mini.hipatterns");
MiniHiPatterns.setup({
    highlighters = {
        fixme     = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
        hack      = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
        todo      = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
        note      = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },
        hex_color = MiniHiPatterns.gen_highlighter.hex_color(),
    },
});
