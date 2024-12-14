local opts = {
	noremap = true, -- non-recursive
	silent = true, -- do not show message
}

vim.g.mapleader = " "
vim.g.localmapleader = " "

vim.keymap.set("n", "<C-h>", "<C-w>h", opts)
vim.keymap.set("n", "<C-j>", "<C-w>j", opts)
vim.keymap.set("n", "<C-k>", "<C-w>k", opts)
vim.keymap.set("n", "<C-l>", "<C-w>l", opts)

vim.keymap.set("n", "<C-Up>", ":resize -2<CR>", opts)
vim.keymap.set("n", "<C-Down>", ":resize +2<CR>", opts)
vim.keymap.set("n", "<C-Left>", ":vertical resize -2<CR>", opts)
vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", opts)

vim.keymap.set("n", "<C-s>", ":w<cr>", opts)

vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<cr>", opts)
vim.keymap.set("n", "<leader>t", ":terminal<cr>", opts)

vim.keymap.set("i", "jj", "<esc>", opts)
vim.keymap.set("i", "kk", "<right>", opts)
vim.keymap.set("i", "<C-s>", "<esc>:w<cr>", opts)

vim.keymap.set("n", "<leader>ff", ":Telescope find_files<cr>", opts)
vim.keymap.set("n", "<leader>fg", ":Telescope git_files<cr>", opts)
vim.keymap.set("n", "<leader>fo", ":Telescope oldfiles<cr>", opts)
vim.keymap.set("n", "<leader>fs", ":Telescope grep_string<cr>", opts)

vim.keymap.set("n", "<f5>", ":!make<cr>", opts)

vim.keymap.set("n", "<leader>s", ":%s/", opts)

if vim.g.neovide then
    vim.keymap.set({ "n", "v" }, "<C-+>", ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1<CR>")
    vim.keymap.set({ "n", "v" }, "<C-->", ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.1<CR>")
    vim.keymap.set({ "n", "v" }, "<C-0>", ":lua vim.g.neovide_scale_factor = 1<CR>")
end