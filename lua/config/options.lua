-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
local opt = vim.opt
opt.guifont = "UbuntuMono Nerd Font:h12"
opt.scrolloff = 999
-- 自动换行
opt.wrap = true
-- 关闭拼音检查
opt.spell = false
-- 默认 tab 表现为 4 个空格
opt.tabstop = 4 -- 屏幕上 tab 显示宽度
opt.shiftwidth = 4 -- 自动缩进宽度
opt.expandtab = true -- 把真正的 tab 转成空格
