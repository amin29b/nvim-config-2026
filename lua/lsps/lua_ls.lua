local function setup()
    -- vim.lsp.config("lua_ls", {
    --     settings = {
    --         Lua = {
    --             diagnostics = { globals = { "vim" } },
    --         },
    --     },
    -- -- });
    vim.lsp.config("lua_ls", {
        settings = {
            Lua = {
                runtime = { version = "LuaJIT" },
                workspace = {
                    checkThirdParty = false,
                    library = { vim.env.VIMRUNTIME },
                },
                telemetry = { enable = false },
            },
        },
    });

    vim.lsp.enable("lua_ls");
end


return {
    setup = function()
        pcall(setup);
    end,
};
