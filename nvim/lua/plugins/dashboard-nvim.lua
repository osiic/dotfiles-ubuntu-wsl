-- Home Page dengan dashboard-nvim
return {
  "glepnir/dashboard-nvim",
  event = "VimEnter",
  dependencies = {
    "nvim-tree/nvim-web-devicons"
  },
  config = function()
    local db = require("dashboard")

    db.setup({
      theme = "doom", -- atau "hyper"
      config = {
        header = {
          "",
          "",
          "   ██████╗███████╗███╗   ███╗██╗   ██╗",
          "  ██╔════╝██╔════╝████╗ ████║██║   ██║",
          "  ██║     █████╗  ██╔████╔██║██║   ██║",
          "  ██║     ██╔══╝  ██║╚██╔╝██║██║   ██║",
          "  ╚██████╗███████╗██║ ╚═╝ ██║╚██████╔╝",
          "   ╚═════╝╚══════╝╚═╝     ╚═╝ ╚═════╝ ",
          "",
          "   Clean Efficient Minimal Utuh  ",
          "",
        },

        center = {
          {
            icon = "📂",
            desc = " Recently opened files",
            key = "r",
            action = "Telescope oldfiles"
          },
          {
            icon = "🔍",
            desc = " Find file",
            key = "f",
            action = "Telescope find_files"
          },
          {
            icon = "🗂️",
            desc = " File browser",
            key = "e",
            action = "Neotree filesystem toggle right"
          },
          {
            icon = "🔎",
            desc = " Find word",
            key = "g",
            action = "Telescope live_grep"
          },
          {
            icon = "❌",
            desc = " Quit",
            key = "q",
            action = "qa"
          },
        },

        footer = {
          "",
          "Ngecode dulu biar mapan ✨",
          ""
        },
      }
    })
  end
}
