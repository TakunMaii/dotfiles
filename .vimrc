" basic vim settings
set nocompatible smartindent nostartofline
set expandtab tabstop=4 softtabstop=4 shiftwidth=4
set number
set termguicolors
set title ruler belloff=all laststatus=2
set fileencodings=utf-8,latin-1,chinese,gbk,gb2312,gb18030 encoding=utf-8 langmenu=none
set statusline=%<%f\ %=%y\ %l/%L\ %p%%
set backspace=indent,eol,start
set completeopt=menuone,noinsert
set nowrap
syntax on
filetype plugin indent on
let &titleold=getcwd() " Save the old title

" set leader
let mapleader=" "
let maplocalleader=" "

" vim-plug settings
call plug#begin()
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'morhetz/gruvbox'
Plug 'mg979/vim-visual-multi', {'branch': 'master'}
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
Plug 'preservim/nerdtree'
Plug 'tpope/vim-commentary'
Plug 'github/copilot.vim'
call plug#end()

" vimtex config
let g:Tex_IgnoredWarnings =
        \'Underfull'."\n".
        \'Overfull'."\n".
        \'specifier changed to'."\n".
        \'You have requested'."\n".
        \'Missing number, treated as zero.'."\n".
        \'There were undefined references'."\n".
        \'Citation %.%# undefined'."\n".
        \"LaTeX hooks Warning"
let g:Tex_IgnoreLevel = 8
let g:Tex_GotoError = 0
let g:vimtex_quickfix_open_on_warning=0
let g:vimtex_view_general_viewer = 'SumatraPDF'

" gruvbox dark mode
colorscheme gruvbox
set background=dark

" copilot settings
let g:copilot_no_tab_map = v:true
inoremap <silent><expr> <c-y> exists('b:_copilot.suggestions') ? copilot#Accept("\<CR>") : "\<c-y>"

" fzf settings
nnoremap <space>fs :Rg<cr>
nnoremap <space>ff :FZF<cr>
nnoremap <space>fb :Buffers<cr>

" useful mappings
nnoremap <space>b :buffers<cr>:b<space>
nnoremap <space>s :b#<cr>
nnoremap <space>e :NERDTreeToggle<cr>
nnoremap <space>w :w<cr>
nnoremap <space>q :q<cr>
nnoremap <space>t :term<cr>
nnoremap <c-s> :w<cr>
inoremap <c-s> <esc>:w<cr>
inoremap jj <esc>
inoremap kk <right>
nnoremap <F5> :!make<space>
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l

" c header command
function! InsertHeaderGuard()
    let l:fname = expand('%:t:r')
    let l:guard = toupper(l:fname)
    let l:guard = substitute(l:guard, '[^A-Z0-9]', '_', 'g')
    let l:guard .= '_H'
    let l:lines = [
                \ '#ifndef ' . l:guard,
                \ '#define ' . l:guard,
                \ '',
                \ '#endif /* ' . l:guard . ' */'
                \ ]

    call append(0, l:lines)
    execute 'normal! gg3j'
endfunction

command! Cheader call InsertHeaderGuard()
