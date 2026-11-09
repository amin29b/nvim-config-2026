local autocmd = vim.api.nvim_create_autocmd


require("vim._core.ui2").enable({
    enable = true, -- Whether to enable or disable the UI.
    msg = {        -- Options related to the message module.
        ---@type 'cmd'|'msg' Default message target, either in the
        ---cmdline or in a separate ephemeral message window.
        ---@type string|table<string, 'cmd'|'msg'|'pager'> Default message target
        ---or table mapping |ui-messages| kinds and triggers to a target.
        targets = "cmd",
        cmd = {             -- Options related to messages in the cmdline window.
            height = 0.5,   -- Maximum height while expanded for messages beyond 'cmdheight'.
        },
        dialog = {          -- Options related to dialog window.
            height = 0.5,   -- Maximum height.
        },
        msg = {             -- Options related to msg window.
            height = 0.5,   -- Maximum height.
            timeout = 4000, -- Time a message is visible in the message window.
        },
        pager = {           -- Options related to message window.
            height = 1,     -- Maximum height.
        },
    },
})


vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        -- vim.cmd.colorscheme("me_quiet")
        -- vim.cmd.colorscheme("slate")
        vim.cmd.colorscheme("vscode");
        require("colors2").setup();
    end,
})

-- ui -----------------------------------------------------------------------------------
vim.o.background     = "dark"
vim.o.virtualedit    = "all"
vim.o.mouse          = ""
vim.o.number         = true
vim.o.ruler          = true
vim.o.showmode       = false
vim.o.scrolloff      = 5
vim.o.sidescrolloff  = 5 -- keep 5 columns visible left/right of cursor
vim.o.sidescroll     = 3
vim.o.cursorline     = true
vim.o.signcolumn     = "yes:4";
vim.g.have_nerd_font = false
vim.o.belloff        = "all"
vim.o.winborder      = "single"
vim.o.compatible     = false
local termfeatures   = vim.g.termfeatures or {}
termfeatures.osc52   = false
vim.g.termfeatures   = termfeatures
vim.o.updatetime     = 50
vim.o.inccommand     = "split" -- "nosplit"
-- vim.g.loaded_matchparen = 0
vim.o.termguicolors  = true
vim.o.guicursor      =
"a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50,sm:block-blinkwait175-blinkoff150-blinkon175"
vim.o.colorcolumn    = "90"

-- files/state --------------------------------------------------------------------------

vim.o.backup         = false
vim.o.swapfile       = false
vim.o.undofile       = true
vim.o.langremap      = false
vim.opt.shada        = { "'10", "<0", "s10", "h" }
vim.opt.grepprg      = "rg --vimgrep --smart-case --hidden"
vim.o.undodir        = vim.fn.expand("~/.nvim/undodir")
-- vim.opt.clipboard:append("unnamedplus");
vim.opt.isfname:append("@-@");


-- completion ---------------------------------------------------------------------------
vim.o.autocomplete = true
-- vim.opt.completeopt  = { "menu", "menuone", "popup", "fuzzy", "noselect", "nosort"}
-- vim.opt.completeopt  = { "menuone", "noselect", "fuzzy", "nosort" }
vim.o.completeopt  = "menuone,noinsert,popup,fuzzy,nearest"
-- vim.opt.shortmess:append("c")
vim.o.shortmess    = "CFOSWaco"
vim.o.wildmenu     = true
-- vim.o.wildmode    = "full"
vim.o.wildoptions  = "pum"
-- vim.opt.pumheight  = 5
vim.o.pumheight    = 15
vim.o.pummaxwidth  = 40

-- search -------------------------------------------------------------------------------
vim.o.imsearch     = 0
vim.o.hlsearch     = true
vim.o.incsearch    = true
vim.o.ignorecase   = true
vim.o.smartcase    = true


-- indentation --------------------------------------------------------------------------
vim.o.tabstop     = 4
vim.o.softtabstop = 4
vim.o.shiftwidth  = 4
vim.o.expandtab   = true
vim.o.smartindent = true



-- command line -------------------------------------------------------------------------



vim.o.wrap        = false
vim.o.breakindent = true
vim.o.linebreak   = true



vim.g.editorconfig = true
vim.opt.more       = false





vim.g.mapleader      = " "
vim.g.mapleaderlocal = " "

vim.o.laststatus     = 2
vim.o.syntax         = "on"
---------------------------------------------------------------------------------
vim.o.cmdwinheight   = 20
vim.o.cmdheight      = 2

vim.o.splitbelow     = true
vim.o.splitright     = true
vim.o.showtabline    = 2
-- vim.o.formatoptions         = "jql"
-- vim.opt_local.formatoptions = "jql"
vim.opt.formatoptions:remove({ "c", "r", "o" })
vim.api.nvim_create_autocmd("BufEnter", {
    callback = function()
        vim.opt.formatoptions:remove({ "c", "r", "o" })
    end,
})
vim.o.backspace = "indent,eol,start"


vim.o.showmatch = false
vim.o.showcmd   = true


vim.o.encoding   = "utf-8"
vim.o.autoindent = true
vim.o.hidden     = true
-- -- vim.fn.wildtrigger = true


vim.o.foldenable = true
vim.o.foldexpr = 'v:lua.vim.lsp.foldexpr()'
-- vim.o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldmethod = 'expr'
-- vim.o.foldmethod = 'marker'
-- vim.o.foldmarker = '{,}'
vim.opt.fillchars:append { fold = " " }
vim.opt.foldtext = "v:lua._G.MyFoldText()"
function _G.MyFoldText()
    local line = vim.fn.getline(vim.v.foldstart)
    -- if vim.trim(line) == "{" then
    -- if vim.endswith(vim.trim(line), "{") then
    --     return "" .. line .. " [...] " .. "}"
    -- else
    return "" .. line .. " [...] "
    -- end
end

-- vim.opt.guicursor = ""

autocmd("TextYankPost", {
    callback = function()
        vim.hl.on_yank();
    end,
});


--------------------------------------------------------------------------------------------


vim.diagnostic.config({
    virtual_text = { prefix = "" },
    float = { border = "single" },
})


vim.filetype.add({
    extension = {
        h = "c",
        cs = "cs",
        hpp = "cpp",
        vs = "glsl",
        fs = "glsl",
        rv = "rv",
    },
})

autocmd("BufReadPost", {
    desc = "jump to last pos when opening a file",
    callback = function(args)
        local valid_line = vim.fn.line([['"]]) >= 1 and vim.fn.line([['"]]) < vim.fn.line("$")
        local not_commit = vim.b[args.buf].filetype ~= "commit"

        if valid_line and not_commit then
            vim.cmd([[normal! g`"]])
        end
    end,
})
