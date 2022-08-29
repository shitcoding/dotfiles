-- ###############################################################################################
-- ############################## General Settings ###############################################
-- ###############################################################################################

lvim.log.level = "warn"
lvim.format_on_save = true
lvim.colorscheme = "onedarker"
lvim.transparent_window = true

-- Enable hotkeys for Russian layout
-- https://github.com/vim/vim/blob/master/runtime/doc/russian.txt
vim.cmd("set langmap=ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz")



-- ###############################################################################################
-- ################################# Keymappings #################################################
-- ###############################################################################################
--                      [view all the defaults by pressing <leader>Lk]
lvim.leader = "space"
lvim.keys.normal_mode["<C-s>"] = ":w<cr>"

lvim.keys.normal_mode["<C-n>"] = ":NvimTreeToggle<cr>"

-- ##################### Keymappings migrated from .vimrc ########################################

-- H / L - go to the beginning/end of the line in normal mode
vim.api.nvim_set_keymap('n', 'H', '^', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'L', '$', { noremap = true, silent = true })

-- Same for Cyrillic layout
vim.api.nvim_set_keymap('n', 'Р', '^', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'Д', '$', { noremap = true, silent = true })

-- H / L - mark to the beginning/end (not including line break)
-- of the line in visual mode
vim.api.nvim_set_keymap('v', 'H', '^', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', 'L', 'g_', { noremap = true, silent = true })

-- Same for Cyrillic layout
vim.api.nvim_set_keymap('v', 'Р', '^', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', 'Д', 'g_', { noremap = true, silent = true })

------------------------- Resizing splits -----------------------
-- `<count>+arrow key` - resize the split by <count> rows/columns
vim.cmd([[
  nnoremap <Up> :<C-U>exe ':resize +' . v:count1<CR><C-c>
]])
vim.cmd([[
  nnoremap <Down> :<C-U>exe ':resize -' . v:count1<CR><C-c>
]])
vim.cmd([[
  nnoremap <Left> :<C-U>exe ':vertical-resize +' . v:count1<CR><C-c>
]])
vim.cmd([[
  nnoremap <Right> :<C-U>exe ':vertical-resize -' . v:count1<CR><C-c>
]])

-- `<Space> <Space>` - resize all splits to equal sizes
vim.cmd([[
  nnoremap <Leader><Leader> <C-w>=
]])
-- `<Space>+m` - resize current split to max height
vim.cmd([[
  nnoremap <Leader>m <C-w>_
]])
------------------------------------------------------------------

-- Clear search highlights on pressing `\` (backslash)
vim.api.nvim_set_keymap('n', '\\', ':noh<CR>', { noremap = true, silent = true })

-- Fix for vim-numbertoggle plugin not switching from absolute
-- to relative line numbers when leaving Insert mode with <Ctrl-c>
vim.api.nvim_set_keymap('i', '<C-c>', '<C-c>:set rnu<CR>', { noremap = true, silent = true })



------------------- Switching between tabs -----------------------
-- `g<num>` - Switch to tab number <num>
vim.api.nvim_set_keymap('n', 'g1', ':BufferLineGoToBuffer 1<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'g2', ':BufferLineGoToBuffer 2<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'g3', ':BufferLineGoToBuffer 3<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'g4', ':BufferLineGoToBuffer 4<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'g5', ':BufferLineGoToBuffer 5<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'g6', ':BufferLineGoToBuffer 6<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'g7', ':BufferLineGoToBuffer 7<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'g8', ':BufferLineGoToBuffer 8<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'g9', ':BufferLineGoToBuffer 9<CR>', { noremap = true, silent = true })

-- `<Space>+j` - Go to the next tab
vim.api.nvim_set_keymap('n', 'gt', ':BufferLineCycleNext<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>j', ':BufferLineCycleNext<CR>', { noremap = true, silent = true })

-- `<Space>+k` - Go to the previous tab
vim.api.nvim_set_keymap('n', 'gb', ':BufferLineCyclePrev<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>k', ':BufferLineCyclePrev<CR>', { noremap = true, silent = true })

-- `<Space>+h` - Go to the first tab
vim.api.nvim_set_keymap('n', '<Leader>h', ':BufferLineGoToBuffer 1<CR>', { noremap = true, silent = true })

---- `g$` / `<Space>+l` - Go to the last tab
--vim.cmd([[
--  nnoremap <silent> g$ :tablast<CR>
--  nnoremap <silent> <Leader>l :tablast<CR>
--]])
-- `gm` - Move current tab to the right
vim.api.nvim_set_keymap('n', 'gm', ':BufferLineMoveNext<CR>', { noremap = true, silent = true })
-- `gM` - Move current tab to the left
vim.api.nvim_set_keymap('n', 'gM', ':BufferLineMovePrev<CR>', { noremap = true, silent = true })
------------------------------------------------


-------------- Emacs-like shortcuts in command line mode ----------
---- start of line
--vim.api.nvim_set_keymap('c', '<C-a>', '<Home>', { noremap = true, silent = true })
---- back one character
--vim.api.nvim_set_keymap('c', '<C-b>', '<Left>', { noremap = true, silent = true })
---- delete character under cursor
--vim.api.nvim_set_keymap('c', '<C-b>', '<Del>', { noremap = true, silent = true })
---- end of line
--vim.api.nvim_set_keymap('c', '<C-e>', '<End>', { noremap = true, silent = true })
---- forward one character
---- Note / TODO: <C-f> remap below overrides standard mapping
---- for opening command-line window, maybe it's better not to do so.
--vim.api.nvim_set_keymap('c', '<C-f>', '<Right>', { noremap = true, silent = true })
---- back one word
--vim.api.nvim_set_keymap('c', '<M-b>', '<S-Left>', { noremap = true, silent = true })
---- forward one word
----:cnoremap <M-f>	<S-Right>
--vim.api.nvim_set_keymap('c', '<M-f>', '<S-Right>', { noremap = true, silent = true })
-------------------------------------------------------------------



-- unmap a default keymapping
-- vim.keymap.del("n", "<C-Up>")
-- override a default keymapping
-- lvim.keys.normal_mode["<C-q>"] = ":q<cr>" -- or vim.keymap.set("n", "<C-q>", ":q<cr>" )

-- Change Telescope navigation to use j and k for navigation and n and p for history in both input and normal mode.
-- we use protected-mode (pcall) just in case the plugin wasn't loaded yet.
local _, actions = pcall(require, "telescope.actions")
lvim.builtin.telescope.defaults.mappings = {
  -- for input mode
  i = {
    ["<C-j>"] = actions.move_selection_next,
    ["<C-k>"] = actions.move_selection_previous,
    ["<C-n>"] = actions.cycle_history_next,
    ["<C-p>"] = actions.cycle_history_prev,
  },
  -- for normal mode
  n = {
    ["<C-j>"] = actions.move_selection_next,
    ["<C-k>"] = actions.move_selection_previous,
  },
}

-- Use which-key to add extra bindings with the leader-key prefix
-- lvim.builtin.which_key.mappings["P"] = { "<cmd>Telescope projects<CR>", "Projects" }
-- lvim.builtin.which_key.mappings["t"] = {
--   name = "+Trouble",
--   r = { "<cmd>Trouble lsp_references<cr>", "References" },
--   f = { "<cmd>Trouble lsp_definitions<cr>", "Definitions" },
--   d = { "<cmd>Trouble document_diagnostics<cr>", "Diagnostics" },
--   q = { "<cmd>Trouble quickfix<cr>", "QuickFix" },
--   l = { "<cmd>Trouble loclist<cr>", "LocationList" },
--   w = { "<cmd>Trouble workspace_diagnostics<cr>", "Wordspace Diagnostics" },
-- }






-- TODO: User Config for predefined plugins
-- After changing plugin config exit and reopen LunarVim, Run :PackerInstall :PackerCompile
lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.notify.active = true
lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.setup.renderer.icons.show.git = false

-- if you don't want all the parsers change this to a table of the ones you want
lvim.builtin.treesitter.ensure_installed = {
  "bash",
  "c",
  "javascript",
  "json",
  "lua",
  "python",
  "typescript",
  "tsx",
  "css",
  "rust",
  "java",
  "yaml",
}

lvim.builtin.treesitter.ignore_install = { "haskell" }
lvim.builtin.treesitter.highlight.enabled = true






-- generic LSP settings

-- -- make sure server will always be installed even if the server is in skipped_servers list
-- lvim.lsp.installer.setup.ensure_installed = {
--     "sumeko_lua",
--     "jsonls",
-- }
-- -- change UI setting of `LspInstallInfo`
-- -- see <https://github.com/williamboman/nvim-lsp-installer#default-configuration>
-- lvim.lsp.installer.setup.ui.check_outdated_servers_on_open = false
-- lvim.lsp.installer.setup.ui.border = "rounded"
-- lvim.lsp.installer.setup.ui.keymaps = {
--     uninstall_server = "d",
--     toggle_server_expand = "o",
-- }

-- ---@usage disable automatic installation of servers
-- lvim.lsp.automatic_servers_installation = false

-- ---configure a server manually. !!Requires `:LvimCacheReset` to take effect!!
-- ---see the full default list `:lua print(vim.inspect(lvim.lsp.automatic_configuration.skipped_servers))`
-- vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "pyright" })
-- local opts = {} -- check the lspconfig documentation for a list of all possible options
-- require("lvim.lsp.manager").setup("pyright", opts)

-- ---remove a server from the skipped list, e.g. eslint, or emmet_ls. !!Requires `:LvimCacheReset` to take effect!!
-- ---`:LvimInfo` lists which server(s) are skipped for the current filetype
-- vim.tbl_map(function(server)
--   return server ~= "emmet_ls"
-- end, lvim.lsp.automatic_configuration.skipped_servers)

-- -- you can set a custom on_attach function that will be used for all the language servers
-- -- See <https://github.com/neovim/nvim-lspconfig#keybindings-and-completion>
-- lvim.lsp.on_attach_callback = function(client, bufnr)
--   local function buf_set_option(...)
--     vim.api.nvim_buf_set_option(bufnr, ...)
--   end
--   --Enable completion triggered by <c-x><c-o>
--   buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
-- end

-- -- set a formatter, this will override the language server formatting capabilities (if it exists)
-- local formatters = require "lvim.lsp.null-ls.formatters"
-- formatters.setup {
--   { command = "black", filetypes = { "python" } },
--   { command = "isort", filetypes = { "python" } },
--   {
--     -- each formatter accepts a list of options identical to https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md#Configuration
--     command = "prettier",
--     ---@usage arguments to pass to the formatter
--     -- these cannot contain whitespaces, options such as `--line-width 80` become either `{'--line-width', '80'}` or `{'--line-width=80'}`
--     extra_args = { "--print-with", "100" },
--     ---@usage specify which filetypes to enable. By default a providers will attach to all the filetypes it supports.
--     filetypes = { "typescript", "typescriptreact" },
--   },
-- }

-- -- set additional linters
-- local linters = require "lvim.lsp.null-ls.linters"
-- linters.setup {
--   { command = "flake8", filetypes = { "python" } },
--   {
--     -- each linter accepts a list of options identical to https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md#Configuration
--     command = "shellcheck",
--     ---@usage arguments to pass to the formatter
--     -- these cannot contain whitespaces, options such as `--line-width 80` become either `{'--line-width', '80'}` or `{'--line-width=80'}`
--     extra_args = { "--severity", "warning" },
--   },
--   {
--     command = "codespell",
--     ---@usage specify which filetypes to enable. By default a providers will attach to all the filetypes it supports.
--     filetypes = { "javascript", "python" },
--   },
-- }

-- Additional Plugins
-- lvim.plugins = {
--     {"folke/tokyonight.nvim"},
--     {
--       "folke/trouble.nvim",
--       cmd = "TroubleToggle",
--     },
-- }
lvim.plugins = {
  { "luisiacc/gruvbox-baby" },
  { "sainnhe/gruvbox-material" },
  -- Toggles between hybrid and absolute line numbers automatically
  -- NOTE: Add `set-option -g focus-events on` to .tmux.conf
  { "jeffkreeftmeijer/vim-numbertoggle" },
}

-- Autocommands (https://neovim.io/doc/user/autocmd.html)
-- vim.api.nvim_create_autocmd("BufEnter", {
--   pattern = { "*.json", "*.jsonc" },
--   -- enable wrap mode for json files only
--   command = "setlocal wrap",
-- })
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "zsh",
--   callback = function()
--     -- let treesitter use bash highlight for zsh files as well
--     require("nvim-treesitter.highlight").attach(0, "bash")
--   end,
-- })
