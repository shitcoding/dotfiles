-- Flash.nvim configuration
return {
  "folke/flash.nvim",
  opts = {
    jump = {
      pos = "end", -- put cursor at end of match
    },
    modes = {
      -- Enable flash labels during regular search with / and ?
      search = {
        enabled = true,
      },
    },
    highlight = {
      groups = {
        label = "FlashLabel",
      },
    },
  },
  config = function(_, opts)
    require("flash").setup(opts)
    -- Set bright orange background with black text for labels
    vim.api.nvim_set_hl(0, "FlashLabel", { fg = "#000000", bg = "#FF8701", bold = true })
  end,
  keys = {
    -- Disable flash's S in visual mode (conflicts with mini.surround)
    { "S", mode = { "x", "o" }, false },
    -- Add flash labels when using * and # to search word under cursor
    {
      "*",
      function()
        local word = vim.fn.expand("<cword>")
        require("flash").jump({
          pattern = "\\<" .. word .. "\\>",
          search = {
            mode = "search",
            max_length = 0,
          },
        })
      end,
      desc = "Search word under cursor (flash)",
    },
    {
      "#",
      function()
        local word = vim.fn.expand("<cword>")
        require("flash").jump({
          pattern = "\\<" .. word .. "\\>",
          search = {
            mode = "search",
            max_length = 0,
            forward = false,
          },
        })
      end,
      desc = "Search word under cursor backward (flash)",
    },
  },
}
