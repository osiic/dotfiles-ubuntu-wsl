return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons", -- for file icons
		"MunifTanjim/nui.nvim",
	},
	config = function()
		require("neo-tree").setup({
			close_if_last_window = true, -- Close if neo-tree is the last window
			enable_git_status = true, -- Enable Git status
			enable_diagnostics = false, -- Disable diagnostics (optional)
			default_component_configs = {
				indent = {
					indent_size = 2,
					padding = 1,
				},
				icon = {
					folder_closed = "",
					folder_open = "",
					folder_empty = "",
				},
				git_status = {
					symbols = {
						added = "",
						modified = "",
						deleted = "",
						renamed = "➜",
						untracked = "",
						ignored = "◌",
					},
					colors = { -- <-- Warna Git status
						added = "#a7c080",
						modified = "#d3c6aa",
						deleted = "#e67e80",
						renamed = "#7dcfff", -- Opsional: warna untuk renamed
						untracked = "#dbbc7f", -- Opsional: warna untuk untracked
					},
				},
			},
			window = {
				position = "right",
				width = 30,
				mappings = {
					["h"] = "close_node", -- Tutup folder (seperti 'collapse')
					["l"] = "open", -- Buka folder/file
					["<C-e>"] = "close_window", -- Close Neo-tree
				},
			},
			filesystem = {
				use_libuv_file_watcher = true, -- Auto-refresh saat ada perubahan file
				async_directory_scan = "auto", -- atau "always"
				scan_mode = "shallow",
				filtered_items = {
					visible = true, -- Show hidden files by default
					hide_dotfiles = false, -- Show dotfiles (e.g., .gitignore)
					hide_gitignored = false, -- Don't hide gitignored files
				},
				follow_current_file = {
					enabled = true, -- Auto-focus on current file when switching
				},
				hijack_netrw_behavior = "open_default", -- Better handling with netrw
			},
		})

		-- Keymaps
		vim.keymap.set(
			"n",
			"<leader>e",
			":Neotree filesystem toggle right<CR>",
			{ desc = "Toggle Neo-tree (filesystem)" }
		)
		vim.keymap.set("n", "<leader>ge", ":Neotree git_status toggle<CR>", { desc = "Toggle Neo-tree (Git status)" })
	end,
}
