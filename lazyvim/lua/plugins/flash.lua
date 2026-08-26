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
      char = {
        -- jump.pos above is global and leaks into f/F/t/T. With "end", jump.lua
        -- adds offset = 1 to any jump that lands BEFORE the cursor, so `,` stops
        -- one column past the previous match -- and the next `,` re-finds that
        -- same match, jumps to end+1, and the cursor never moves again.
        -- Char-mode matches are always 1 char wide, so "start" == "end" here
        -- minus the offset hack.
        jump = {
          pos = "start",
        },
        highlight = {
          groups = {
            -- f/t/;/, have jump_labels = false, so every match gets an EMPTY label
            -- (char.lua:66). highlight.lua:149 then paints empty labels with
            -- groups.label at priority+2 -- over the FlashMatch extmark at +1.
            -- So in char mode "all the other matches" are drawn with the LABEL
            -- group, not FlashMatch. Point it at the dim group here, or every
            -- occurrence renders in the bright label orange and only the current
            -- one differs.
            label = "FlashMatch",
          },
        },
      },
    },
  },
  config = function(_, opts)
    require("flash").setup(opts)
    -- flash registers FlashMatch/FlashCurrent/FlashBackdrop once, as links, with
    -- default = true, and has no ColorScheme autocmd. Loading a colorscheme runs
    -- :hi clear and destroys them, so the groups end up undefined and matches render
    -- on the bare terminal background (black here: vscode.nvim transparent + Ghostty
    -- background = #000000). Define them explicitly and re-apply on every load.
    local function flash_hl()
      -- labels: bright orange, black text
      vim.api.nvim_set_hl(0, "FlashLabel", { fg = "#000000", bg = "#FF8701", bold = true })
      -- other occurrences: dim warm brown (matches the colorscheme's Search)
      vim.api.nvim_set_hl(0, "FlashMatch", { fg = "#ffd9b3", bg = "#613315" })
      -- the match you'd jump to next: bright peach
      vim.api.nvim_set_hl(0, "FlashCurrent", { fg = "#1b1d2b", bg = "#ff966c", bold = true })
      -- FlashBackdrop left undefined on purpose: defining it dims the whole buffer
      -- during flash, which is a behaviour change, not a colour fix.
    end
    flash_hl()
    vim.api.nvim_create_autocmd("ColorScheme", { callback = flash_hl })
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
