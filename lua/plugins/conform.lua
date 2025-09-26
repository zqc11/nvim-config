-- 返回一个符合 Lazy 规范的 table
return {
    -- 依赖 conform.nvim 保证加载顺序，但不去改它的 config
    "stevearc/conform.nvim",
    opts = {
        formatters_by_ft = {
            rust = { "rustfmt", lsp_format = "fallback" },
        },
    },
}
