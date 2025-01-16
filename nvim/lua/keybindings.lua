local opts = {
	noremap = true, -- non-recursive
	silent = false, -- do not show message
}

vim.g.mapleader = " "
vim.g.localmapleader = " "

vim.keymap.set("n", "<C-h>", "<C-w>h", opts)
vim.keymap.set("n", "<C-j>", "<C-w>j", opts)
vim.keymap.set("n", "<C-k>", "<C-w>k", opts)
vim.keymap.set("n", "<C-l>", "<C-w>l", opts)

vim.keymap.set("n", "<leader><C-Up>", ":resize -2<CR>", opts)
vim.keymap.set("n", "<leader><C-Down>", ":resize +2<CR>", opts)
vim.keymap.set("n", "<leader><C-Left>", ":vertical resize -2<CR>", opts)
vim.keymap.set("n", "<leader><C-Right>", ":vertical resize +2<CR>", opts)

vim.keymap.set("n", "<C-s>", ":w<cr>", opts)

vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<cr>", opts)
vim.keymap.set("n", "<leader>t", ":terminal<cr>", opts)
vim.keymap.set("n", "<leader>q", ":q<cr>", opts)

vim.keymap.set("i", "jj", "<esc>", opts)
vim.keymap.set("i", "<C-l>", "<right>", opts)
vim.keymap.set("i", "<C-s>", "<esc>:w<cr>", opts)

vim.keymap.set("n", "<leader>ff", ":Telescope find_files<cr>", opts)
vim.keymap.set("n", "<leader>fb", ":Telescope buffers<cr>", opts)
vim.keymap.set("n", "<leader>fg", ":Telescope git_files<cr>", opts)
vim.keymap.set("n", "<leader>fo", ":Telescope oldfiles<cr>", opts)
vim.keymap.set("n", "<leader>fs", ":Telescope grep_string<cr>", opts)
vim.keymap.set("n", "<leader>fw", "*N", opts)

vim.keymap.set("n", "<f5>", ":!make<cr>", opts)

vim.keymap.set("n", "<leader>s", ":%s/", opts)

if vim.g.neovide then
	vim.keymap.set({ "n", "v" }, "<C-+>", ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1<CR>")
	vim.keymap.set({ "n", "v" }, "<C-->", ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.1<CR>")
	vim.keymap.set({ "n", "v" }, "<C-0>", ":lua vim.g.neovide_scale_factor = 1<CR>")
end

vim.keymap.set("n", "gt", ":bnext<cr>", opts)
vim.keymap.set("n", "gT", ":bprevious<cr>", opts)

vim.keymap.set("i", "<C-y>", 'copilot#Accept("\\<CR>")', {
	expr = true,
	replace_keycodes = false,
})
vim.g.copilot_no_tab_map = true
