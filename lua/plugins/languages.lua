return {
    'plasticboy/vim-markdown',
    {'iamcco/markdown-preview.nvim', build = 'cd app && yarn install'},

    {'cespare/vim-toml', branch = 'main'},

    'euclidianAce/BetterLua.vim',

    'hail2u/vim-css3-syntax',
    'ap/vim-css-color',

    {'fatih/vim-go', build = ':GoUpdateBinaries'},
}
