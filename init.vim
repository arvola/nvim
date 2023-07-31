if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.local/share/nvim/site/plugged')

" Basics

Plug 'tpope/vim-surround'
Plug 'doums/darcula'
Plug 'windwp/nvim-autopairs'

" Snippets

Plug 'SirVer/ultisnips'

" Windows and popups

Plug 'voldikss/vim-floaterm'
Plug 'ptzz/lf.vim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-lua/popup.nvim'
Plug 'tversteeg/registers.nvim', { 'branch': 'main' }
Plug 'kevinhwang91/nvim-bqf'

" Help and finding

Plug 'folke/which-key.nvim'
Plug 'sudormrfbin/cheatsheet.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'ahmedkhalf/project.nvim'

" Formatting

Plug 'sbdchd/neoformat'

" LSP and completion

Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'quangnguyen30192/cmp-nvim-ultisnips'
Plug 'tami5/lspsaga.nvim'
Plug 'ray-x/lsp_signature.nvim'

" Treesitter

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/nvim-treesitter-textobjects'

" Languages

Plug 'plasticboy/vim-markdown'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install'  }

Plug 'cespare/vim-toml', { 'branch': 'main' }

Plug 'euclidianAce/BetterLua.vim'

Plug 'hail2u/vim-css3-syntax'
Plug 'ap/vim-css-color'

Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'neovim/tree-sitter-vim', {'do': 'make'}

" Git
Plug 'lewis6991/gitsigns.nvim'

" Make
Plug 'neomake/neomake'

call plug#end()



" Basics
filetype on
syntax on
set number
let mapleader = "\<space>"
colorscheme darcula
set termguicolors
set clipboard+=unnamedplus

call darcula#Hi('LineNr', ['#606366', 145], ['#0B0B0B',235])
call darcula#Hi('Normal', ['#A9B7C6', 145], ['#000000',0])

" History/Buffers
set hidden
set history=100

" Formatting
filetype indent on
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab

" Search
set incsearch
set hlsearch

" Other
set wildmenu
set lazyredraw
set showmatch

" Mapping
" Clear search results
nnoremap <leader><space> :nohlsearch<CR> 

set mousetime=1
set mouse=a
set scroll=5
noremap <ScrollWheelUp> 5<C-Y>
noremap <S-ScrollWheelUp> <C-U>
noremap <ScrollWheelDown> 5<C-E>
noremap <S-ScrollWheelDown> <C-D>
noremap <2-ScrollWheelUp> <Nop>
noremap <3-ScrollWheelUp> <Nop>
noremap <4-ScrollWheelUp> <Nop>
noremap <4-ScrollWheelUp> <Nop>
noremap <5-ScrollWheelUp> <Nop>
noremap <2-ScrollWheelDown> <Nop>
noremap <3-ScrollWheelDown> <Nop>
noremap <4-ScrollWheelDown> <Nop>
noremap <5-ScrollWheelDown> <Nop>


" lf file manager
let g:floaterm_opener = 'edit'
let g:lf_map_keys = 0
let g:lf_width = 0.9
let g:lf_height = 0.9
let g:lf_open_new_tab = 1
map <leader>f :LfCurrentFile<CR>
let g:lf_command_override = 'lf -command "set hidden" -config ~/.config/lf/lfrcvim'

" Tabs and buffers
nnoremap <silent> <leader><right> :tabn<CR>
nnoremap <silent> <leader><left> :tabp<CR>
nnoremap <silent> <leader>b :Buffers<CR>
nnoremap <silent> <C-Up> :bp<CR> 
nnoremap <silent> <C-Down> :bn<CR> 
nnoremap <silent> <leader>c :cclose<CR>

" Formatting

nnoremap <leader>l :Neoformat<CR>

let g:neoformat_enabled_css = [ 'prettierd' ]
let g:neoformat_enabled_html = [ 'prettierd' ]
let g:neoformat_enabled_javascript = [ 'prettierd' ]
let g:neoformat_enabled_json = [ 'prettierd' ]
let g:neoformat_enabled_scss = [ 'prettierd' ]
let g:neoformat_enabled_typescript = [ 'prettierd' ]

nnoremap <leader>? :Cheatsheet<CR>

" Markdown

" disable header folding
let g:vim_markdown_folding_disabled = 1

" do not use conceal feature, the implementation is not so good
let g:vim_markdown_conceal = 0

" disable math tex conceal feature
let g:tex_conceal = ""
let g:vim_markdown_math = 1

" support front matter of various format
let g:vim_markdown_frontmatter = 1  " for YAML format

" Use ripgrep for searching ⚡️
" Options include:
" --vimgrep -> Needed to parse the rg response properly for ack.vim
" --type-not sql -> Avoid huge sql file dumps as it slows down the search
" --smart-case -> Search case insensitive if all lowercase pattern, Search case sensitively otherwise
let g:rg_path = 'rg --vimgrep --type-not sql --smart-case'

function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction

command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)

" Maps <leader>/ so we're ready to type the search keyword
nnoremap <Leader>/ :RG<CR>
nnoremap <Leader>g :Files<CR>
" }}}

" Navigate quickfix list with ease
nnoremap <silent> [q :cprevious<CR>
nnoremap <silent> ]q :cnext<CR>

" Markdown preview
let g:mkdp_browser = 'chromium'

let g:UltiSnipsExpandTrigger="<tab>"

" nvim-cmp completion
set completeopt=menu,menuone,noselect

lua require('cmpconf')
lua require('trees')

" project.nvim
lua << EOF
  require("project_nvim").setup {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  }
EOF


" Cheatsheets
lua << EOF
require("cheatsheet").setup({
    bundled_cheatsheets = {
        enabled = {"default", "unicode", "regex"},
        disabled = {},
    },

    -- For plugin specific cheatsheets
    -- bundled_plugin_cheatsheets = {
    --     enabled = {},
    --     disabled = {},
    -- }
    bundled_plugin_cheatsheets = true,

    -- For bundled plugin cheatsheets, do not show a sheet if you
    -- don't have the plugin installed (searches runtimepath for
    -- same directory name)
    include_only_installed_plugins = true,
})
EOF

lua << EOF
  require("which-key").setup {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  }
EOF

lua << EOF
    require('gitsigns').setup()
    require("bqf").setup()
    require('nvim-autopairs').setup {
        check_ts = true
    }
EOF


" Make
let g:neomake_open_list = 2
nnoremap <Leader>m :NeomakeProject tsc<CR>

autocmd BufRead,BufNewFile */wood/layouts/*.html setlocal ft=gohtmltmpl
