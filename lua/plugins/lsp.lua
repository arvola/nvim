local function lsp_keys(bufnr)
	local function map(key, cmd, des)
		vim.keymap.set("n", key, cmd, { desc = des, buffer = bufnr })
	end
	local cmp = require("cmp")

	local leaders = {
		{ "d", "<cmd>Lspsaga goto_definition<cr>", "Definition" },
		{ "D", "<cmd>Lspsaga goto_type_definition<cr>", "Type Def" },
		{ "i", "<cmd>Lspsaga finder imp<cr>", "Implementations" },
		{ "a", "<cmd>Lspsaga code_action<cr>", "Code Actions" },
		{ "r", "<cmd>Lspsaga finder ref<cr>", "References" },
		{ "R", "<cmd>Lspsaga rename<cr>", "Rename" },
	}
	for _, k in ipairs(leaders) do
		map("<leader>" .. k[1], k[2], k[3])
	end

	local keys = {
		{ "<C-q>", "<cmd>Lspsaga hover_doc<cr>", "Hover Doc" },
		{ "[d", "<cmd>Lspsaga diagnostic_jump_prev<cr>", "Diag Prev" },
		{ "]d", "<cmd>Lspsaga diagnostic_jump_next<cr>", "Diag Next" },
	}

	for _, k in ipairs(keys) do
		map(k[1], k[2], k[3])
	end
end

return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"folke/which-key.nvim",
			"b0o/schemastore.nvim",
		},
		opts = {
			setup = {
				jsonls = function(server, server_opts)
					server_opts.settings = {
						json = {
							schemas = require("schemastore").json.schemas(),
							validate = { enable = true },
						},
					}
					require("lspconfig").jsonls.setup(server_opts)
				end,
			},
			servers = {
				cssls = {},
				vtsls = {},
                jsonls = {},
				html = {},
				lua_ls = {
					settings = {
						Lua = {
							runtime = {
								-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
								version = "LuaJIT",
							},
							diagnostics = {
								-- Get the language server to recognize the `vim` global
								globals = { "vim" },
							},
							workspace = {
								-- Make the server aware of Neovim runtime files
								library = vim.api.nvim_get_runtime_file("", true),
								checkThirdParty = false,
							},
							-- Do not send telemetry data containing a randomized but unique identifier
							telemetry = {
								enable = false,
							},
						},
					},
				},
			},
		},
		config = function(_, opts)
			local servers = opts.servers
			local wk = require("which-key")

			local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
			local capabilities = vim.tbl_deep_extend(
				"force",
				{},
				vim.lsp.protocol.make_client_capabilities(),
				has_cmp and cmp_nvim_lsp.default_capabilities() or {},
				opts.capabilities or {}
			)

			local function setup(server)
				local server_opts = vim.tbl_deep_extend("force", {
					capabilities = vim.deepcopy(capabilities),
					on_attach = function(client, bufnr)
						lsp_keys(bufnr)
					end,
				}, servers[server] or {})

				if opts.setup[server] then
					if opts.setup[server](server, server_opts) then
						return
					end
				elseif opts.setup["*"] then
					if opts.setup["*"](server, server_opts) then
						return
					end
				end
				require("lspconfig")[server].setup(server_opts)
			end

			for server, server_opts in pairs(servers) do
				if server_opts then
					server_opts = server_opts == true and {} or server_opts
					setup(server)
				end
			end
		end,
	},

	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"quangnguyen30192/cmp-nvim-ultisnips",
		},
		opts = function(_, opts)
			local cmp = require("cmp")
			opts.snippet = {
				expand = function(args)
					vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
				end,
			}
			opts.mapping = {
				["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
				["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
				["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
				["<C-y>"] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
				["<C-e>"] = cmp.mapping({
					i = cmp.mapping.abort(),
					c = cmp.mapping.close(),
				}),

				["<Down>"] = cmp.mapping(
					cmp.mapping.select_next_item({
						behavior = cmp.SelectBehavior.Select,
					}),
					{ "i", "c" }
				),
				["<Up>"] = cmp.mapping(
					cmp.mapping.select_prev_item({
						behavior = cmp.SelectBehavior.Select,
					}),
					{ "i", "c" }
				),
				["<Tab>"] = cmp.mapping(function(fallback)
					-- This little snippet will confirm with tab, and if no entry is selected, will confirm the first item
					if cmp.visible() then
						local entry = cmp.get_selected_entry()
						if not entry then
							cmp.select_next_item({
								behavior = cmp.SelectBehavior.Select,
							})
						end
						cmp.confirm()
					else
						fallback()
					end
				end, { "i", "s", "c" }),
			}
			opts.sources = cmp.config.sources({
				{
					name = "nvim_lsp",
				}, -- { name = 'vsnip' }, -- For vsnip users.
				{
					name = "path",
				},
				{
					name = "ultisnips",
				}, -- For ultisnips users.
			}, {
				{
					name = "buffer",
				},
			})
		end,
		config = function(_, opts)
			local cmp = require("cmp")
			cmp.setup(opts)
			cmp.setup.cmdline("/", {
				sources = {
					{
						name = "buffer",
					},
				},
			})
			cmp.setup.cmdline(":", {
				sources = cmp.config.sources({
					{
						name = "path",
					},
				}, {
					{
						name = "cmdline",
					},
				}),
			})

			-- gray
			vim.api.nvim_set_hl(0, "CmpItemAbbrDeprecated", { bg = "NONE", strikethrough = true, fg = "#808080" })
			-- blue
			vim.api.nvim_set_hl(0, "CmpItemAbbrMatch", { bg = "NONE", fg = "#569CD6" })
			vim.api.nvim_set_hl(0, "CmpItemAbbrMatchFuzzy", { link = "CmpIntemAbbrMatch" })
			-- light blue
			vim.api.nvim_set_hl(0, "CmpItemKindVariable", { bg = "NONE", fg = "#9CDCFE" })
			vim.api.nvim_set_hl(0, "CmpItemKindInterface", { link = "CmpItemKindVariable" })
			vim.api.nvim_set_hl(0, "CmpItemKindText", { link = "CmpItemKindVariable" })
			-- pink
			vim.api.nvim_set_hl(0, "CmpItemKindFunction", { bg = "NONE", fg = "#C586C0" })
			vim.api.nvim_set_hl(0, "CmpItemKindMethod", { link = "CmpItemKindFunction" })
			-- front
			vim.api.nvim_set_hl(0, "CmpItemKindKeyword", { bg = "NONE", fg = "#D4D4D4" })
			vim.api.nvim_set_hl(0, "CmpItemKindProperty", { link = "CmpItemKindKeyword" })
			vim.api.nvim_set_hl(0, "CmpItemKindUnit", { link = "CmpItemKindKeyword" })
			vim.api.nvim_set_hl(0, "LspSignatureActiveParameter", { bg = "#113A5C" })
		end,
	},

	{
		"nvimdev/lspsaga.nvim",
		opts = {},
	},
}
