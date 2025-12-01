-- Theme
return {
  "catppuccin/nvim",
  lazy = false,
  priority = 1000,
  name = "catppuccin",
  config = function()
    require("catppuccin").setup()
    vim.cmd.colorscheme("catppuccin-mocha")
  end,
}
