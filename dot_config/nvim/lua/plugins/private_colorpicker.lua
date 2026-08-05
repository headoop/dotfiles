return {
  -- plugin color-picker is only loaded for css, javascript and html files
  "ziontee113/color-picker.nvim",
  -- lazy = false,
  ft = { "css", "javascript", "html" },
  opts = {},
  keys = {
    {
      mode = { "n" },
      "<leader>cp",
      "<cmd>PickColor<cr>",
      desc = "color picker",
    },
    {
      mode = "i",
      "<C-c>",
      "<cmd>PickColorInsert<cr>",
      desc = "color picker",
    },
  },
}
