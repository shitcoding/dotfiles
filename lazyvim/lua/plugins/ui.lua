return {
  ---------------------------------------------------------------------------
  -- Lualine configuration
  ---------------------------------------------------------------------------
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      -- Show mode in section a
      opts.sections = opts.sections or {}
      opts.sections.lualine_a = { "mode" }

      -- Show relative path in section c
      opts.sections.lualine_c = {
        {
          "filename",
          path = 1, -- relative path
        },
      }

      -- Inactive sections also show relative path
      opts.inactive_sections = opts.inactive_sections or {}
      opts.inactive_sections.lualine_c = {
        {
          "filename",
          path = 1,
        },
      }

      -- Disable globalstatus (separate statusline per window)
      opts.options = opts.options or {}
      opts.options.globalstatus = false
      opts.options.disabled_filetypes = {
        statusline = { "lazy" },
      }

      return opts
    end,
  },

  ---------------------------------------------------------------------------
  -- Bufferline configuration
  ---------------------------------------------------------------------------
  {
    "akinsho/bufferline.nvim",
    opts = {
      options = {
        show_buffer_close_icons = false,
        tab_size = 10,
      },
    },
  },
}
