return {
	{
		"doums/darcula",
		lazy = false, -- make sure we load this during startup if it is your main colorscheme
		priority = 1000, -- make sure to load this before all the other start plugins
		config = function()
			-- load the colorscheme here
			vim.cmd([[colorscheme darcula]])

			vim.fn["darcula#Hi"]("LineNr", { "#606366", 145 }, { "#0B0B0B", 235 })
			vim.fn["darcula#Hi"]("Normal", { "#A9B7C6", 145 }, { "#000000", 0 })
		end,
	},
}
