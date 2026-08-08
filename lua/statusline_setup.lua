vim.api.nvim_set_hl(0, "DiagWarn", { fg = "#bbbb44", bg = "none", bold = true, });
vim.api.nvim_set_hl(0, "DiagErr", { fg = "#bb4444", bg = "none", bold = true, });
local function lsp_status()
    local attached_clients = vim.lsp.get_clients({ bufnr = 0 })
    if #attached_clients == 0 then
        return "";
    end
    local names = vim.iter(attached_clients)
        :map(function(client)
            local name = client.name:gsub("language.server", "ls")
            return name
        end)
        :totable();
    return "[" .. table.concat(names, ", ") .. "]";
end

local modes = {
    n       = "NORMAL",
    i       = "INSERT",
    v       = "VISUAL",
    V       = "V-LINE",
    ["\22"] = "V-BLOCK",
    c       = "COMMAND",
    t       = "TERMINAL",
    R       = "REPLACE",
    s       = "SELECT",
    S       = "S-LINE",
    ["\19"] = "S-BLOCK",
};


function _G._statusline()
    local mode = modes[vim.fn.mode()] or vim.fn.mode():upper();
    mode = "[" .. mode .. "]";

    local path = vim.b.rel_path or "%f";
    path = "[" .. path .. "]";

    -- local branch = vim.b.git_branch and "%#StlGit# " .. vim.b.git_branch .. " %*" or "";
    local branch = vim.b.git_branch or "";
    if branch ~= "" then
        branch = "[" .. branch .. "]";
    end

    local diag = "";
    local counts = vim.diagnostic.count(0) or {};
    -- local labels = { "E", "W", "I ", "H " };
    -- local hls = { "DiagnosticError", "DiagnosticWarn", "DiagnosticInfo", "DiagnosticHint" };
    local labels = { "E", "W" };
    local hls = { "DiagErr", "DiagWarn" };
    for i = 1, 2 do
        if counts[i] and counts[i] > 0 then
            diag = diag .. "%#" .. hls[i] .. "#" .. labels[i] .. counts[i] .. " %*";
        end
    end
    if diag ~= "" then
        diag = "[" .. diag:sub(1, -4) .. "%*]";
    end

    return table.concat(
        {
            "  ",
            mode,
            "%h%w%m%r",
            path,
            branch,
            "%=",
            diag,
            lsp_status(),
            " %-14(%l,%c%V%)",
            "Buf:%03n",
            "%P",
            "  ",
        },
        " ");
end

vim.api.nvim_create_autocmd("BufEnter", {
    callback = function(args)
        local full_path = vim.api.nvim_buf_get_name(args.buf);
        if full_path ~= vim.b.full_path then
            vim.b.full_path = full_path;

            -- print(full_path);
            local root = vim.fn.system("git rev-parse --show-toplevel  2>$null"):gsub("%s+$", "");
            if root ~= "" then
                vim.b.git_branch = vim.fn.system("git branch --show-current  2>$null"):gsub("%s+$", "");
                vim.b.rel_path = vim.fn.expand("%:p"):sub(#root + 2);
            else
                vim.b.git_branch = nil;
                vim.b.rel_path = vim.fn.expand("%:p:~");
            end
        end
    end
});






vim.o.statusline = "%!v:lua._statusline()";
