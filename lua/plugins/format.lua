return {
	"mhartington/formatter.nvim",
	opts = function(_, opts)
		local prettierd = require("formatter.defaults.prettierd")
		opts.filetype = {
			css = { prettierd },
			html = { prettierd },
			javascript = { prettierd },
			json = { prettierd },
			scss = { prettierd },
			typescript = { prettierd },
			lua = {
				require("formatter.filetypes.lua").stylua,
			},
		}
	end,
}
