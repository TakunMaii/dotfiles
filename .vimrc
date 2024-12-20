set nocompatible smartindent noincsearch nostartofline
set expandtab tabstop=4 softtabstop=4 shiftwidth=4
set number relativenumber
set title ruler belloff=all laststatus=1
set fileencodings=utf-8,latin-1,chinese,gbk,gb2312,gb18030 encoding=utf-8 langmenu=none
set statusline=%<%f\ %=%y\ %l/%L\ %p%%
set backspace=indent,eol,start
set completeopt=menuone,noinsert
syntax on

call plug#begin()
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'jiangmiao/auto-pairs'
call plug#end()


inoremap <expr> <cr> coc#pum#visible() ? coc#pum#confirm() : "\<cr>"
nnoremap <silent> <space> :call CocActionAsync("doHover")<cr>

nnoremap <expr> <c-d> coc#float#has_scroll() ? coc#float#scroll(1, 1) : "\<c-d>"
nnoremap <expr> <c-u> coc#float#has_scroll() ? coc#float#scroll(0, 1) : "\<c-u>"

let g:coc_user_config = {
            \   'diagnostic.level': 'error',
            \   'suggest.preview': v:false,
            \   'suggest.detailField': 'abbr',
            \   'signature.enable': v:false
            \ }

nmap <space>d <Plug>(coc-definition)
nmap <space>r <Plug>(coc-references)
nmap <space>t <Plug>(coc-type-definition)
nmap <space>i <Plug>(coc-implementation)
nmap <space>2 <Plug>(coc-rename)
nmap <space>h <Plug>(coc-diagnostic-prev)
nmap <space>l <Plug>(coc-diagnostic-next)
nmap <M-F> <Plug>(coc-format)

nnoremap <space>fs :Rg<cr>
nnoremap <space>ff :FZF<cr>

nnoremap <space>b :buffers<cr>:b<space>
nnoremap <space>e :b#<cr>
nnoremap <space>w :w<cr>
nnoremap <space>q :q<cr>
nnoremap <c-s> :w<cr>
inoremap <c-s> <esc>:w<cr>
inoremap jj <esc>
inoremap kk <right>
nnoremap <F5> :!make<cr>

