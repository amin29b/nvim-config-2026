local M = {}
local map = vim.keymap.set;
local utils = require("utils");

function M.setup()
    local opts = { noremap = true, silent = true }
    local opts2 = { remap = true, silent = true }
    -- map("n", "<PageUp>", "<Nop>")
    -- map("n", "<PageDown>", "<Nop>")

    -- -- Space
    map({ "n", "v" }, "<Space>", "<Nop>")

    -- Ctrl-Space
    map({ "n", "i", "v" }, "<C-Space>", "<Nop>")

    -- Ctrl-C
    map({ "n", "v" }, "<C-c>", "<Nop>")
    map("i", "<C-c>", "<Esc>")
    map("n", "<C-c>", ":nohl<CR>")

    map("n", "J", "mzJ`z")

    map("n", "þ", "<Nop>")
    map("v", "þ", "<Nop>")
    map("i", "þ", "<Nop>")

    map("n", "ý", "<Nop>")
    map("v", "ý", "<Nop>")
    map("i", "ý", "<Nop>")

    map("n", "<C-S-b>", "<Nop>")
    map("n", "<C-S-B>", "<Nop>")

    map("v", ">", ">gv")
    map("v", "<", "<gv")

    map("v", "J", ":m '>+1<CR>gv=gv")
    map("v", "K", ":m '<-2<CR>gv=gv")

    -- Insert mode
    map("i", "<C-j>", "<Nop>")
    -- map("i", "<C-h>", "<Nop>", { remap = true })

    -- i for Insert mode
    -- c for Command-line mode
    -- t for Terminal mode
    map({ "i", "c", "t" }, "<C-h>", "<left>")
    map({ "i", "c", "t" }, "<C-j>", "<down>")
    map({ "i", "c", "t" }, "<C-k>", "<up>")
    map({ "i", "c", "t" }, "<C-l>", "<right>")

    map("n", "<C-l>", "<Nop>")


    -- Normal mode
    map("n", "<leader>so", ":source $MYVIMRC<CR>", opts)
    map("n", "<leader>no", ":noh<CR>", opts)

    -- map("i", "<C-x><C-k>", function()
    --     return SpellCheck("<C-x><C-k>")
    -- end, { expr = true, noremap = true })


    map("n", "<F6>", function()
        vim.fn.setreg("+", vim.fn.fnamemodify(vim.fn.expand("%"), ":p"))
    end, { noremap = true, silent = true })

    map("n", "<leader>jo", '<cmd>MyProjectJumps<cr>')
    map("n", "<leader>jj", '<cmd>AddProjectJump<cr>')

    map({ "n" }, "<leader>js", '<cmd>MyProjectSnippets<cr>')

    -- map("n", "<leader>jo", '<cmd>MyJumps<cr>')
    -- map("n", "<leader>jj", '<cmd>lua add_jump()<cr>')

    -- map("n", "<leader>ju", '<cmd>Jumps<cr>')

    local skComment = require("comment");
    map('n', '<C-k><C-c>', skComment.comment, { expr = true, desc = 'Comment line' })
    map('n', '<C-k><C-u>', skComment.uncomment, { expr = true, desc = 'Uncomment line' })

    map('v', '<C-k><C-c>', skComment.comment_gv, { expr = true, desc = 'Comment line' })
    map('v', '<C-k><C-u>', skComment.uncomment_gv, { expr = true, desc = 'Uncomment line' })

    -- map("n", "-", "<CMD>Oil --float<CR>", { desc = "Open parent directory" })
    map("n", "<leader>B", "<CMD>Build<CR>", { noremap = true, desc = "Build Project" })
    map("n", "<leader>bb", "<CMD>Build<CR>", { noremap = true, desc = "Build Project" })
    map("n", "<leader>rr", "<CMD>HotRelaod<CR>", { noremap = true, desc = "HotRelaod Project" })

    -- vim.api.nvim_create_autocmd("FileType", {
    --     pattern = "oil",
    --     callback = function()
    --         map("n", "q", "<cmd>close<CR>", { buffer = true, silent = true, })
    --         map("n", "", "<cmd>close<CR>", { buffer = true, silent = true, })
    --     end,
    -- })

    map("n", "*", function()
        vim.fn.setreg("/", "\\c" .. vim.fn.expand("<cword>"))
        vim.cmd("normal! n")
    end, { noremap = true })

    -- map("n", "#", function()
    --     vim.fn.setreg("/", vim.fn.expand("<cword>"))
    -- or
    -- vim.fn.setreg("/", "\\c" .. vim.fn.expand("<cword>"))
    --     vim.cmd("normal! N")
    -- end, { noremap = true })
    map("v", "<leader>tt",
        function()
            require("tabular").tabular()
        end
        , opts)

    vim.cmd([[
        nnoremap <space><space> <Esc>/\$\$\$\$<Enter>"_c4l

        " Markers
        nnoremap mm <Esc><Esc>/\/\*x\*\/<Enter>zz
        nnoremap MM <Esc><Esc>?\/\*x\*\/<Enter>zz
        nnoremap ms <Esc><Esc>/\/\/\s*[=]\+.*$<Enter>zz
        nnoremap MS <Esc><Esc>?\/\/\s*[=]\+.*$<Enter>zz

        nnoremap mn <Esc><Esc>o/*x*/<Esc>
        nnoremap md <Esc><Esc>"_5r<space>4h<Esc>
    ]])

    map("v", "<leader>D", [[:<C-u>'<,'>s/\s\+$//e | noh<CR>]])
    map("n", "<leader>D", [[<CMD>s/\s\+$//e | noh<CR>]])

    map({ "n", "v" }, "<leader>d", '"_d')
    map({ "n", "v" }, "<leader>x", '"_x')

    map("n", "n", "nzzzv", {});
    map("n", "N", "Nzzzv", {});

    map("n", "<C-d>", "<C-d>zz", {});
    map("n", "<C-u>", "<C-u>zz", {});


    map("n", "<leader>u",
        function()
            require("undotree").open();
        end,
        {});
end

function M.lsp_mappings(bufnr)
    local opts = { buffer = bufnr }

    map("n", "<F12>", vim.lsp.buf.definition, opts)
    map("n", "<F11>", vim.lsp.buf.references, opts)
    map("n", "<C-k><C-l>", vim.lsp.buf.references, opts)

    map("n", "<C-k><C-d>", vim.lsp.buf.format, opts)
    map("n", "<C-k><C-r>", vim.lsp.buf.rename, opts)
    map("n", "<C-k><C-i>", function()
        vim.lsp.buf.hover({ border = "single" })
    end, opts)


    -- Diagnostics
    map("n", "<leader>lp", function()
        vim.diagnostic.setqflist({ severity = { min = vim.diagnostic.severity.WARN } });
        -- vim.diagnostic.setqflist({ severity = { min = vim.diagnostic.severity.ERROR } });
    end, opts)

    -- NOTE(^min): use ]q  and  [q
    -- map("n", "]q", function() vim.diagnostic.jump({ count = 1, float = false }); end, opts);
    -- map("n", "[q", function() vim.diagnostic.jump({ count = -1, float = false }); end, opts);

    map("n", "<leader>lo",
        function()
            vim.diagnostic.open_float({ border = "single" });
        end, opts);


    -- Code actions
    -- "<C-.> -> ý
    map("n", "ý", vim.lsp.buf.code_action, opts)
    map("v", "ý", vim.lsp.buf.code_action, opts)
    -- map("i", "þ", "<C-x><C-o>", opts)
end

function M.fzf_vim()
    -- vim.cmd("autocmd FileType qf nnoremap <buffer> <CR> <CR><C-w>p");
    vim.cmd("autocmd FileType qf nnoremap <buffer> <CR> <CR>:copen<CR>");
    vim.cmd("autocmd FileType qf nnoremap <buffer> <leader><CR> <CR> ");


    -- vim.api.nvim_create_autocmd("FileType", {
    --     pattern = "qf",
    --     callback = function()
    --         -- Make <CR> just select/highlight without jumping
    --         vim.keymap.set("n", "<CR>", function()
    --             -- Just visual select current line or do nothing
    --             vim.cmd("normal! v")
    --             -- vim.notify("Selected item (stay in quickfix)", vim.log.levels.INFO)
    --         end, { buffer = true, desc = "Select item without jumping" })
    --
    --         -- Make <leader><CR> do the original jump behavior
    --         vim.keymap.set("n", "<leader><CR>", function()
    --             -- Original <CR> behavior: jump to location
    --             -- This is the default quickfix behavior
    --             vim.cmd("normal! <CR>")
    --         end, { buffer = true, desc = "Jump to selected item" })
    --     end
    -- })
    -- vim.cmd("autocmd FileType qf nnoremap <buffer> <CR> <Nop>");
    -- local opts = { buffer = bufnr }
    local opts = {};

    -- map("n", "<leader>/", "<cmd>BLines<cr>", opts);
    map("n", "<leader>/",
        function()
            vim.ui.input({ prompt = "Search Buffer: " },
                function(query)
                    if not query or query == "" then
                        return
                    end

                    -- local pattern = vim.fn.escape(query, [[\/]])
                    local pattern = query;

                    vim.cmd("silent! vimgrep /" .. pattern .. "/j %");
                    vim.cmd("silent! copen");
                end);
        end
        , opts);


    -- map("v", "<leader>/",
    --     function() -- grep visual selection in current buffer
    --         local query = require("utils").get_visual_selection();
    --         if query == "" then
    --             return;
    --         end
    --         vim.cmd("BLines " .. query);
    --     end
    --     , opts);

    map("v", "<leader>/",
        function()
            local query = utils.get_visual_selection();
            if query == "" then
                return;
            end

            vim.cmd("silent! vimgrep /" .. query .. "/j %");
            vim.cmd("silent! copen");
        end
        , opts);



    -- map("n", "<leader>g/",
    --     function()
    --         local cwd = utils.FindProjectRoot({ "*.root", ".git" }):gsub("\\", "/") -- IMPORTANT on Windows
    --         vim.cmd(string.format([[
    --             call fzf#vim#grep(
    --             \   'rg  --with-filename  --column --line-number --no-heading --color=always --smart-case '.shellescape(""),
    --             \       1,
    --             \       fzf#vim#with_preview({ 'dir' : '%s' ,'options': '--delimiter : --nth 3..'},'down', 'ctrl-/'),
    --             \       !0
    --             \   )
    --         ]], cwd));
    --     end
    --     , opts);
    map("n", "<leader>g/",
        function()
            local dir_proj_root = utils.FindProjectRoot({ "*.root", ".git" }):gsub("\\", "/"); -- IMPORTANT on Windows
            local path = vim.fn.fnameescape(dir_proj_root) .. "/**";

            vim.ui.input({ prompt = "Search From Root: " },
                function(query)
                    if not query or query == "" then
                        return
                    end

                    -- local pattern = vim.fn.escape(query, [[\/]])
                    local pattern = query;

                    vim.cmd("silent! vimgrep /" .. pattern .. "/j " .. path);
                    vim.cmd("silent! copen");
                end);
        end
        , opts);



    map("v", "<leader>g/",
        function()
            local query = utils.get_visual_selection();
            if query == "" then
                return;
            end

            local dir_proj_root = utils.FindProjectRoot({ "*.root", ".git" }):gsub("\\", "/"); -- IMPORTANT on Windows
            local path = vim.fn.fnameescape(dir_proj_root) .. "/**";

            vim.cmd("silent! vimgrep /" .. query .. "/j " .. path);
            vim.cmd("silent! copen");
        end
        , opts);

    map("n", "<leader>ls",
        function()
            vim.cmd("Buffers");
        end
        , opts);
end

return M;
