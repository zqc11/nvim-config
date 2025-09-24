return {
    "nvim-neo-tree/neo-tree.nvim",
    config = function()
        require("neo-tree").setup({
            filesystem = {
                filtered_items = {
                    hide_gitignored = false,
                },
            },
            window = {
                width = 30,
            },
        })
    end,
}
