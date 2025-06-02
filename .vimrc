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
set nowrap
syntax on
let &titleold=getcwd() " Save the old title

" vim-plug settings
call plug#begin()
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'github/copilot.vim'
Plug 'morhetz/gruvbox'
Plug 'mg979/vim-visual-multi', {'branch': 'master'}
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
Plug 'preservim/nerdtree'
Plug 'puremourning/vimspector'
call plug#end()

" coc settings
inoremap <expr> <cr> coc#pum#visible() ? coc#pum#confirm() : "\<cr>"
nnoremap <silent> <space> :call CocActionAsync("doHover")<cr>

let g:coc_snippet_next = '<tab>'
let g:coc_snippet_prev = '<s-tab>'

inoremap <silent><expr> <TAB> coc#pum#visible() ? coc#pum#next(1): "\<Tab>"
inoremap <silent><expr> <s-tab> coc#pum#visible() ? coc#pum#prev(0) : "\<S-Tab>"

nnoremap <expr> <c-d> coc#float#has_scroll() ? coc#float#scroll(1, 1) : "\<c-d>"
nnoremap <expr> <c-u> coc#float#has_scroll() ? coc#float#scroll(0, 1) : "\<c-u>"

nmap gd <Plug>(coc-definition)
nmap <space>r <Plug>(coc-references)
nmap <space>t <Plug>(coc-type-definition)
nmap gi <Plug>(coc-implementation)
nmap <space>2 <Plug>(coc-rename)
nmap <space>dj <Plug>(coc-diagnostic-prev)
nmap <space>dk <Plug>(coc-diagnostic-next)
nmap <space>fd <Plug>(coc-format)

" gruvbox dark mode
colorscheme gruvbox
set background=dark

" copilot settings
let g:copilot_no_tab_map = v:true
inoremap <silent><expr> <c-y> exists('b:_copilot.suggestions') ? copilot#Accept("\<CR>") : "\<c-y>"

" fzf settings
nnoremap <space>fs :Rg<cr>
nnoremap <space>ff :FZF<cr>

" vimspector settings
nnoremap <space>dl :call vimspector#Launch()<cr>
nnoremap <space>dc :call vimspector#Continue()<cr>
nnoremap <space>do :call vimspector#StepOver()<cr>
nnoremap <space>di :call vimspector#StepInto()<cr>
nnoremap <space>do :call vimspector#StepOut()<cr>
nnoremap <space>dr :call vimspector#Restart()<cr>
nnoremap <space>db :call vimspector#ToggleBreakpoint()<cr>

" useful mappings
nnoremap <space>b :buffers<cr>:b<space>
nnoremap <space>s :b#<cr>
nnoremap <space>e :NERDTreeToggle<cr>
nnoremap <space>w :w<cr>
nnoremap <space>q :q<cr>
nnoremap <c-s> :w<cr>
inoremap <c-s> <esc>:w<cr>
inoremap jj <esc>
inoremap kk <right>
nnoremap <F5> :!make<cr>
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <space>m `
