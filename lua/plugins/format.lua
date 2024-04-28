return {
	"mhartington/formatter.nvim",
	opts = function(_, opts)
		local prettierd = require("formatter.defaults.prettierd")
        local prettier = require("formatter.defaults.prettier")
        opts.logging = true
        opts.log_level = 2
		opts.filetype = {
			css = { prettierd },
			html = { prettierd },
			javascript = { prettierd },
			json = { prettierd },
            jsonc = { prettierd },
			scss = { prettierd },
			typescript = { prettierd },
            gohtmltmpl = { prettier },
			lua = {
				require("formatter.filetypes.lua").stylua,
			},
		}
	end,
}
