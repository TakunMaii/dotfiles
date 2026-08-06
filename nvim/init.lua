-- 基础设置
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

vim.opt.number = true

-- 前缀键
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- 插件列表
vim.pack.add({
  { src = 'https://github.com/morhetz/gruvbox' },
  { src = 'https://github.com/windwp/nvim-autopairs' },
  { src = 'https://github.com/mg979/vim-visual-multi' },
  { src = 'https://github.com/nvim-tree/nvim-tree.lua' },
  { src = 'https://github.com/tpope/vim-commentary' },
  { src = 'https://github.com/nvim-telescope/telescope.nvim' },
  { src = 'https://github.com/nvim-lua/plenary.nvim' },
})

-- setup as it requires
require("nvim-tree").setup()
require("nvim-autopairs").setup()

-- lsp
vim.lsp.config('clangd', {
	cmd = {'clangd'},
	filetypes = {'c', 'cpp'},
	root_markers = {'.clangd', 'compile_commands.json'}
})
vim.lsp.config('lua_ls', {
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  root_markers = { { '.luarc.json', '.luarc.jsonc' }, '.git' },
})
vim.lsp.config('pyright', {
	cmd = {'pyright-langserver', "--stdio"},
	filetypes = {'python'},
})
vim.lsp.config('ols', {
	cmd = {'ols'},
	filetypes = {'odin'},
})
vim.lsp.enable({'clangd', 'lua_ls', 'pyright', 'ols'})
vim.o.autocomplete = true
vim.api.nvim_create_autocmd('LspAttach', {
	callback = function(ev)
		local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))
		if client:supports_method('textDocument/completion') then
			vim.lsp.completion.enable(true, client.id, ev.buf, {autotrigger = true})
		end
	end
})
vim.opt.complete = {'o', '.', 'w', 'b', 'u', 't'}
vim.opt.completeopt = {'menuone', 'noinsert'}
vim.diagnostic.config({
  virtual_text = {
    severity = vim.diagnostic.severity.ERROR,
  },
  signs = {
    severity = vim.diagnostic.severity.ERROR,
  },
  underline = {
    severity = vim.diagnostic.severity.ERROR,
  },
  float = {
    severity = vim.diagnostic.severity.ERROR,
  },
  update_in_insert = false,
  severity_sort = true,
})
vim.keymap.set("i", "<Tab>", function()
  if vim.fn.pumvisible() == 1 then
    return "<C-n>"
  else
    return "<Tab>"
  end
end, { expr = true, desc = "Next completion item or normal Tab" })

vim.keymap.set("i", "<C-Tab>", function()
  if vim.fn.pumvisible() == 1 then
    return "<C-p>"
  else
    return "<C-Tab>"
  end
end, { expr = true, desc = "Prev completion item or normal C-Tab" })
vim.keymap.set("i", "<Enter>", function()
  if vim.fn.pumvisible() == 1 then
    return "<C-y>"
  else
    return "<Enter>"
  end
end, { expr = true, desc = "Enter to confirm choice or normal Enter" })

vim.cmd('colorscheme gruvbox')
vim.opt.background = 'dark'

local map = vim.keymap.set
map("n", "<leader>ff", ":Telescope find_files<CR>")
map("n", "<leader>fs", ":Telescope live_grep<CR>")
map("n", "<leader>fb", ":Telescope buffers<CR>")

-- 常用快捷键
map('n', '<space>b', ':buffers<CR>:b ')
map('n', '<space>s', '<cmd>b#<CR>')
map('n', '<space>e', '<cmd>NvimTreeToggle<CR>')
map('n', '<space>w', '<cmd>w<CR>')
map('n', '<space>q', '<cmd>q<CR>')
map('n', '<C-s>', '<cmd>w<CR>')
map('i', '<C-s>', '<ESC>:w<CR>')
map('i', 'jj', '<ESC>')
map('i', 'kk', '<Right>')
map('n', '<F5>', '<cmd>!make<CR>')
map('n', '<C-j>', '<C-w>j')
map('n', '<C-k>', '<C-w>k')
map('n', '<C-h>', '<C-w>h')
map('n', '<C-l>', '<C-w>l')
