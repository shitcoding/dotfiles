-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

---------------------------------------------------------------------------
-- Note: K for LSP hover is disabled in plugins/lsp.lua
---------------------------------------------------------------------------

---------------------------------------------------------------------------
-- LSP hover: gh instead of K
---------------------------------------------------------------------------
keymap("n", "gh", function()
	vim.lsp.buf.hover()
end, { desc = "LSP Hover" })

---------------------------------------------------------------------------
-- Join lines: gj instead of J (J is for buffer navigation)
---------------------------------------------------------------------------
keymap("n", "gj", "J", { desc = "Join lines" })

---------------------------------------------------------------------------
-- Marks: <Leader>mm instead of m (m is for buffer move)
---------------------------------------------------------------------------
keymap("n", "<Leader>mm", "m", { desc = "Add mark" })

---------------------------------------------------------------------------
-- H / L - go to beginning/end of line
---------------------------------------------------------------------------
-- Normal mode
keymap("n", "H", "^", { desc = "Go to line start" })
keymap("n", "L", "$", { desc = "Go to line end" })
-- Cyrillic
keymap("n", "Р", "^", opts)
keymap("n", "Д", "$", opts)

-- Visual mode
keymap("v", "H", "^", { desc = "Select to line start" })
keymap("v", "L", "g_", { desc = "Select to line end" })
-- Cyrillic
keymap("v", "Р", "^", opts)
keymap("v", "Д", "g_", opts)

---------------------------------------------------------------------------
-- Scroll screen without moving cursor: C-p / C-n
---------------------------------------------------------------------------
keymap("n", "<C-p>", "<C-e>", { desc = "Scroll down" })
keymap("n", "<C-n>", "<C-y>", { desc = "Scroll up" })

---------------------------------------------------------------------------
-- Resizing splits with arrow keys (with count support)
---------------------------------------------------------------------------
keymap("n", "<Up>", function()
	vim.cmd("resize +" .. vim.v.count1)
end, { desc = "Increase window height" })

keymap("n", "<Down>", function()
	vim.cmd("resize -" .. vim.v.count1)
end, { desc = "Decrease window height" })

keymap("n", "<Left>", function()
	vim.cmd("vertical resize +" .. vim.v.count1)
end, { desc = "Increase window width" })

keymap("n", "<Right>", function()
	vim.cmd("vertical resize -" .. vim.v.count1)
end, { desc = "Decrease window width" })

---------------------------------------------------------------------------
-- Clear search highlights with backslash
---------------------------------------------------------------------------
keymap("n", "\\", "<cmd>noh<cr>", { desc = "Clear search highlights" })

---------------------------------------------------------------------------
-- Fix: C-c doesn't trigger InsertLeave (for number toggle autocmd)
---------------------------------------------------------------------------
keymap("i", "<C-c>", "<C-c><cmd>set rnu<cr>", { desc = "Exit insert with relative numbers" })

---------------------------------------------------------------------------
-- Visual mode: don't yank when pasting over selection
---------------------------------------------------------------------------
keymap("x", "p", "P", { desc = "Paste without yanking" })
keymap("x", "P", "p", { desc = "Paste and yank" })

---------------------------------------------------------------------------
-- Move selection up/down in visual mode
---------------------------------------------------------------------------
keymap("x", "J", function()
	vim.cmd("'<,'>move '>+1")
	vim.cmd("normal! gv=gv")
end, { desc = "Move selection down" })

keymap("x", "K", function()
	vim.cmd("'<,'>move '<-2")
	vim.cmd("normal! gv=gv")
end, { desc = "Move selection up" })

keymap("x", "<C-j>", function()
	vim.cmd("'<,'>move '>+1")
	vim.cmd("normal! gv=gv")
end, { desc = "Move selection down" })

keymap("x", "<C-k>", function()
	vim.cmd("'<,'>move '<-2")
	vim.cmd("normal! gv=gv")
end, { desc = "Move selection up" })

---------------------------------------------------------------------------
-- Buffer tabs navigation: J/K cycle, g1-g9 go to buffer, m/M move
---------------------------------------------------------------------------
keymap("n", "J", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
keymap("n", "K", "<cmd>BufferLineCyclePrev<cr>", { desc = "Previous buffer" })

keymap("n", "m", "<cmd>BufferLineMoveNext<cr>", { desc = "Move buffer right" })
keymap("n", "M", "<cmd>BufferLineMovePrev<cr>", { desc = "Move buffer left" })

-- Go to buffer N with g1..g9
for i = 1, 9 do
	keymap("n", "g" .. i, "<cmd>BufferLineGoToBuffer " .. i .. "<cr>", { desc = "Go to buffer " .. i })
end

---------------------------------------------------------------------------
-- Add blank lines: <count><Leader>o / <count><Leader>O
---------------------------------------------------------------------------
keymap("n", "<Leader>o", "printf('m`%so<ESC>``', v:count1)", {
	expr = true,
	desc = "Insert line below",
})

keymap("n", "<Leader>O", "printf('m`%sO<ESC>``', v:count1)", {
	expr = true,
	desc = "Insert line above",
})

---------------------------------------------------------------------------
-- Emacs-style command line navigation
---------------------------------------------------------------------------
keymap("c", "<C-a>", "<Home>", { desc = "Go to start" })
keymap("c", "<C-b>", "<Left>", { desc = "Move left" })
keymap("c", "<C-d>", "<Del>", { desc = "Delete char" })
keymap("c", "<C-e>", "<End>", { desc = "Go to end" })
keymap("c", "<C-f>", "<Right>", { desc = "Move right" })
keymap("c", "<M-b>", "<S-Left>", { desc = "Move word left" })
keymap("c", "<M-f>", "<S-Right>", { desc = "Move word right" })
