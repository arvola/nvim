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
		dependencies = { "nvim-lua/plenary.nvim", {
			"arvola/telescope-insert-path.nvim",
            opts = {
                dot_prefix = true
            }
		} },
		config = function(_, opts)
			local path_actions = require("telescope_insert_path")
			local telescope = require("telescope")
			telescope.setup({
				defaults = {
					mappings = {
						i = {
							["<Space>"] = path_actions.insert_reltobufpath_i_normal,
						},
					},
				},
			})
		end,
	},
	{ "junegunn/fzf", build = "./install --bin" },
	"junegunn/fzf.vim",
    {
        'nvim-telescope/telescope-media-files.nvim',
        config = function()
            require('telescope').load_extension('media_files')
        end

    }
}
