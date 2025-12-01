return {
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.6",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-ui-select.nvim",
        config = function()
          require("telescope").setup({
            extensions = {
              ["ui-select"] = {
                require("telescope.themes").get_dropdown({
                  -- Custom dropdown theme config here
                  previewer = false,
                  layout_config = {
                    width = 0.8,
                    height = 0.8,
                  },
                }),
              },
            },
          })
          require("telescope").load_extension("ui-select")
        end,
      },
      -- Optional additional extensions
      "nvim-telescope/telescope-file-browser.nvim",
      "nvim-telescope/telescope-project.nvim",
    },
    config = function()
      local telescope = require("telescope")
      local builtin = require("telescope.builtin")
      local actions = require("telescope.actions")

      -- Better default configuration
      telescope.setup({
        defaults = {
          mappings = {
            i = {
              ["<esc>"] = actions.close, -- Better escape behavior
              ["<C-u>"] = false, -- Disable clear prompt (conflict with my common keymap)
            },
          },
          layout_strategy = "horizontal",
          layout_config = {
            horizontal = {
              preview_width = 0.55,
            },
          },
          file_ignore_patterns = {
            "node_modules",
            ".git",
            ".cache",
          },
        },
        pickers = {
          find_files = {
            hidden = true,
            no_ignore = false,
          },
        },
      })

      -- Load extensions
      pcall(telescope.load_extension, "file_browser")
      pcall(telescope.load_extension, "project")

      -- Keymaps with better descriptions and organization
      local keymap = vim.keymap.set
      keymap("n", "<leader>ff", builtin.find_files, { desc = "[F]ind [F]iles" })
      keymap("n", "<leader>fg", builtin.live_grep, { desc = "[F]ind with [G]rep" })
      keymap("n", "<leader>fb", builtin.buffers, { desc = "[F]ind [B]uffers" })
      keymap("n", "<leader>fh", builtin.help_tags, { desc = "[F]ind [H]elp" })
      keymap("n", "<leader>fr", builtin.oldfiles, { desc = "[F]ind [R]ecent files" })
      keymap("n", "<leader>fp", ":Telescope project<CR>", { desc = "[F]ind [P]roject" })
      keymap("n", "<leader>fe", ":Telescope file_browser<CR>", { desc = "[F]ile [E]xplorer" })

      -- Advanced: Find word under cursor
      keymap("n", "<leader>fw", function()
        builtin.grep_string({ search = vim.fn.expand("<cword>") })
      end, { desc = "[F]ind [W]ord under cursor" })
    end,
  },
}
