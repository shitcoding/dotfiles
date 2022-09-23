--################################################################################################
--############################### General Settings ###############################################
--################################################################################################

lvim.log.level = "warn"
lvim.format_on_save = true
lvim.transparent_window = true
vim.opt.cmdheight = 1 -- set command line height to 1 instead of 2
vim.opt.scrolloff = 0 -- make zt put the current line to the top of the window


--################################################################################################
--############################### Styling settings ###############################################
--################################################################################################
lvim.colorscheme = "vscode"
vim.cmd("au ColorScheme * hi LineNr guibg=NONE") -- transparent background of line numbers

-- Lualine settings
lvim.builtin.lualine.style = "default"
lvim.builtin.lualine.options.theme = "codedark"
lvim.builtin.lualine.sections.lualine_a = { "mode" }

-- Bufferline settings
lvim.builtin.bufferline.options.show_buffer_close_icons = false -- no tab close icons
-- lvim.builtin.bufferline.options.numbers = "ordinal" -- show tab numbers
lvim.builtin.bufferline.options.tab_size = 10 -- change tabs width from default 18 to 10



-- ###############################################################################################
-- ################################# Keymappings #################################################
-- ###############################################################################################
------------------------[view all the defaults by pressing <leader>Lk]----------------------------
-- unmap a default keymapping
-- vim.keymap.del("n", "<C-Up>")
-- override a default keymapping
-- lvim.keys.normal_mode["<C-q>"] = ":q<cr>" -- or vim.keymap.set("n", "<C-q>", ":q<cr>" )



-- Shorten the key mapping function and mapping options for convenience
local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }


lvim.leader = "space"
lvim.keys.normal_mode["<C-s>"] = ":w<cr>"

-- Enable hotkeys for Russian layout
vim.cmd("set langmap=ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz")

-- Remap LSP hover from K to gh to navigate between tabs with J / K
lvim.lsp.buffer_mappings.normal_mode["K"] = nil
keymap('n', 'gh', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)

-- Remap joining lines from J to gj to navigate between tabs with J / K
keymap('n', 'gj', 'J', opts)



-- H / L - go to the beginning/end of the line in normal mode
keymap('n', 'H', '^', opts)
keymap('n', 'L', '$', opts)

-- Same for Cyrillic layout
keymap('n', 'Р', '^', opts)
keymap('n', 'Д', '$', opts)

-- H / L - mark to the beginning/end (not including line break)
-- of the line in visual mode
keymap('v', 'H', '^', opts)
keymap('v', 'L', 'g_', opts)

-- Same for Cyrillic layout
keymap('v', 'Р', '^', opts)
keymap('v', 'Д', 'g_', opts)


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


------------------------------------------------------------------

-- Clear search highlights on pressing `\` (backslash)
keymap('n', '\\', ':noh<CR>', opts)

-- Fix for vim-numbertoggle plugin not switching from absolute
-- to relative line numbers when leaving Insert mode with <Ctrl-c>
keymap('i', '<C-c>', '<C-c>:set rnu<CR>', opts)


---------------- Visual mode customizing ---------------------------
-- Stay in visual mode after changing indent
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Don't paste replaced text after pasting some text on its' place
keymap("v", "p", '"_dP', opts)

-- Move text up and down in visual mode
keymap("v", "<C-j>", ":m .+1<CR>==", opts)
keymap("v", "<C-k>", ":m .-2<CR>==", opts)

-- Move text up and down in visual block mode
keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
keymap("x", "K", ":move '<-2<CR>gv-gv", opts)
keymap("x", "<C-j>", ":move '>+1<CR>gv-gv", opts)
keymap("x", "<C-k>", ":move '<-2<CR>gv-gv", opts)



------------------- Buffer tabs navigation -----------------------
-- `g<num>` - Switch to tab number <num>
keymap('n', 'g1', ':BufferLineGoToBuffer 1<CR>', opts)
keymap('n', 'g2', ':BufferLineGoToBuffer 2<CR>', opts)
keymap('n', 'g3', ':BufferLineGoToBuffer 3<CR>', opts)
keymap('n', 'g4', ':BufferLineGoToBuffer 4<CR>', opts)
keymap('n', 'g5', ':BufferLineGoToBuffer 5<CR>', opts)
keymap('n', 'g6', ':BufferLineGoToBuffer 6<CR>', opts)
keymap('n', 'g7', ':BufferLineGoToBuffer 7<CR>', opts)
keymap('n', 'g8', ':BufferLineGoToBuffer 8<CR>', opts)
keymap('n', 'g9', ':BufferLineGoToBuffer 9<CR>', opts)

-- J / K - Go to the next / previous tab
keymap('n', 'J', ':BufferLineCycleNext<CR>', opts)
keymap('n', 'K', ':BufferLineCyclePrev<CR>', opts)

-- `m` - Move current tab to the right
keymap('n', 'm', ':BufferLineMoveNext<CR>', opts)
-- `M` - Move current tab to the left
keymap('n', 'M', ':BufferLineMovePrev<CR>', opts)

---------------------------------------------------------------------

-- `<count><Space>o` / `<count><Space>O` - Add <count> blank lines (default=1)
-- Insert a blank line below or above current line (do not move the cursor),
-- see https://stackoverflow.com/a/16136133/6064933
vim.keymap.set("n", "<Leader>o", "printf('m`%so<ESC>``', v:count1)", {
  expr = true,
  desc = "insert line below",
})

vim.keymap.set("n", "<Leader>O", "printf('m`%sO<ESC>``', v:count1)", {
  expr = true,
  desc = "insert line above",
})



