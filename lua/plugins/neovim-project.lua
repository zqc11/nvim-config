return {
    "coffebar/neovim-project",
    event = "VeryLazy",
    opts = {
        projects = { -- define project roots
            "D:/Project/Rust/*",
            "~/AppData/Local/nvim",
        },
        picker = {
            type = "fzf-lua", -- one of "telescope", "fzf-lua", or "snacks"
        },
    },
    init = function()
        -- enable saving the state of plugins in the session
        vim.opt.sessionoptions:append("globals") -- save global variables that start with an uppercase letter and contain at least one lowercase letter.
    end,
    dependencies = {
        { "nvim-lua/plenary.nvim" },
        -- optional picker
        { "ibhagwan/fzf-lua" },
        -- optional picker
        { "folke/snacks.nvim" },
        { "Shatur/neovim-session-manager" },
    },
    lazy = false,
    priority = 100,
    keys = {
        { "<leader>pd", "<cmd>NeovimProjectDiscover<cr>", desc = "ProjectDiscover" },
        { "<leader>ph", "<cmd>NeovimProjectHistory<cr>", desc = "ProjectHistory" },
    },
}
