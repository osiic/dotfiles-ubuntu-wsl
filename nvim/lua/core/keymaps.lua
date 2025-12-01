local keymap = vim.keymap

-- Escape dari mode insert dan visual
keymap.set("i", "jj", "<Esc>")
keymap.set("v", "jk", "<Esc>")

-- Save file dan keluar
keymap.set("n", "<C-s>", ":w<CR>")
keymap.set("n", "<leader>q", ":q<CR>")

-- Clear highlight search dengan ESC
keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Paste aman dari Windows clipboard
vim.keymap.set('n', '<leader>v', function()
  vim.cmd([[%s/\r//g]])
end, { desc = "Paste from clipboard safely" })

-- Pindah buffer
keymap.set("n", "<S-l>", ":bnext<CR>")
keymap.set("n", "<S-h>", ":bprev<CR>")

-- Pindah window (split)
keymap.set("n", "<C-h>", "<C-w>h")
keymap.set("n", "<C-j>", "<C-w>j")
keymap.set("n", "<C-k>", "<C-w>k")
keymap.set("n", "<C-l>", "<C-w>l")

