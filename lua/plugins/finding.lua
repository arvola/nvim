return {
	{
		"sudormrfbin/cheatsheet.nvim",
		opts = {
			bundled_cheatsheets = {
				enabled = { "default", "unicode", "regex" },
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
		},
	},
	{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
	},
	{ "junegunn/fzf", build = "./install --bin" },
	"junegunn/fzf.vim",
}
