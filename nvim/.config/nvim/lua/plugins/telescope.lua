-- telescope.nvim
return {
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
    },

    config = function()
      local telescope = require("telescope")
      local builtin = require("telescope.builtin")

      telescope.setup({
        defaults = {
          preview = {
            treesitter = true,
          },

          border = {
            prompt = { 1, 1, 1, 1 },
            results = { 1, 1, 1, 1 },
            preview = { 1, 1, 1, 1 },
          },

          borderchars = {
            prompt = { " ", " ", "─", "│", "│", " ", "─", "└" },
            results = { "─", " ", " ", "│", "┌", "─", " ", "│" },
            preview = { "─", "│", "─", "│", "┬", "┐", "┘", "┴" },
          },
        },

        pickers = {
          find_files = {
            hidden = true,
            find_command = {
              "rg",
              "--files",
              "--hidden",
              "--no-ignore",
              "-g",
              "!.git",
              "-g",
              "!node_modules",
              "-g",
              "!.next",
              "-g",
              "!target",
              "-g",
              "!.svelte-kit",
            },
          },

          colorscheme = {
            enable_preview = true,
          },
        },

        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },

          ["ui-select"] = require("telescope.themes").get_dropdown({}),
        },
      })

      telescope.load_extension("fzf")
      telescope.load_extension("zoxide")
      telescope.load_extension("ui-select")

      -- Keymaps
      vim.keymap.set("n", "<leader>jk", builtin.find_files, { desc = "Find files" })
      vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
      vim.keymap.set("n", "<leader>fd", builtin.diagnostics, { desc = "Diagnostics" })
      vim.keymap.set("n", "<leader>ds", builtin.lsp_document_symbols, { desc = "Document symbols" })
      vim.keymap.set("n", "<leader>ws", builtin.lsp_workspace_symbols, { desc = "Workspace symbols" })
      vim.keymap.set("n", "<leader>fv", builtin.help_tags, { desc = "Help tags" })
      vim.keymap.set("n", "<leader>fp", builtin.builtin, { desc = "Builtin pickers" })
      vim.keymap.set("n", "<leader>fz", "<cmd>Telescope zoxide list<CR>", { desc = "Zoxide" })
    end,
  },

  {
    "jvgrootveld/telescope-zoxide",
  },

  {
    "nvim-telescope/telescope-ui-select.nvim",
  },
}
