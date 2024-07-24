let mapleader = " "
let maplocalleader = "\\"

set autoread
au FocusGained * :checktime

let s:uname = system("uname")

call plug#begin('~/.local/share/nvim/plugged')

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'gruvbox-community/gruvbox'
let g:airline#extensions#whitespace#max_lines = 20000
let g:airline#extensions#tagbar#enabled = 0
Plug 'bluz71/vim-nightfly-colors', { 'as': 'nightfly' }
Plug 'luochen1990/rainbow'
let g:rainbow_active = 1

Plug 'editorconfig/editorconfig-vim'
let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']

Plug 'h-youhei/vim-ibus'
let g:ibus#layout = 'xkb:us::eng'
let g:ibus#engine = 'libpinyin'

Plug 'nathangrigg/vim-beancount'
Plug 'sheerun/vim-polyglot'
Plug 'xywei/vim-dealii-prm', {'for': 'prm'}
Plug 'david-a-wheeler/vim-metamath', {'rtp': 'vim', 'for': 'metamath'}
Plug 'IngoHeimbach/vim-plugin-AnsiEsc'
Plug 'cstrahan/vim-capnp'

Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown', {'for': 'markdown'}
Plug 'iamcco/markdown-preview.nvim', {'do': 'cd app && yarn install', 'for': 'markdown'}
let g:vim_markdown_folding_disabled = 1

Plug 'mattn/emmet-vim'

Plug 'ryanoasis/vim-devicons'
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'majutsushi/tagbar'
let g:tagbar_file_size_limit = 10000

Plug 'junegunn/vim-easy-align'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'Raimondi/delimitMate'
Plug 'sbdchd/neoformat'

Plug 'mbbill/undotree'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'shumphrey/fugitive-gitlab.vim'

Plug 'neovim/nvim-lsp'
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'ms-jpq/coq_nvim', {'branch': 'coq'}
Plug 'ms-jpq/coq.artifacts', {'branch': 'artifacts'}
Plug 'ms-jpq/coq.thirdparty', {'branch': '3p'}
Plug 'j-hui/fidget.nvim', {'tag': 'legacy'}
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'TimUntersberger/neogit'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'folke/trouble.nvim'

Plug 'nvim-lua/plenary.nvim'

Plug 'junegunn/fzf', { 'dir': '~/.local/share/fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'stsewd/fzf-checkout.vim'

Plug 'edkolev/tmuxline.vim'
Plug 'christoomey/vim-tmux-navigator'

call plug#end()

let g:tagbar_width = 50
let g:tagbar_type_tex = {
      \ 'ctagstype' : 'latex',
      \ 'kinds'     : [
      \ 's:sections',
      \ 'g:graphics:1',
      \ 'l:labels:1',
      \ 'r:refs:1',
      \ 'p:pagerefs:1'
      \ ],
      \ 'sort'    : 0
      \ }

let g:fzf_layout = { 'window': { 'width': 0.8, 'height': 0.8 } }
let $FZF_DEFAULT_OPTS='--reverse'

let g:fzf_action = {
  \ 'ctrl-s': 'split',
  \ 'ctrl-v': 'vsplit'
  \ }
nnoremap <C-P> :Files<cr>
augroup fzf
  autocmd!
  autocmd! FileType fzf
  autocmd  FileType fzf set laststatus=0 noshowmode noruler
    \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler
augroup END

nnoremap <silent> <leader>b :Buffers<CR>
nnoremap <silent> <leader>w :Windows<CR>
nnoremap <silent> <leader>t :Tags<CR>
nnoremap <silent> <leader>r :History<CR>
nnoremap <silent> <leader>/ :Rg<CR>

nnoremap <silent> <leader>s :call SearchWordWithRg()<CR>
vnoremap <silent> <leader>s :call SearchVisualSelectionWithRg()<CR>

function! SearchWordWithRg()
    execute 'Rg' expand('<cword>')
endfunction

function! SearchVisualSelectionWithRg() range
    let old_reg = getreg('"')
    let old_regtype = getregtype('"')
    let old_clipboard = &clipboard
    set clipboard&
    normal! ""gvy
    let selection = getreg('"')
    call setreg('"', old_reg, old_regtype)
    let &clipboard = old_clipboard
    execute 'Rg' selection
endfunction

imap <c-x><c-l> <plug>(fzf-complete-line)

let g:fugitive_gitlab_domains = ['https://git.wxyzg.com', 'https://gitlab.tiker.net']

nmap <leader>gj :diffget //3<CR>
nmap <leader>gf :diffget //2<CR>

nmap <leader>gs :G<CR>
nmap <leader>gc :Gcommit<CR>
nmap <leader>ga :Gwrite<CR>
nmap <leader>gl :Glog<CR>
nmap <leader>gd :Gdiff<CR>

if !exists('b:noNeoformat')
  nnoremap <buffer><Leader>= :<C-u>Neoformat<CR>
  vnoremap <buffer><Leader>= :Neoformat<CR>
endif

let g:neoformat_basic_format_align = 1
let g:neoformat_basic_format_retab = 1
let g:neoformat_basic_format_trim = 1

autocmd FileType apache setlocal commentstring=#\ %s

let delimitMate_autoclose = 0

lua <<EOF
require("mason").setup()
local mason_lspconfig = require("mason-lspconfig")
local lsp_config = require("lspconfig")
local capabilities = vim.lsp.protocol.make_client_capabilities()
vim.g.coq_settings = {
  auto_start = true,
  keymap = {
    recommended = true,
    pre_select = true,
    bigger_preview = '<c-l>',
    manual_complete = '<c-q>',
  },
}
local coq = require("coq")

require"fidget".setup{}

mason_lspconfig.setup_handlers({
    function (server_name) -- default handler
        require("lspconfig")[server_name].setup({
            coq.lsp_ensure_capabilities({ on_attach = general_on_attach, })
        })
    end,
})

vim.opt.list = true
vim.opt.listchars:append "space:⋅"
vim.opt.listchars:append "eol:↴"
require("ibl").setup()
local neogit = require("neogit")
neogit.setup {}
EOF

nnoremap <silent> <leader>lc    <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> <leader>li    <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> <leader>ld    <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> <c-]>         <cmd>lua vim.lsp.buf.definition()<CR>

