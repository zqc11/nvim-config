-- lua/plugins/cmp.lua
return {
    "saghen/blink.cmp",
    opts = {
        keymap = {
            preset = "super-tab", -- 接受
            ["<C-j>"] = { "select_next", "fallback" },
            ["<C-k>"] = { "select_prev", "fallback" },
            ["<CR>"] = { "accept", "fallback" },
        },
    },
}
