return {
  {
    "johnseth97/codex.nvim",
    lazy = true,
    cmd = { "Codex", "CodexToggle" },
    keys = {
      {
        "<leader>ac",
        function()
          require("codex").toggle()
        end,
        desc = "Codex Toggle",
        mode = { "n", "t" },
      },
    },
    opts = {
      keymaps = {
        quit = "<C-q>",
      },
      border = "rounded",
      width = 0.8,
      height = 0.8,
      model = nil, -- default to the latest model
      autoinstall = true,
      panel = false, -- floating window instead of side-panel
      use_buffer = false,
    },
  },
}
