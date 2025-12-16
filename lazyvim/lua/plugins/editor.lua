return {
	---------------------------------------------------------------------------
	-- mini.surround: vim-surround compatible keybindings (ys, ds, cs)
	---------------------------------------------------------------------------
	{
		"nvim-mini/mini.surround",
		opts = {
			mappings = {
				add = "ys",
				delete = "ds",
				find = "",
				find_left = "",
				highlight = "",
				replace = "cs",
				update_n_lines = "",
				suffix_last = "",
				suffix_next = "",
			},
			search_method = "cover_or_next",
		},
		config = function(_, opts)
			require("mini.surround").setup(opts)
			-- Visual mode: use S to add surrounding (like vim-surround)
			vim.keymap.set("x", "S", [[:<C-u>lua MiniSurround.add('visual')<CR>]], { silent = true })
			-- yss to surround entire line
			vim.keymap.set("n", "yss", "ys_", { remap = true })
		end,
	},

	---------------------------------------------------------------------------
	-- which-key: add custom group names
	---------------------------------------------------------------------------
	{
		"folke/which-key.nvim",
		opts = {
			spec = {
				{ "<leader>mm", desc = "Add mark" },
			},
		},
	},
}
