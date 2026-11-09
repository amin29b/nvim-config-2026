local function setup()
    vim.lsp.enable('tsserver');
    local ts_ls_path = vim.fn.stdpath("config") ..
        "/../nvim-data-00/nvim-data-mason/bin/typescript-language-server.cmd"
    ts_ls_path = vim.fn.expand(ts_ls_path)
    vim.fn.printf(ts_ls_path);
    vim.lsp.config('tsserver', {
        cmd = { ts_ls_path, "--stdio" },
        filetypes = {
          'javascript', 'javascriptreact', 'javascript.jsx',
          'typescript', 'typescriptreact', 'typescript.tsx',
          'html' },
        on_attach = function(client, bufnr)
            require("keymaps").lsp_mappings(bufnr);
            vim.treesitter.start();
        end,
    });

end


return {
    setup = function()
        pcall(setup);
    end,
};
