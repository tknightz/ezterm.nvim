local M = {}

local count = 0
local terminals = {}
local config = {
    theme = "dropdown",
    previewer = true,
    init_mode = "insert"
}

M.setup = function(user_conf)
    config = vim.tbl_extend("force", config, user_conf)
end

M.create_win = function(direction, bufnr, enter)
    local _enter = false
    if enter ~= nil then
        _enter = enter
    end

    local ui = vim.api.nvim_list_uis()[1]
    local height = math.floor(ui.height / 2)
    local width = math.floor(ui.width * 0.7)
    local row = math.floor((ui.height - height) / 2)
    local col = math.floor((ui.width - width) / 2)

    if direction == "top" then
        height = math.floor(ui.height / 3)
        width = ui.width
        row = 0
        col = 0
    elseif direction == "left" then
        height = ui.height
        width = math.floor(ui.width / 2)
        row = 0
        col = 0
    elseif direction == "bottom" then
        height = math.floor(ui.height / 3)
        width = ui.width
        row = ui.height - height
        col = 0
    elseif direction == "right" then
        height = ui.height
        width = math.floor(ui.width / 2)
        row = 0
        col = ui.width - width
    end

    local opts = {
        relative = "win",
        height = height,
        width = width,
        row = row,
        col = col,
        border = "rounded",
        style = "minimal",
        zindex = 10, 
    }

    local win = vim.api.nvim_open_win(bufnr, _enter, opts)
    vim.api.nvim_win_set_option(win, "cursorline", true)

    return {
        win = win,
        opts = opts
    }

end

M.new_term = function(direction, enter)
    local _enter = enter and enter or false
    local buf = vim.api.nvim_create_buf(true, true)

    vim.api.nvim_buf_call(buf, function()
        vim.cmd[[term]]
    end)
    vim.api.nvim_buf_set_var(buf, "ezterm", true)
    vim.bo[buf].filetype = "terminals"

    local infor = M.create_win(direction, buf, enter)

    if config.init_mode == "insert" then
        vim.api.nvim_feedkeys("i", "n", true)
    end


    local name = "Terminal " .. (count + 1)

    terminals[buf] = {
        name = name,
        bufnr = buf,
        win = infor.win,
        direction = direction,
        opts = infor.opts
    }
    count = count + 1
end

M.rename_term = function(bufnr, new_name)
    terminals[bufnr].name = new_name
end

M.get_win_from_bufnr = function(bufnr)
    local win = terminals[bufnr].win
    if vim.api.nvim_win_is_valid(win) then
        return win
    else
        return nil
    end
end

M.open_term = function(bufnr, enter_insert)
    local insert = enter_insert ~= nil and enter_insert or true
    vim.api.nvim_command("stopinsert")
    local win = M.get_win_from_bufnr(bufnr)
    if win ~= nil then
        vim.api.nvim_win_set_buf(win, bufnr)
        vim.api.nvim_set_current_win(win)
    else
        local infor = M.create_win(terminals[bufnr].direction, bufnr, true)
        terminals[bufnr].win = infor.win
        terminals[bufnr].opts = infor.opts
    end

    if insert then
        vim.api.nvim_feedkeys("i", "n", true)
    end
end



M.change_direction = function(bufnr, direction)
    if terminals[bufnr] ~= nil then
        terminals[bufnr].direction = direction

        if vim.api.nvim_win_is_valid(terminals[bufnr].win) then
            vim.api.nvim_win_hide(terminals[bufnr].win)
            local infor = M.create_win(direction, bufnr)
            terminals[bufnr].win = infor.win
            terminals[bufnr].opts = infor.opts
        end
    end
end

M.get_terminals = function()
    local temp_term = {}
    for id, term in pairs(terminals) do
        if vim.api.nvim_buf_is_valid(term.bufnr) then
            temp_term[id] = term
        end
    end
    terminals = temp_term
    return temp_term
end


M.ezterm_command = function()
    local theme_set = config.theme and "theme=get_" .. config.theme or " "
    local previewer_set = config.previewer and "" or "previewer=false"

    if not pcall(require, "telescope") then
        vim.cmd[[PackerLoad telescope.nvim]]
    end

    local cmd = string.format("Telescope ezterm %s %s", theme_set, previewer_set)
    vim.cmd(cmd)
end


return M
