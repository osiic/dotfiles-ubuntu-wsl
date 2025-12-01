-- Set mapleader and maplocalleader
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- General settings
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true

-- Indentation settings
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.tabstop = 2
vim.opt.shiftround = true

-- UI settings
vim.opt.cursorline = true
vim.opt.relativenumber = true
vim.opt.wrap = false
vim.opt.scrolloff = 10
vim.opt.laststatus = 2
vim.opt.showcmd = true

-- Search settings
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.showmatch = true
vim.opt.hlsearch = true -- <-- benerin ini, sebelumnya kamu nulis `vim.opt.hl = true` (tidak valid)

-- Misc
vim.opt.history = 1000
vim.opt.autowrite = true
vim.opt.backspace = { "indent", "eol", "start" } -- "2" sudah deprecated

-- Clipboard
vim.opt.clipboard = "unnamedplus"

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})
