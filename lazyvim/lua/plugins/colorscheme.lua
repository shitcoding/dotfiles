return {
  -- VSCode colorscheme
  {
    "Mofiqul/vscode.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("vscode").setup({
        transparent = true,
        italic_comments = true,
        underline_links = true,
      })
      require("vscode").load()
    end,
  },

  -- Tell LazyVim to use vscode as colorscheme
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "vscode",
    },
  },
}
