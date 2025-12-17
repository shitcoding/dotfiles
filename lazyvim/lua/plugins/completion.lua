-- Disable completion for plain text files
return {
  {
    "saghen/blink.cmp",
    opts = {
      enabled = function()
        local disabled_filetypes = { "text", "markdown", "gitcommit" }
        return not vim.tbl_contains(disabled_filetypes, vim.bo.filetype)
      end,
    },
  },
}
