return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- LazyVim's lang.kotlin extra hardcodes this server; disable it so it
        -- never tries to spawn/reinstall it again in favor of kotlin_lsp.
        kotlin_language_server = { enabled = false },
        kotlin_lsp = {},
      },
    },
  },
  {
    "mason-org/mason.nvim",
    opts = { ensure_installed = { "kotlin-lsp" } },
  },
}