nnoremap <silent> <leader>lh    <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> <leader>ls    <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> <leader>lt    <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> <leader>lr    <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> <leader>lF    <cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent> <leader>lW    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>

nnoremap <silent> <leader>dh    <cmd>lua vim.diagnostic.open_float()<CR>
nnoremap <silent> <leader>dD    <cmd>lua vim.diagnostic.setloclist()<CR>
nnoremap <silent> <leader>dk    <cmd>lua vim.diagnostic.goto_prev()<CR>
nnoremap <silent> <leader>dj    <cmd>lua vim.diagnostic.goto_next()<CR>

set omnifunc=syntaxcomplete#Complete
autocmd Filetype go setlocal omnifunc=v:lua.vim.lsp.omnifunc
autocmd Filetype python setlocal omnifunc=v:lua.vim.lsp.omnifunc

set shortmess+=c

lua <<EOF
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    underline = false,
    virtual_text = true,
    signs = true,
    update_in_insert = false,
  }
)
EOF

call sign_define("DiagnosticSignError", {"text" : "✘", "texthl" : "DiagnosticSignError"})
call sign_define("DiagnosticSignWarn", {"text" : "▲", "texthl" : "DiagnosticSignWarning"})
call sign_define("DiagnosticSignInfo", {"text" : "⚑", "texthl" : "DiagnosticSignInformation"})
call sign_define("DiagnosticSignHint", {"text" : "»", "texthl" : "DiagnosticSignHint"})

" call sign_define("DiagnosticSignError", {"text" : "", "texthl" : "DiagnosticSignError"})
" call sign_define("DiagnosticSignWarn", {"text" : "", "texthl" : "DiagnosticSignWarning"})
" call sign_define("DiagnosticSignInfo", {"text" : "", "texthl" : "DiagnosticSignInformation"})
" call sign_define("DiagnosticSignHint", {"text" : "", "texthl" : "DiagnosticSignHint"})

" call sign_define("DiagnosticSignError", {"text" : "🔥", "texthl" : "DiagnosticSignError"})
" call sign_define("DiagnosticSignWarning", {"text" : "👻", "texthl" : "DiagnosticSignWarning"})
" call sign_define("DiagnosticSignInformation", {"text" : "👽", "texthl" : "DiagnosticSignInformation"})
" call sign_define("DiagnosticSignHint", {"text" : "🦄", "texthl" : "DiagnosticSignHint"})

lua <<EOF
require'nvim-web-devicons'.setup { 
}
require("trouble").setup {
  signs = {
    -- icons / text used for a diagnostic
    Error = "✘",
    Warn = "▲",
    Hint = "⚑",
    Info = "»",
  },
  use_diagnostic_signs = false -- enabling this will use the signs defined in your lsp client
}
EOF

nnoremap <leader>xx <cmd>Trouble diagnostics toggle<cr>
nnoremap <leader>xb <cmd>Trouble diagnostics toggle filter.buf=0<cr>
nnoremap <leader>xs <cmd>Trouble symbols toggle focus=false<cr>
nnoremap <leader>xd <cmd>Trouble lsp toggle focus=false win.position=right<cr>
nnoremap <leader>xq <cmd>Trouble qflist toggle<cr>
nnoremap <leader>xl <cmd>Trouble loclist toggle<cr>
nnoremap gR <cmd>Trouble lsp toggle focus=false win.position=right<cr>

" Emmet shortcuts
let g:user_emmet_mode='n'  " only enable normal mode functions
let g:user_emmet_leader_key=','

nnoremap <leader><space> za

nmap <Leader>t :TagbarToggle<cr>
nmap tb :TagbarToggle<cr>

xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)
xmap <Leader>a <Plug>(EasyAlign)
nmap <Leader>a <Plug>(EasyAlign)

map <C-n> :NERDTreeToggle<CR>
nmap <Leader>f :NERDTreeToggle<cr>

