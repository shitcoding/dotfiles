-- Snacks.nvim configuration (LazyVim's file explorer/picker)
return {
  "folke/snacks.nvim",
  opts = {
    -- Disable smooth scrolling
    scroll = { enabled = false },
    -- Picker settings
    picker = {
      win = {
        input = {
          keys = {
            ["<C-n>"] = { "preview_scroll_down", mode = { "i", "n" } },
            ["<C-p>"] = { "preview_scroll_up", mode = { "i", "n" } },
          },
        },
        list = {
          wo = {
            number = true,
            relativenumber = true,
            fillchars = "eob: ",
          },
          keys = {
            ["<C-n>"] = "preview_scroll_down",
            ["<C-p>"] = "preview_scroll_up",
          },
        },
      },
    },
  },
}
