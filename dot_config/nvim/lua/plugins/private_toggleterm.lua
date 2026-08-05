return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = true,
    keys = {
      {
        -- "<leader>tt",
        "<leader>#",
        "<cmd>ToggleTerm size=16 direction=horizontal<cr>",
        desc = "Öffnet ein horizontales Terminal im Desktop-Verzeichnis",
      },
      {
        "<leader>tt",
        "<cmd>ToggleTerm size=60 direction=float<cr>",
        desc = "Öffnet ein schwebendes Terminal",
      },
    },
  },
}
