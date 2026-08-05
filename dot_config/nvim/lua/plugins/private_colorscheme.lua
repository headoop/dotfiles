return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight-moon",
    },
  },
  {
    "folke/tokyonight.nvim",
    lazy = true,
    opts = {
      transparent = true,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
    },
  },
  -- {
  --   -- add config option to preconfigured colorscheme catppuccin
  --   "catppuccin/nvim",
  --   opts = function(_, opts)
  --     local module = require("catppuccin.groups.integrations.bufferline")
  --     if module then
  --       module.get = module.get_theme
  --     end
  --     return opts
  --   end,
  -- },
}
