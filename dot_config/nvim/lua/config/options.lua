-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.opt.backup = true
vim.g.loaded_ruby_provider = 0
-- vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.opt.listchars = { tab = ">·", nbsp = "␣", precedes = "«", extends = "»", trail = "·" }
vim.opt.shada = { "!,'1000,<1000,s100,h" }
vim.opt.hidden = true
vim.opt.breakindent = true
vim.opt.iskeyword:append("-")
vim.opt.softtabstop = 2
