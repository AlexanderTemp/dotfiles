return {
  {
    "folke/flash.nvim",
    event = "VeryLazy",

    keys = {
      { "s", false },
      { "S", false },
      {
        "zk",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump()
        end,
        desc = "Flash",
      },
      {
        "Zk",
        mode = { "n", "x", "o" },
        function()
          require("flash").treesitter()
        end,
        desc = "Flash Treesitter",
      },
    },
  },
}
