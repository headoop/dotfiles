-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

local augroup = vim.api.nvim_create_augroup -- Create/get autocommand group
local autocmd = vim.api.nvim_create_autocmd -- Create autocommand
-- needed for macro JSLogMacro:
local esc = vim.api.nvim_replace_termcodes("<esc>", true, false, true)

-- RECIPE FILES
augroup("recipeFiles", { clear = true })
autocmd({ "BufNewFile", "BufRead" }, {
  pattern = { "*/Rezepte/*.txt" },
  group = "recipeFiles",
  command = "setlocal textwidth=85",
})
autocmd({ "BufNewFile", "BufRead" }, {
  pattern = { "*/Rezepte/*.txt" },
  group = "recipeFiles",
  -- uses plugin Snacks.indent
  callback = require("snacks.indent").disable,
})
autocmd("BufWritePre", {
  pattern = { "*/Rezepte/*.txt" },
  group = "recipeFiles",
  callback = function()
    vim.cmd([[ %le4 ]])
    vim.cmd([[ %s:^    $::ge ]])
  end,
})
autocmd({ "BufNewFile", "BufRead" }, {
  pattern = { "*/Rezepte/*.txt" },
  group = "recipeFiles",
  command = "setlocal nospell",
})

-- FILETYPE SETTINGS
--
-- Set indentation to 2 spaces
augroup("setIndent", { clear = true })
autocmd("Filetype", {
  group = "setIndent",
  pattern = { "xml", "html", "xhtml", "css", "scss", "javascript", "typescript", "yaml", "lua" },
  command = "setlocal shiftwidth=2 tabstop=2",
})

-- MUTT
augroup("muttFiles", { clear = true })
autocmd({ "BufNewFile", "BufRead" }, {
  group = "muttFiles",
  pattern = { ".article*", ".followup", ".letter*", "/tmp/mutt-*" },
  callback = function()
    vim.cmd([[ setlocal nobackup ]])
    vim.cmd([[ setlocal nofoldenable ]])
    vim.cmd([[ normal gg}j ]])
  end,
})
autocmd({ "BufNewFile", "BufRead" }, {
  group = "muttFiles",
  pattern = { "*_muttrc", "muttrc" },
  command = "setlocal filetype=muttrc",
})

-- ZSH
augroup("zshFiles", { clear = true })
autocmd({ "BufRead" }, {
  group = "zshFiles",
  pattern = { "generic.zshrc", ".zshrc", ".zshrc.local" },
  command = "setlocal filetype=zsh",
})

-- GENERAL SETTINGS

-- Remove trailing whitespace on save
augroup("GeneralSettings", { clear = true })
autocmd("BufWritePre", {
  group = "GeneralSettings",
  pattern = "",
  command = ":%s/\\s\\+$//e",
})

augroup("Python", { clear = true })
autocmd({ "FileType" }, {
  group = "Python",
  pattern = "python",
  command = "setlocal colorcolumn=80",
})

augroup("JSLogMacro", { clear = true })
-- visually select var name and press @l to generate console.log of the var content
autocmd({ "FileType" }, {
  group = "JSLogMacro",
  pattern = { "javascript", "typescript" },
  callback = function()
    vim.fn.setreg("l", "yoconsole.log('" .. esc .. "pa:" .. esc .. "la, " .. esc .. "pl")
  end,
})

augroup("PKGBUILD", { clear = true })
autocmd({ "BufRead", "BufNewFile" }, {
  group = "PKGBUILD",
  pattern = "PKGBUILD",
  command = "setlocal filetype=txt",
})
