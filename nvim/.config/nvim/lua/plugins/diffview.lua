return {
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory", "DiffviewToggleFiles" },
    keys = {
      { "<leader>gvo", "<cmd>DiffviewOpen<cr>", desc = "Diffview Open" },
      { "<leader>gvc", "<cmd>DiffviewClose<cr>", desc = "Diffview Close" },
      { "<leader>gvh", "<cmd>DiffviewFileHistory %<cr>", desc = "Diffview File History" },
      { "<leader>gvH", "<cmd>DiffviewFileHistory<cr>", desc = "Diffview Repo History" },
    },
    opts = function(_, opts)
      local actions = require("diffview.actions")
      local choices = { "ours", "theirs", "base", "all", "none" }
      return vim.tbl_deep_extend("force", opts, {
        enhanced_diff_hl = true,
        view = {
          merge_tool = { layout = "diff3_mixed" },
        },
        keymaps = {
          view = {
            { "n", "dho", actions.conflict_choose("ours"), { desc = "Choose OURS" } },
            { "n", "dht", actions.conflict_choose("theirs"), { desc = "Choose THEIRS" } },
            { "n", "dhb", actions.conflict_choose("base"), { desc = "Choose BASE" } },
            { "n", "dhn", actions.conflict_choose("none"), { desc = "Choose none (delete conflict)" } },
            {
              "n",
              "dx",
              function()
                vim.ui.select(choices, { prompt = "Resolve conflict with:" }, function(choice)
                  if choice then
                    actions.conflict_choose(choice)()
                  end
                end)
              end,
              { desc = "Choose a conflict-resolution option" },
            },
          },
        },
      })
    end,
  },
}
