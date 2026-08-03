vim.o.compatible    = false
local termfeatures  = vim.g.termfeatures or {}
termfeatures.osc52  = false
vim.g.termfeatures  = termfeatures
vim.g.editorconfig  = true
vim.opt.updatetime  = 50
vim.opt.inccommand  = "split" -- "nosplit"
vim.opt.more        = false
-- vim.g.loaded_matchparen = 0
vim.o.termguicolors = true
vim.o.guicursor     =
"a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50,sm:block-blinkwait175-blinkoff150-blinkon175"
vim.opt.colorcolumn = "90"


-- vim.cmd.colorscheme("me_quiet")
-- vim.cmd.colorscheme("slate")
vim.cmd.colorscheme("vscode")
vim.o.background     = "dark"
vim.o.virtualedit    = "all"
vim.o.mouse          = ""
vim.o.number         = true
vim.g.mapleader      = " "
vim.g.mapleaderlocal = " "
vim.o.cursorline     = true
vim.opt.signcolumn   = "yes:2";
vim.g.have_nerd_font = false
vim.o.belloff        = "all"
vim.o.winborder      = "single"
vim.o.swapfile       = false
vim.opt.backup       = false
vim.o.undofile       = true
vim.o.undodir        = vim.fn.expand("~/.nvim/undodir")
vim.o.incsearch      = true
vim.o.hlsearch       = true
vim.o.ignorecase     = true
vim.o.smartcase      = true

-- vim.opt.completeopt  = { "menu", "menuone", "popup", "fuzzy", "noselect", "nosort"}
vim.opt.completeopt  = { "menuone", "noselect", "fuzzy", "nosort" }
vim.opt.shortmess:append("c")
-- vim.opt.clipboard:append("unnamedplus");
vim.opt.isfname:append("@-@");

vim.o.ruler         = true
vim.o.laststatus    = 2
vim.o.showmode      = false
vim.o.scrolloff     = 5
vim.o.sidescrolloff = 5 -- keep 5 columns visible left/right of cursor
vim.o.sidescroll    = 3
vim.o.wrap          = false
vim.o.tabstop       = 4
vim.o.softtabstop   = 4
vim.o.shiftwidth    = 4
vim.o.expandtab     = true
vim.o.smartindent   = true
vim.o.syntax        = "on"
---------------------------------------------------------------------------------
vim.o.cmdwinheight  = 20
vim.o.cmdheight     = 2

vim.o.splitbelow    = true
vim.o.splitright    = true
vim.o.showtabline   = 2
-- vim.o.formatoptions         = "jql"
-- vim.opt_local.formatoptions = "jql"
vim.opt.formatoptions:remove({ "c", "r", "o" })
vim.api.nvim_create_autocmd("BufEnter", {
    callback = function()
        vim.opt.formatoptions:remove({ "c", "r", "o" })
    end,
})
vim.o.backspace   = "indent,eol,start"

vim.o.wildmenu    = true
-- vim.o.wildmode    = "full"
vim.o.wildoptions = "pum"
vim.opt.pumheight = 5

vim.o.showmatch   = false
vim.o.showcmd     = true

vim.o.encoding    = "utf-8"
vim.o.autoindent  = true
vim.o.hidden      = true
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

vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.hl.on_yank();
    end,
});


--------------------------------------------------------------------------------------------
