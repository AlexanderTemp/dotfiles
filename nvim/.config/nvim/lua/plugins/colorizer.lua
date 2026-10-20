return {
  "catgoose/nvim-colorizer.lua",
  event = "BufReadPre",
  opts = {
    user_default_options = {
      tailwind = true,
      names = true,
    },
  },
  config = function(_, opts)
    require("colorizer").setup(opts)
  end,
}
