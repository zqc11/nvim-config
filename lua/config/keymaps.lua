-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local set = vim.keymap.set

-- Edit
set("i", "ee", "=", { desc = "Quick type '=' char" })
set("i", "aa", "+", { desc = "Quick type '+' char" })
set("i", "s<leader>s", "-", { desc = "Quick type '-' char" })
set("i", "d<leader>d", "_", { desc = "Quick type '_' char" })
