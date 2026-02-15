local chicote = require("custom.custom")
chicote.cowboy()

local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- Split window
keymap.set("n", "<leader>wj", ":split<Return>", opts)
keymap.set("n", "<leader>wl", ":vsplit<Return>", opts)

-- Move window
keymap.set("n", "<C-h>", "<C-w>h", opts)
keymap.set("n", "<C-k>", "<C-w>k", opts)
keymap.set("n", "<C-j>", "<C-w>j", opts)
keymap.set("n", "<C-l>", "<C-w>l", opts)

-- Close actual window
keymap.set("n", "<leader>wc", "<cmd>close<CR>", opts)

-- Scroll with centered cursor
keymap.set("n", "<C-d>", "<C-d>zz")
keymap.set("n", "<C-u>", "<C-u>zz")
keymap.set("n", "<C-f>", "<C-f>zz")
keymap.set("n", "<C-b>", "<C-b>zz")

--- Limpieza de buffer
keymap.set("n", "<leader>q", function()
  require("snacks").bufdelete()
end, { desc = "Close buffer" })
