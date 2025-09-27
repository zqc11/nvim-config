return {
    "907th/vim-auto-save", -- 也可以选 Pocco81/auto-save.nvim
    event = "VeryLazy",
    config = function()
        vim.g.auto_save = 1 -- 启用
        vim.g.auto_save_silent = 1 -- 不显示 "saved" 消息
        vim.g.auto_save_events = { -- 触发时机
            "InsertLeave",
            "TextChanged",
            "TextChangedI",
        }
    end,
}
