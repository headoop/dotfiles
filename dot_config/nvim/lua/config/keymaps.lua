-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set
local status_ok

-- keymap for plugin insgitheader
status_ok, _ = pcall(require, "insgitheader")
if status_ok then
  map("n", "<leader>ii", "<cmd>InsGitHeader<cr>", { desc = "insert git header" })
end

map("n", "<leader>yy", ":normal yypkgccj<cr>", { desc = "line copy & paste, preserve as comment" })

map("n", "<cr>", "o<esc>", { desc = "line insert new" })
map("n", ";;", ":%substitute:::gc<left><left><left><left>", { desc = "search and replace" })
-- toggle between tabs and spaces
map("n", "<f4>", ":set noexpandtab!<c-m>:set expandtab?<c-m>", { desc = "F-key toggle tabs or spaces" })
-- toggle scrollbind on and off
map("n", "<f8>", ":set scb!<cr>:set scb?<cr>", { desc = "F-key toggle scrollbind" })
map("n", "Q", "gww", { desc = "wrap current paragraph" })
map("v", "Q", "gww", { desc = "wrap current selection" })
-- map("v", "<", "<gv", { desc = "Move selection to the left" })
-- map("v", ">", ">gv", { desc = "Move selection to the right" })
-- insert tags for food recipes
local recipetags = require("config.recipetags")
-- { keymap suffix, tag, description }
for _, recipe in ipairs({
  { "TA", "#alkohol", "Alkohol" },
  { "TF", "#fisch", "Fisch" },
  { "TG", "#grillen", "grillen" },
  { "TI", "#italienisch", "italienisch" },
  { "TT", "#türkisch", "türkisch" },
  { "TV", "#vegan", "vegan" },
  { "Ta", "#asiatisch", "asiatisch" },
  { "Tc", "#chinesisch", "chinesisch" },
  { "TC", "#curry", "Curry" },
  { "Td", "#dessert", "Dessert" },
  { "Tf", "#fleisch", "Fleisch" },
  { "Tg", "#griechisch", "griechisch" },
  { "Th", "#huhn", "huhn" },
  { "Ti", "#indisch", "indisch" },
  { "Tk", "#kuchen", "Kuchen" },
  { "Tl", "#levante", "levante" },
  { "Tm", "#mealprep", "Mealprep" },
  { "To", "#ostern", "Ostern" },
  { "Tp", "#pasta", "Pasta" },
  { "Tr", "#raclette", "Raclette" },
  { "Ts", "#salat", "Salat" },
  { "Tt", "#thailändisch", "thailändisch" },
  { "Tv", "#vegetarisch", "vegetarisch" },
  { "Tw", "#weihnachten", "Weihnachten" },
}) do
  local key, tag, desc = recipe[1], recipe[2], recipe[3]
  map("n", "<leader>" .. key, function()
    recipetags.add(tag)
  end, { desc = "tag recipe " .. desc })
end

map("n", '<leader>"', "<C-w>v", { desc = "split window vertically" })
map("n", "<leader>%", "<C-w>s", { desc = "split window horizontally" })

status_ok, _ = pcall(require, "bufferline")
if status_ok then
  map("n", "<Tab>", "<Cmd>BufferLineCycleNext<CR>", { desc = "bufferline cycle to next buffer in bufferline" })
  map("n", "<s-Tab>", "<Cmd>BufferLineCyclePrev<CR>", { desc = "bufferline cycle to previous buffer in bufferline" })
end

function _G.set_terminal_keymaps()
  local opts = { buffer = 0 }
  vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
  vim.keymap.set("t", "jk", [[<C-\><C-n>]], opts)
  vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
  vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
  vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
  vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
  vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], opts)
end
-- if you only want these mappings for toggle term use term://*toggleterm#* instead
vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")
