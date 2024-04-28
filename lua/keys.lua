local function map(key, cmd, des)
	vim.keymap.set("n", key, cmd, { desc = des })
end
local function imap(key, cmd, des)
	vim.keymap.set("i", key, cmd, { desc = des })
end
local function vmap(key, cmd, des)
	vim.keymap.set("v", key, cmd, { desc = des })
end

local leaders = {
	{ "<space>", "<cmd>nohlsearch<CR>", "Clear search highlight" },
	{ "<right>", "<cmd>tabn<CR>", "Next Tab" },
	{ "<left>", "<cmd>tabp<CR>", "Prev Tab" },
	{ "b", "<cmd>Buffers<CR>", "Buffers" },
	{ "c", "<cmd>cclose<CR>", "Close Quick Fix" },
	{ "l", "<cmd>Format<CR>", "Format" },
	{ "?", "<cmd>Cheatsheet<CR>", "Cheatsheet" },
	{ "/", "<cmd>Telescope live_grep<CR>", "grep" },
	{ "g", "<cmd>Telescope find_files<CR>", "fzf" },
	{ "m", "<cmd>NeomakeProject tsc<CR>", "Make" },
	{ "f", "<cmd>Lf<cr>", "Files" },
    { "C", "<cmd>Colortils picker<cr>", "Color Picker"}
}

for _, k in ipairs(leaders) do
	map("<leader>" .. k[1], k[2], k[3])
end

local keys = {
	{ "<C-Up>", "<cmd>bp<cr>", "Prev Buffer" },
	{ "<C-Down>", "<cmd>bn<cr>", "Next Buffer" },
	{ "[q", "<cmd>cprevious<cr>", "Prev Action" },
	{ "]q", "<cmd>cnext<cr>", "Next Action" },
	{ "<C-p>", vim.lsp.buf.signature_help, "Show signature help." },
}

for _, k in ipairs(keys) do
	map(k[1], k[2], k[3])
end

local inserts = {
	{ "<C-p>", vim.lsp.buf.signature_help, "Show signature help." },

	{ "<C-g>", "<cmd>Telescope find_files<cr>", "Find files." },
}

for _, k in ipairs(inserts) do
	imap(k[1], k[2], k[3])
end

local visual = {
	{
		"<C-g>",
		function()
			print(vim.inspect(vim.api.nvim_buf_get_mark(0, "<")))
			print(vim.inspect(vim.api.nvim_buf_get_mark(0, ">")))
			print(vim.inspect(vim.fn.getpos("'<")))
			print(vim.inspect(vim.fn.getpos("v")))
			print(vim.inspect(vim.fn.getcurpos()))
			local v = vim.fn.getpos("v")
			local cur = vim.fn.getcurpos()
			local sr = v[2] - 1
			local sc = v[3] - 1
			local er = cur[2] - 1
			local ec = cur[3]

			print(string.format("%d, %d, %d, %d", sr, sc, er, ec))

			local curs
			if sc > ec then
				curs = ec
			else
				curs = sc
			end

			vim.api.nvim_buf_set_text(0, sr, sc, er, ec, {})
			vim.fn.cursor(sr + 1, curs)
			require("telescope.builtin").find_files()
		end,
		"Find files.",
	},
	{
		"<C-f>",
		function()
			vim.cmd([[change]])
		end,
		"Test",
	},
}

for _, k in ipairs(visual) do
	vmap(k[1], k[2], k[3])
end
