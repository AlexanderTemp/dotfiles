vim.opt_local.shiftwidth = 4
vim.opt_local.tabstop = 4
vim.opt_local.softtabstop = 4
vim.opt_local.expandtab = true
vim.b.autoformat = false

local buf = vim.api.nvim_get_current_buf()
vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("formato_java_" .. buf, { clear = true }),
  buffer = buf,
  callback = function()
    local ok, gitsigns = pcall(require, "gitsigns")
    if not ok or #vim.lsp.get_clients({ bufnr = buf, name = "jdtls" }) == 0 then
      return
    end
    local hunks = gitsigns.get_hunks(buf) or {}
    table.sort(hunks, function(a, b)
      return a.added.start > b.added.start
    end)
    for _, hunk in ipairs(hunks) do
      if hunk.added.count > 0 then
        local inicio = hunk.added.start
        local fin = inicio + hunk.added.count - 1
        local ultima = vim.api.nvim_buf_get_lines(buf, fin - 1, fin, false)[1] or ""
        vim.lsp.buf.format({
          bufnr = buf,
          name = "jdtls",
          async = false,
          timeout_ms = 5000,
          range = { start = { inicio, 0 }, ["end"] = { fin, #ultima } },
        })
      end
    end
  end,
})
