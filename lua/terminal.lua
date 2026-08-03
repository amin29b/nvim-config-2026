local usercmd = vim.api.nvim_create_user_command;
-- local terminal = nil
-- local function open_terminal()
--     if terminal and not vim.api.nvim_win_is_valid(terminal) then
--         terminal = nil
--     else
--         vim.cmd("below split | terminal");
--         terminal = vim.api.nvim_get_current_win();
--     end
-- end

-- local function close_terminal()
--     if terminal and not vim.api.nvim_win_is_valid(terminal) then
--         terminal = nil
--     elseif terminal then
--         vim.api.nvim_win_hide(terminal)
--         terminal = nil
--     end
-- end

-- local function toggle_term()
--
-- end

local function terminal_setup()
    usercmd("Terminal" , "below split | terminal",{});
    -- vim.keymap.set("n", "<C-t><C-o>", open_terminal, {});
    --
    -- vim.keymap.set("n", "<C-t><C-t>", close_terminal, {});
    -- vim.keymap.set("t", "<C-t><C-y>", close_terminal, {});
end

return {
    setup = function()
        pcall(terminal_setup)
    end,
}