nnoremap <leader>h :wincmd h<CR>
nnoremap <leader>j :wincmd j<CR>
nnoremap <leader>k :wincmd k<CR>
nnoremap <leader>l :wincmd l<CR>

nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap J mzJ`z

inoremap , ,<c-g>u
inoremap . .<c-g>u
inoremap ! !<c-g>u
inoremap ? ?<c-g>u
inoremap ; ;<c-g>u

nnoremap <expr> k (v:count > 5 ? "m'" . v:count : "") . 'k'
nnoremap <expr> j (v:count > 5 ? "m'" . v:count : "") . 'j'

vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv
inoremap <C-j> <ESC>:m .+1<CR>==i
inoremap <C-k> <ESC>:m .-2<CR>==i
nnoremap <leader>j :m .+1<CR>==
nnoremap <leader>k :m .-2<CR>==

hi CursorLine cterm=NONE ctermbg=darkred ctermfg=white
hi CursorColumn cterm=NONE ctermbg=darkred ctermfg=white
function FindCursor()
  if !exists("s:highlightcursor")
    let s:highlightcursor=1
    set cursorline
    set cursorcolumn
  else
    unlet s:highlightcursor
    set nocursorline
    set nocursorcolumn
  endif
endfunction
nnoremap <Leader>K :call FindCursor()<CR>

let g:neoformat_enabled_python = ['black', 'docformatter']
let g:neoformat_run_all_formatters = 1

let g:neoformat_enabled_c = ['clangformat']
let g:neoformat_enabled_cpp = ['clangformat']

function ShowSpaces(...)
  let @/='\v(\s+$)|( +\ze\t)'
  let oldhlsearch=&hlsearch
  if !a:0
    let &hlsearch=!&hlsearch
  else
    let &hlsearch=a:1
  end
  return oldhlsearch
endfunction

function TrimSpaces() range
  let oldhlsearch=ShowSpaces(1)
  execute a:firstline.",".a:lastline."substitute ///gec"
  let &hlsearch=oldhlsearch
endfunction

command -bar -nargs=? ShowSpaces call ShowSpaces(<args>)
command -bar -nargs=0 -range=% TrimSpaces <line1>,<line2>call TrimSpaces()
command -bar -nargs=0 -range=% DeleteTrailingWhitespace <line1>,<line2>call TrimSpaces()

set relativenumber
set number

set noswapfile

set autoread

set nobackup

command! MakeTags !ctags -R .

nnoremap <leader>u :UndotreeToggle<cr>

set undodir=~/.cache/nvim/undodir/
set undofile

let g:airline_powerline_fonts = 1
" let g:airline_theme='gruvbox'
let g:airline_theme='nightfly'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tmuxline#enabled = 1
let g:airline#extensions#tmuxline#snapshot_file = "~/.tmux-statusline-colors.conf"
let g:airline#extensions#nvimlsp#enabled = 1

noremap <leader>1 1gt
noremap <leader>2 2gt
noremap <leader>3 3gt
noremap <leader>4 4gt
noremap <leader>5 5gt
noremap <leader>6 6gt
noremap <leader>7 7gt
noremap <leader>8 8gt
noremap <leader>9 9gt

au TabLeave * let g:lasttab = tabpagenr()
noremap <leader><Tab> :exe "tabn ".g:lasttab<cr>

if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif
set termguicolors
set background=dark

" let g:gruvbox_italic=1
" let g:gruvbox_contrast_light='medium'
" let g:gruvbox_contrast_dark='hard'
" colorscheme gruvbox
let g:lightline = { 'colorscheme': 'nightfly' }
let g:nightflyCursorColor = v:true
let g:nightflyNormalFloat = v:true
let g:nightflyUnderlineMatchParen = v:true
let g:nightflyVirtualTextColor = v:true
colorscheme nightfly

autocmd BufNewFile,BufRead *.txx set filetype=cpp

set mouse=a

syntax on

set spell
set spelllang+=cjk

set formatoptions+=mM

set smartindent

set nowrap

set smartcase

set incsearch

filetype plugin indent on

set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab

let g:tmux_navigator_no_mappings = 1

if (executable('pbcopy') || executable('xclip') || executable('xsel')) && has('clipboard')
  set clipboard^=unnamed,unnamedplus
endif

if s:uname == "Darwin\n"
  let g:python_host_prog='/usr/local/bin/python2'
  let g:python3_host_prog='/usr/local/bin/python3'
endif

if s:uname == "Linux\n"
  let g:python_host_prog='/usr/bin/python2'
  let g:python3_host_prog='/usr/bin/python3'
endif

set wildmenu

set foldmethod=marker

set notimeout
set nottimeout

hi Search cterm=None ctermbg=blue ctermfg=white

set scrolloff=4
set nolazyredraw

:let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1

set gcr=n:blinkon0

let g:netrw_browse_split=2
let g:netrw_banner=0
let g:netrw_winsize=25

"prioritize chinese encoding
set fencs=utf-8,gb2312,gb18030,gbk,ucs-bom,cp936,latin1
