return {
  ---------------------------------------------------------------------------
  -- Treesitter: additional parsers not in LazyVim defaults
  ---------------------------------------------------------------------------
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "css",
        "rust",
        "java",
      },
      ignore_install = { "haskell" },
    },
  },

  ---------------------------------------------------------------------------
  -- Remap K from LSP hover to buffer navigation (gh is used for hover)
  ---------------------------------------------------------------------------
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ["*"] = {
          keys = {
            { "K", "<cmd>BufferLineCyclePrev<cr>", desc = "Previous buffer" },
          },
        },
      },
    },
  },
}
