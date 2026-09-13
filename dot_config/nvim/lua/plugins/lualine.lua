return {
  -- lualine is default in layzvim. This file changes some settings of lualine.
  {
    "nvim-lualine/lualine.nvim",
    event = "VimEnter", -- Forces it to wait until Neovim UI is ready
    opts = function(_, opts)
      -- Ersetze die filetype-Komponente
      opts.sections.lualine_c = {
        {
          "filetype",
          icon_only = false, -- Symbol + Text
          colored = true,
          separator = "",
          padding = { left = 1, right = 0 },
        },
        unpack(vim.list_slice(opts.sections.lualine_c, 2)),
      }

      return opts
    end,
  },
}
