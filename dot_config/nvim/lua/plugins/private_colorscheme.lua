-- return {
--   {
--     "folke/tokyonight.nvim",
--     lazy = true,
--     opts = {
--       style = "moon",
--       transparent = true,
--       styles = {
--         sidebars = "transparent",
--         floats = "transparent",
--       },
--     },
--   },
--   {
--     "LazyVim/LazyVim",
--     opts = {
--       colorscheme = "tokyonight-moon",
--     },
--   },
-- }

return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
  {
    "catppuccin/nvim",
    -- lazy = true,
    lazy = false,
    priority = 1000, -- load this first
    -- "catppuccin",
    name = "catppuccin",
    -- priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha", -- other options: "mocha", "frappe", "macchiato"
        transparent_background = true,
      })
      vim.cmd.colorscheme("catppuccin-mocha")
    end,
  },
  {
    "akinsho/bufferline.nvim",
    optional = true,
    opts = function(_, opts)
      if (vim.g.colors_name or ""):find("catppuccin") then
        opts.highlights = require("catppuccin.special.bufferline").get_theme()
      end
    end,
  },
}
