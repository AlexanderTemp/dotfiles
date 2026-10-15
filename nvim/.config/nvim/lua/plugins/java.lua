local java21 = vim.fn.expand("~/.sdkman/candidates/java/21.0.2-open")
local java15 = vim.fn.expand("~/.sdkman/candidates/java/15.0.2-open")

return {
  {
    "mfussenegger/nvim-jdtls",
    opts = function(_, opts)
      vim.list_extend(opts.cmd, { "--java-executable", java21 .. "/bin/java" })

      opts.root_dir = function(path)
        local encontrados = vim.fs.find("settings.gradle", { path = path, upward = true, limit = math.huge })
        if #encontrados > 0 then
          return vim.fs.dirname(encontrados[#encontrados])
        end
        return vim.fs.root(path, vim.lsp.config.jdtls.root_markers)
      end

      opts.settings = vim.tbl_deep_extend("force", opts.settings or {}, {
        java = {
          import = { gradle = { java = { home = java15 } } },
          configuration = {
            runtimes = { { name = "JavaSE-15", path = java15, default = true } },
          },
        },
      })
    end,
  },
}
