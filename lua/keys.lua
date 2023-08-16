local function map(key, cmd, des)
	vim.keymap.set("n", key, cmd, { desc = des })
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
	{ "g", "<cmd>Files<CR>", "fzf" },
	{ "m", "<cmd>NeomakeProject tsc<CR>", "Make" },
	{ "f", "<cmd>Lf<cr>", "Files" },
}

for _, k in ipairs(leaders) do
	map("<leader>" .. k[1], k[2], k[3])
end

local keys = {
	{ "<C-Up>", "<cmd>bp<cr>", "Prev Buffer" },
	{ "<C-Down>", "<cmd>bn<cr>", "Next Buffer" },
	{ "[q", "<cmd>cprevious<cr>", "Prev Action" },
	{ "]q", "<cmd>cnext<cr>", "Next Action" },
}

for _, k in ipairs(keys) do
	map(k[1], k[2], k[3])
end
