return {
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    config = function()
      require("mason-tool-installer").setup({
        ensure_installed = {
          "stylua",
          "prettierd",
          "eslint_d",
          "dotenv-linter",
          "rustywind",
          "stylelint",
          "nixfmt"
        },
        automatic_installation = true,
      })
    end,
  },

  {
    "nvimtools/none-ls.nvim",
    dependencies = {
      "nvimtools/none-ls-extras.nvim",
    },
    config = function()
      local null_ls = require("null-ls")

      null_ls.setup({
        sources = {
          null_ls.builtins.formatting.stylua,
          null_ls.builtins.formatting.prettierd,
          null_ls.builtins.formatting.rustywind,
          null_ls.builtins.formatting.nixfmt,
          null_ls.builtins.diagnostics.dotenv_linter,
          null_ls.builtins.diagnostics.stylelint,
          require("none-ls.diagnostics.eslint_d"),
        },
      })

      vim.keymap.set("n", "<leader>s", vim.lsp.buf.format, {})
    end,
  },
}
