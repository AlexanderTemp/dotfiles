return {
  "catgoose/nvim-colorizer.lua",
  event = "BufReadPre",
  opts = {
    user_default_options = {
      tailwind = true,
      names = true, -- named colors like "red", "blue"
    },
  },
  config = function(_, opts)
    require("colorizer").setup(opts)
  end,
}
