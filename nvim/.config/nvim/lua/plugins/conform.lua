return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        javascript = { "prettierd", "prettier" },
        typescript = { "prettierd", "prettier" },
        vue = { "prettierd", "prettier" },
        json = { "prettierd", "prettier" },
      },
    },
  },
}
