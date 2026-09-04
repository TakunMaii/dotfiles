-- 基础设置
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

vim.opt.number = true
vim.opt.relativenumber = true

-- 前缀键
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- 插件列表
vim.pack.add({
  { src = 'https://github.com/morhetz/gruvbox' },
  { src = 'https://github.com/vim-airline/vim-airline' },
  { src = 'https://github.com/windwp/nvim-autopairs' },
  { src = 'https://github.com/mg979/vim-visual-multi' },
  { src = 'https://github.com/nvim-tree/nvim-tree.lua' },
  { src = 'https://github.com/tpope/vim-commentary' },
  { src = 'https://github.com/nvim-telescope/telescope.nvim' },
  { src = 'https://github.com/nvim-lua/plenary.nvim' },
  { src = 'https://github.com/Saghen/blink.cmp', version = vim.version.range('1.*') },
  { src = 'https://github.com/rafamadriz/friendly-snippets' },
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter' },
  { src = 'https://github.com/easymotion/vim-easymotion' },
})

-- setup as it requires
require("nvim-tree").setup()
require("nvim-autopairs").setup()
local treesitter_langs = {
  "c",
  "cpp",
  "lua",
  "markdown",
  "markdown_inline",
  "python",
  "rust",
  "zig",
}
require("nvim-treesitter").setup()
require("nvim-treesitter").install(treesitter_langs)
vim.api.nvim_create_autocmd("FileType", {
  pattern = treesitter_langs,
  callback = function()
    pcall(vim.treesitter.start)
  end,
})
require("blink.cmp").setup({
  keymap = {
    preset = "default",
    ["<CR>"] = { "accept", "fallback" },
  },
  appearance = {
    nerd_font_variant = "mono",
  },
  completion = {
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 250,
      treesitter_highlighting = true,
      window = {
        border = "none",
      },
    },
    ghost_text = {
      enabled = true,
    },
    menu = {
      border = "none",
      draw = {
        columns = {
          { "kind_icon" },
          { "label", "label_description", gap = 1 },
          { "source_name" },
        },
      },
    },
  },
  signature = {
    enabled = true,
    window = {
      border = "none",
      treesitter_highlighting = true,
    },
  },
  sources = {
    default = { "lsp", "path", "snippets", "buffer" },
  },
  fuzzy = {
    implementation = "lua",
  },
})

-- lsp
vim.lsp.config('clangd', {
	cmd = {'clangd'},
	filetypes = {'c', 'cpp'},
	root_markers = {'.clangd', '.git'}
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
vim.lsp.config('rust-analyzer', {
	cmd = {'rust-analyzer'},
	filetypes = {'rust'},
	root_markers = {'Cargo.toml', 'Cargo.lock', '.git'}
})
vim.lsp.config('zls', {
	cmd = {'zls'},
	filetypes = {'zig'},
	root_markers = {'build.zig', '.git'}
})
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client then
      client.server_capabilities.semanticTokensProvider = nil
    end
  end,
})
vim.lsp.enable({'clangd', 'lua_ls', 'pyright', 'ols', 'rust-analyzer', 'zls'})
vim.opt.complete = {'o', '.', 'w', 'b', 'u', 't'}
vim.opt.completeopt = {'menuone', 'noinsert', 'noselect'}
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

-- colorscheme
vim.opt.termguicolors = true
vim.opt.background = 'dark'
vim.cmd('syntax enable')
vim.g.gruvbox_italic = 1
vim.g.gruvbox_bold = 1
vim.g.gruvbox_italicize_comments = 1
vim.g.gruvbox_italicize_strings = 1
vim.cmd('colorscheme gruvbox')

local function apply_font_style_highlights()
  local styles = {
    Comment = { italic = true },
    String = { italic = true },
    Character = { italic = true },
    Function = { bold = true },
    Identifier = { bold = false },
    Keyword = { bold = true },
    Statement = { bold = true },
    Type = { bold = true },
    Constant = { bold = true },
  }

  for group, style in pairs(styles) do
    local ok, current = pcall(vim.api.nvim_get_hl, 0, { name = group, link = false })
    if ok and not vim.tbl_isempty(current) then
      current.link = nil
      vim.api.nvim_set_hl(0, group, vim.tbl_extend("force", current, style))
    end
  end
end

apply_font_style_highlights()
vim.api.nvim_create_autocmd('ColorScheme', {
  callback = apply_font_style_highlights,
})

-- airline config
vim.g.airline_powerline_fonts = 1
vim.g.airline_section_warning = ''
vim.g.airline_section_error = ''
vim.g.airline_section_z = '%l:%c'
vim.cmd('let g:airline#extensions#tabline#enabled = 1')
vim.cmd('hi StatusLine cterm=NONE gui=NONE')
vim.cmd('hi TabLine cterm=NONE gui=NONE')
vim.cmd('hi WinBar cterm=NONE gui=NONE')

-- noh when cursor moved
vim.api.nvim_create_autocmd("CursorMoved", {
  pattern = "*",
  callback = function()
    if vim.v.hlsearch == 1 and vim.fn.mode() == "n" then
      vim.schedule(function()
        vim.cmd("noh")
      end)
    end
  end,
})

-- keymaps
local map = vim.keymap.set
map('n', 'K', function()
  vim.lsp.buf.hover({ border = 'rounded' })
end, { desc = 'LSP hover' })
map('i', '<CR>', function()
	local ok, cmp = pcall(require, "blink.cmp")
	if ok and cmp.is_menu_visible() then
		cmp.accept()
		return ""
	end
	return "<CR>"
end, { expr = true })

vim.cmd([[
  let g:EasyMotion_do_mapping = 0
  nmap <leader>mf <Plug>(easymotion-overwin-f)
  nmap <leader>ms <Plug>(easymotion-overwin-f2)
  nmap <leader>ml <Plug>(easymotion-overwin-line)
  nmap <leader>mw <Plug>(easymotion-overwin-w)
]])

map('n', 'gD', vim.lsp.buf.declaration, {})
map('n', 'gd', vim.lsp.buf.definition, {})
map('n', 'gr', vim.lsp.buf.references, {})

map('n', '<leader>lf', vim.lsp.buf.format, {})
map('n', '<leader>lr', vim.lsp.buf.rename, {})

map("n", "<leader>ff", ":Telescope find_files<CR>")
map("n", "<leader>fs", ":Telescope live_grep<CR>")
map("n", "<leader>fb", ":Telescope buffers<CR>")

map('n', '<space>b', ':b ')
map('n', '<space>r', ':!')
map('n', '<space>s', '<cmd>b#<CR>')
map('n', '<space>e', '<cmd>NvimTreeToggle<CR>')
map('n', '<space>w', '<cmd>w<CR>')
map('n', '<space>q', '<cmd>q<CR>')
map('n', '<C-s>', '<cmd>w<CR>')
map('i', '<C-s>', '<ESC>:w<CR>')
map('i', 'jj', '<ESC>')
map('i', 'kk', '<Right>')
map('n', '<C-j>', '<C-w>j')
map('n', '<C-k>', '<C-w>k')
map('n', '<C-h>', '<C-w>h')
map('n', '<C-l>', '<C-w>l')