----------------------------------------------------------------------------------------------
--------------------------- Telescope key bindings -------------------------------------------
----------------------------------------------------------------------------------------------
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

-------------------------------------------------------------------------------------------
---------------------- Additional bindings for which-key plugin ---------------------------
-------------------------------------------------------------------------------------------
lvim.builtin.which_key.mappings["P"] = { "<cmd>Telescope projects<CR>", "Projects" }

-- trouble.nvim bindings
lvim.builtin.which_key.mappings["t"] = {
  name = "+Trouble",
  r = { "<cmd>Trouble lsp_references<cr>", "References" },
  f = { "<cmd>Trouble lsp_definitions<cr>", "Definitions" },
  d = { "<cmd>Trouble document_diagnostics<cr>", "Diagnostics" },
  q = { "<cmd>Trouble quickfix<cr>", "QuickFix" },
  l = { "<cmd>Trouble loclist<cr>", "LocationList" },
  w = { "<cmd>Trouble workspace_diagnostics<cr>", "Wordspace Diagnostics" },
}

-- persistence.nvim bindings
lvim.builtin.which_key.mappings["S"] = {
  name = "Session",
  c = { "<cmd>lua require('persistence').load()<cr>", "Restore last session for current dir" },
  l = { "<cmd>lua require('persistence').load({ last = true })<cr>", "Restore last session" },
  Q = { "<cmd>lua require('persistence').stop()<cr>", "Quit without saving session" },
}





--#########################################################################################
--####################### User Config for predefined plugins ##############################
--#########################################################################################
-- After changing plugin config exit and reopen LunarVim, Run :PackerInstall :PackerCompile

lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.notify.active = true
lvim.builtin.terminal.active = true

-- Nvim-Tree options
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.setup.renderer.icons.show.git = true
lvim.builtin.nvimtree.setup.renderer.indent_markers.enable = true
lvim.builtin.nvimtree.setup.view.number = true
lvim.builtin.nvimtree.setup.view.relativenumber = true
lvim.builtin.nvimtree.setup.filters.dotfiles = true



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






--#########################################################################################
--############################## generic LSP settings #####################################
--#########################################################################################

-- make sure server will always be installed even if the server is in skipped_servers list
lvim.lsp.installer.setup.ensure_installed = {
  "sumeko_lua",
  "jsonls",
}
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

---configure a server manually. !!Requires `:LvimCacheReset` to take effect!!
---see the full default list `:lua print(vim.inspect(lvim.lsp.automatic_configuration.skipped_servers))`
--vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "pyright" }) -- disable autoinstallation of pyright
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

-- set a formatter, this will override the language server formatting capabilities (if it exists)
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  {
    command = "black",
    filetypes = { "python" },
    extra_args = { "--line-length=79" }
  },
  { command = "isort", filetypes = { "python" } },
  --  {
  --    -- each formatter accepts a list of options identical to https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md#Configuration
  --    command = "prettier",
  --    ---@usage arguments to pass to the formatter
  --    -- these cannot contain whitespaces, options such as `--line-width 80` become either `{'--line-width', '80'}` or `{'--line-width=80'}`
  --    extra_args = { "--print-with", "100" },
  --    ---@usage specify which filetypes to enable. By default a providers will attach to all the filetypes it supports.
  --    filetypes = { "typescript", "typescriptreact" },
  --  },
}

-- set additional linters
local linters = require "lvim.lsp.null-ls.linters"
linters.setup {
  { command = "flake8", filetypes = { "python" } },
  --  {
  --    -- each linter accepts a list of options identical to https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md#Configuration
  --    command = "shellcheck",
  --    ---@usage arguments to pass to the formatter
  --    -- these cannot contain whitespaces, options such as `--line-width 80` become either `{'--line-width', '80'}` or `{'--line-width=80'}`
  --    extra_args = { "--severity", "warning" },
  --  },
  --  {
  --    command = "codespell",
  --    ---@usage specify which filetypes to enable. By default a providers will attach to all the filetypes it supports.
  --    filetypes = { "javascript", "python" },
  --  },
}



--#########################################################################################
--############################## User Installed Plugins ###################################
--#########################################################################################

lvim.plugins = {
  -- Toggles between hybrid and absolute line numbers automatically
  -- NOTE: Add `set-option -g focus-events on` to .tmux.conf if you're using Tmux
  { "jeffkreeftmeijer/vim-numbertoggle" },
  { "Mofiqul/vscode.nvim" }, -- vscode colorscheme
  { "wellle/targets.vim" },
  { "tpope/vim-surround" },
  { "tpope/vim-repeat" },
  { "mattn/emmet-vim" },
  {
    "folke/persistence.nvim", -- saving sessions for each directory
    event = "BufReadPre", -- this will only start session saving when an actual file was opened
    module = "persistence",
    config = function()
      require("persistence").setup {
        dir = vim.fn.expand(vim.fn.stdpath "config" .. "/session/"),
        options = { "buffers", "curdir", "tabpages", "winsize" },
      }
    end,
  },
  { "folke/trouble.nvim" },
  {
    "norcalli/nvim-colorizer.lua", -- hex color codes colorizer
    config = function()
      require("colorizer").setup({ "css", "scss", "html", "javascript", "tmux" }, {
        RGB = true, -- #RGB hex codes
        RRGGBB = true, -- #RRGGBB hex codes
        RRGGBBAA = true, -- #RRGGBBAA hex codes
        rgb_fn = true, -- CSS rgb() and rgba() functions
        hsl_fn = true, -- CSS hsl() and hsla() functions
        css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
        css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
      })
    end,
  },
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
