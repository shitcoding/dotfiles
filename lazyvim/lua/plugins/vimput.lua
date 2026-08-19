-- Vimput mode: disable heavy plugins for popup editing
-- Activated when VIMPUT=1 environment variable is set
if not vim.env.VIMPUT then
  return {}
end

-- Shift+Enter inserts a newline instead of leaving insert mode.
-- kitty maps shift+enter to ESC CR so TUIs treating meta+enter as "newline"
-- (Claude Code) stop submitting on it. nvim decodes that pair as <M-CR>, and
-- unmapped it falls back to ESC-then-CR, i.e. insert mode is dropped. The
-- popup is a text field, so Shift+Enter should behave as it does in one.
vim.keymap.set("i", "<M-CR>", "<CR>", { desc = "Vimput: insert newline" })

-- Disable heavy plugins via cond=false (does not uninstall, just skips loading)
return {
  -- Treesitter
  { "nvim-treesitter/nvim-treesitter", cond = false },
  { "nvim-treesitter/nvim-treesitter-textobjects", cond = false },
  { "windwp/nvim-ts-autotag", cond = false },

  -- LSP
  { "neovim/nvim-lspconfig", cond = false },

  -- Formatting & linting
  { "stevearc/conform.nvim", cond = false },
  { "mfussenegger/nvim-lint", cond = false },

  -- Telescope / picker
  { "nvim-telescope/telescope.nvim", cond = false },
  { "nvim-telescope/telescope-fzf-native.nvim", cond = false },
  { "ibhagwan/fzf-lua", cond = false },

  -- Completion
  { "saghen/blink.cmp", cond = false },
  { "hrsh7th/nvim-cmp", cond = false },

  -- UI chrome (not needed for popup)
  { "nvim-lualine/lualine.nvim", cond = false },
  { "akinsho/bufferline.nvim", cond = false },
  { "folke/noice.nvim", cond = false },
  { "MunifTanjim/nui.nvim", cond = false },
  { "nvim-neo-tree/neo-tree.nvim", cond = false },
  { "lewis6991/gitsigns.nvim", cond = false },
  { "folke/todo-comments.nvim", cond = false },
  { "folke/trouble.nvim", cond = false },
  { "RRethy/vim-illuminate", cond = false },
  { "lukas-reineke/indent-blankline.nvim", cond = false },
  { "stevearc/dressing.nvim", cond = false },
  { "rcarriga/nvim-notify", cond = false },

  -- Navigation (not needed for single-file popup)
  { "nvim-tree/nvim-web-devicons", cond = false },
  { "nvim-lua/plenary.nvim", cond = false },

  -- Disable snacks features not needed for popup
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = { enabled = false },
      indent = { enabled = false },
      scroll = { enabled = false },
    },
  },
}
