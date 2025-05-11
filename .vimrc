" basic vim settings
set nocompatible smartindent nostartofline
set expandtab tabstop=4 softtabstop=4 shiftwidth=4
set number relativenumber
set termguicolors
set title ruler belloff=all laststatus=1
set fileencodings=utf-8,latin-1,chinese,gbk,gb2312,gb18030 encoding=utf-8 langmenu=none
set statusline=%<%f\ %=%y\ %l/%L\ %p%%
set backspace=indent,eol,start
set completeopt=menuone,noinsert
syntax on
let &titleold=getcwd() " Save the old title

" vim-plug settings
call plug#begin()
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'github/copilot.vim'
Plug 'morhetz/gruvbox'
call plug#end()

" gruvbox dark mode
colorscheme gruvbox
set background=dark

" copilot settings
let g:copilot_no_tab_map = v:true
inoremap <silent><expr> <c-y> exists('b:_copilot.suggestions') ? copilot#Accept("\<CR>") : "\<c-y>"

" fzf settings
nnoremap <space>fs :Rg<cr>
nnoremap <space>ff :FZF<cr>

" useful mappings
nnoremap <space>b :buffers<cr>:b<space>
nnoremap <space>s :b#<cr>
nnoremap <space>e :Vexplore<cr>
nnoremap <space>w :w<cr>
nnoremap <space>q :q<cr>
nnoremap <c-s> :w<cr>
inoremap <c-s> <esc>:w<cr>
inoremap jj <esc>
nnoremap <F5> :!make<cr>
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l
