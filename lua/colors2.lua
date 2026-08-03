local function setup()
    vim.cmd([[

    hi LineNr       guifg=#191989 guibg=#101010
    hi Cursor       guifg=#00FF00 guibg=#00FF00
    hi CursorLine   guifg=NONE    guibg=#000077
    hi Visual       guifg=NONE    guibg=#555500 gui=NONE
    hi MatchParen   guifg=#FF2222 guibg=NONE
    hi IncSearch    guifg=#FF00FF guibg=#00FFFF
    hi Search       guifg=#e3e3e3 guibg=#c481ff
    hi StatusLine   guifg=#1bFF1e guibg=#054756 gui=bold
    hi StatusLineNC guifg=#1bFF1e guibg=#05e3e3 gui=NONE
    hi VertSplit    guifg=#e24756 guibg=NONE    gui=NONE

    hi Cursor       guifg=reverse guibg=#2CFF05 gui=NONE    ctermfg=NONE ctermbg=NONE cterm=NONE
    hi CursorIM     guifg=#000000 guibg=#00ff00 gui=NONE    ctermfg=NONE ctermbg=NONE cterm=NONE
    hi CursorLine   guifg=NONE    guibg=#101055 gui=NONE    ctermfg=NONE ctermbg=NONE cterm=NONE
    hi CursorLineNr guifg=#dadada guibg=#101080 gui=NONE    ctermfg=NONE ctermbg=NONE cterm=NONE
    hi CursorColumn guifg=NONE    guibg=#303030 gui=NONE    ctermfg=NONE ctermbg=NONE cterm=NONE
    hi LineNr       guifg=#303030 guibg=#101010 gui=NONE    ctermfg=NONE ctermbg=NONE cterm=NONE
    "hi PMenuSel     guifg=#202020 guibg=#109900
    hi Pmenu        guifg=#1b1d1e guibg=#e24756


    hi TODO         guifg=#661111 guibg=NONE gui=bold,underline cterm=bold,underline
    hi NOTE         guifg=#119911 guibg=NONE gui=bold,underline cterm=bold,underline
    hi STUDY        guifg=#FFFF11 guibg=NONE gui=bold,underline cterm=bold,underline
    hi IMPORTANT    guifg=#FFFF11 guibg=NONE gui=bold,underline cterm=bold,underline
    hi FIXME        guifg=#999910 guibg=NONE gui=bold,underline cterm=bold,underline
    hi BUG          guifg=#999910 guibg=NONE gui=bold,underline cterm=bold,underline

    hi HighlighCursorWord    guifg=NONE guibg=#225555
    hi ExtraWhiteSpace       guifg=NONE guibg=#113211
    hi EndOfBuffer           guifg=NONE guibg=#111120
    ]]);

    vim.cmd([[
    hi DiagnosticUnderlineError guifg=NONE guibg=#440000 gui=NONE
    hi DiagnosticUnderlineWarn  guifg=NONE guibg=#444400 gui=NONE
    hi DiagnosticUnderlineInfo  guifg=NONE guibg=Blue    gui=NONE
    hi DiagnosticUnderlineHint  guifg=NONE guibg=Green   gui=NONE
    ]]);


    local function set_matchadd_common()
        vim.fn.matchadd("ExtraWhitespace", "\\s\\+$")
        vim.fn.matchadd("TODOColor", "\\<TODO\\>")
        vim.fn.matchadd("NOTEColor", "\\<NOTE\\>")
        vim.fn.matchadd("STUDYColor", "\\<STUDY\\>")
        vim.fn.matchadd("IMPORTANTColor", "\\<IMPORTANT\\>")
        vim.fn.matchadd("FIXMEColor", "\\<FIXME\\>")
        vim.fn.matchadd("BUGColor", "\\<BUG\\>")
    end

    set_matchadd_common();
    vim.cmd([[
    hi @lsp.type.excludedCode.cs guifg=#5C6370    guibg=NONE    gui=NONE
    hi Normal                    guifg=#D4D4D4    guibg=#050505
    ]]);
end

return {
    setup = function()
        pcall(setup);
    end,
}
