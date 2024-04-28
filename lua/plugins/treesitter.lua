return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function(_, opts)
			require("nvim-treesitter.configs").setup(opts)
		end,
		opts = {

			-- One of "all", "maintained" (parsers with maintainers), or a list of languages
			ensure_installed = {
				"lua",
				"typescript",
				"javascript",
				"bash",
				"css",
				"vim",
				"yaml",
			},
			sync_install = false,
			auto_install = true,
			ignore_install = {},

			highlight = {
				-- `false` will disable the whole extension
				enable = true,

				-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
				-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
				-- Using this option may slow down your editor, and you may see some duplicate highlights.
				-- Instead of true it can also be a list of languages
				additional_vim_regex_highlighting = false,
			},
			textobjects = {
				select = {
					enable = true,

					-- Automatically jump forward to textobj, similar to targets.vim
					lookahead = true,

					keymaps = {
						-- You can use the capture groups defined in textobjects.scm
						["af"] = "@function.outer",
						["if"] = "@function.inner",
						["ac"] = "@class.outer",
						["ic"] = "@class.inner",
					},
				},
			},
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<leader>w",
					node_incremental = "w",
					scope_incremental = "grc",
					node_decremental = "grm",
				},
			},
		},
	},
	{ "nvim-treesitter/nvim-treesitter-textobjects" },
}
