-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Transparent line numbers background
autocmd("ColorScheme", {
  group = augroup("TransparentLineNr", { clear = true }),
  pattern = "*",
  callback = function()
    vim.api.nvim_set_hl(0, "LineNr", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "SignColumn", { bg = "NONE" })
  end,
})

-- Set filetype to SQL for .ddl files
autocmd("BufEnter", {
  group = augroup("DDLFiletype", { clear = true }),
  pattern = { "*.ddl" },
  command = "setfiletype sql",
})

-- Auto toggle relative/absolute line numbers
-- Note: C-c doesn't trigger InsertLeave, see keymaps.lua for fix
local number_toggle = augroup("NumberToggle", { clear = true })
autocmd({ "BufEnter", "FocusGained", "InsertLeave", "WinEnter" }, {
  group = number_toggle,
  callback = function()
    if vim.wo.number then
      vim.wo.relativenumber = true
    end
  end,
})
autocmd({ "BufLeave", "FocusLost", "InsertEnter", "WinLeave" }, {
  group = number_toggle,
  callback = function()
    if vim.wo.number then
      vim.wo.relativenumber = false
    end
  end,
})
