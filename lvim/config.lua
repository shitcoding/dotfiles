--################################################################################################
--############################### General Settings ###############################################
--################################################################################################

lvim.log.level = "warn"
lvim.transparent_window = true
vim.opt.cmdheight = 1 -- set command line height to 1 instead of 2
vim.opt.scrolloff = 0 -- make zt put the current line to the top of the window
vim.opt.timeoutlen = 50




--------------------------------------------------------------------------------------------------
------------------------------ Helper functions, shortcuts, etc ----------------------------------
--------------------------------------------------------------------------------------------------

-- Shorten the key mapping function and mapping options for convenience
local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Helper function to get shell output
local function get_shell_command_output(command)
  local handle = io.popen(command)
  local output = handle:read("*a")
  handle:close()
  return output and vim.trim(output) or nil
end





--################################################################################################
--############################### Styling settings ###############################################
--################################################################################################
lvim.colorscheme = "vscode"
vim.cmd("au ColorScheme * hi LineNr guibg=NONE") -- transparent background of line numbers

-- Lualine settings ------------------------------------------------------------------------------
lvim.builtin.lualine.style = "default"
lvim.builtin.lualine.sections.lualine_a = { "mode" }
-- show relative path instead of just filename
lvim.builtin.lualine.sections.lualine_c = { { "filename", path = 1, } }
lvim.builtin.lualine.inactive_sections.lualine_c = { { "filename", path = 1, } }
lvim.builtin.lualine.options.globalstatus = false
lvim.builtin.lualine.options.disabled_filetypes = { 'lazy', 'NvimTree' }

-- Bufferline settings ---------------------------------------------------------------------------
lvim.builtin.bufferline.options.show_buffer_close_icons = false -- no tab close icons
lvim.builtin.bufferline.options.tab_size = 10                   -- change tabs width from default 18 to 10





-- ###############################################################################################
-- ################################# Keymappings #################################################
-- ###############################################################################################

------------------------[view all the defaults by pressing <leader>Lk]----------------------------
-- unmap a default keymapping
-- vim.keymap.del("n", "<C-Up>")
-- override a default keymapping
-- lvim.keys.normal_mode["<C-q>"] = ":q<cr>" -- or vim.keymap.set("n", "<C-q>", ":q<cr>" )


-- Set Space as a Leader key
lvim.leader = "space"

-- Save file with Ctrl-S
lvim.keys.normal_mode["<C-s>"] = ":w<cr>"

-- Enable hotkeys for Russian layout
vim.cmd(
  "set langmap=ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz")

-- Remap LSP hover popup menu from K to gh to navigate between tabs with J / K
lvim.lsp.buffer_mappings.normal_mode["K"] = nil
keymap('n', 'gh', '<cmd>lua vim.lsp.buf.hover()<CR>', { noremap = true, silent = true, desc = "LSP Hover" })

-- Remap joining lines from J to gj to navigate between tabs with J / K
keymap('n', 'gj', 'J', { noremap = true, silent = true, desc = "Join lines" })

-- Remap adding mark from `m` to `<Leader> m` to move tabs left / right with m / M
keymap('n', '<Leader>m', 'm', { noremap = true, silent = true, desc = "Add mark" })



-- H / L - go to the beginning/end of the line in normal mode
keymap('n', 'H', '^', { noremap = true, silent = true, desc = "Go to line start" })
keymap('n', 'L', '$', { noremap = true, silent = true, desc = "Go to line end" })

-- Same for Cyrillic layout
keymap('n', 'Р', '^', opts)
keymap('n', 'Д', '$', opts)

-- H / L - mark to the beginning/end (not including line break)
-- of the line in visual mode
keymap('v', 'H', '^', { noremap = true, silent = true, desc = "Select to line start" })
keymap('v', 'L', 'g_', { noremap = true, silent = true, desc = "Select to line end" })

-- Same for Cyrillic layout
keymap('v', 'Р', '^', opts)
keymap('v', 'Д', 'g_', opts)

-- Override mappings for moving screen one line up/down w/o moving the cursor
lvim.keys.normal_mode["<C-p>"] = "<C-e>"
lvim.keys.normal_mode["<C-n>"] = "<C-y>"




-------------------------------------------------------------------------
----------------------------- Resizing splits ---------------------------
-------------------------------------------------------------------------
-- `<count>+arrow key` - resize the split by <count> rows/columns
vim.cmd([[
  nnoremap <Up> :<C-U>exe ':resize +' . v:count1<CR><C-c>
]])

vim.cmd([[
  nnoremap <Down> :<C-U>exe ':resize -' . v:count1<CR><C-c>
]])

vim.cmd([[
 nnoremap <Left> :<C-U>exe ':vertical resize +' . v:count1<CR><C-c>
]])

vim.cmd([[
  nnoremap <Right> :<C-U>exe ':vertical resize -' . v:count1<CR><C-c>
]])
------------------------------------------------------------------



-- Clear search highlights on pressing `\` (backslash)
keymap('n', '\\', ':noh<CR>', { noremap = true, silent = true, desc = "Clear search highlights" })


-- Fix for vim-numbertoggle plugin not switching from absolute
-- to relative line numbers when leaving Insert mode with <Ctrl-c>
keymap('i', '<C-c>', '<C-c>:set rnu<CR>', { noremap = true, silent = true, desc = "Exit insert with relative numbers" })


----------------------------------------------------------------------------
--------------------- Visual mode customizing ------------------------------
----------------------------------------------------------------------------
-- Stay in visual mode after changing indent with `<` / `>`
keymap("v", "<", "<gv", { noremap = true, silent = true, desc = "Indent left" })
keymap("v", ">", ">gv", { noremap = true, silent = true, desc = "Indent right" })


-- Don't paste replaced text after pasting some text on its' place
lvim.keys.visual_block_mode = {
  ["p"] = "P",
  ["P"] = "p",
}

-- Move selected text up and down in visual mode
keymap("v", "<C-j>", ":m .+1<CR>==", { noremap = true, silent = true, desc = "Move line down" })
keymap("v", "<C-k>", ":m .-2<CR>==", { noremap = true, silent = true, desc = "Move line up" })

-- Move selected text up and down in visual block mode
keymap("x", "J", ":move '>+1<CR>gv-gv", { noremap = true, silent = true, desc = "Move selection down" })
keymap("x", "K", ":move '<-2<CR>gv-gv", { noremap = true, silent = true, desc = "Move selection up" })
keymap("x", "<C-j>", ":move '>+1<CR>gv-gv", { noremap = true, silent = true, desc = "Move selection down" })
keymap("x", "<C-k>", ":move '<-2<CR>gv-gv", { noremap = true, silent = true, desc = "Move selection up" })



------------------------------------------------------------------------
---------------------- Buffer tabs navigation --------------------------
------------------------------------------------------------------------
-- `g<num>` - Switch to tab number <num>
keymap('n', 'g1', ':BufferLineGoToBuffer 1<CR>', { noremap = true, silent = true, desc = "Go to buffer 1" })
keymap('n', 'g2', ':BufferLineGoToBuffer 2<CR>', { noremap = true, silent = true, desc = "Go to buffer 2" })
keymap('n', 'g3', ':BufferLineGoToBuffer 3<CR>', { noremap = true, silent = true, desc = "Go to buffer 3" })
keymap('n', 'g4', ':BufferLineGoToBuffer 4<CR>', { noremap = true, silent = true, desc = "Go to buffer 4" })
keymap('n', 'g5', ':BufferLineGoToBuffer 5<CR>', { noremap = true, silent = true, desc = "Go to buffer 5" })
keymap('n', 'g6', ':BufferLineGoToBuffer 6<CR>', { noremap = true, silent = true, desc = "Go to buffer 6" })
keymap('n', 'g7', ':BufferLineGoToBuffer 7<CR>', { noremap = true, silent = true, desc = "Go to buffer 7" })
keymap('n', 'g8', ':BufferLineGoToBuffer 8<CR>', { noremap = true, silent = true, desc = "Go to buffer 8" })
keymap('n', 'g9', ':BufferLineGoToBuffer 9<CR>', { noremap = true, silent = true, desc = "Go to buffer 9" })

-- J / K - Go to the next / previous tab
keymap('n', 'J', ':BufferLineCycleNext<CR>', { noremap = true, silent = true, desc = "Next buffer" })
keymap('n', 'K', ':BufferLineCyclePrev<CR>', { noremap = true, silent = true, desc = "Previous buffer" })

-- `m` - Move current tab to the right
keymap('n', 'm', ':BufferLineMoveNext<CR>', { noremap = true, silent = true, desc = "Move buffer right" })
-- `M` - Move current tab to the left
keymap('n', 'M', ':BufferLineMovePrev<CR>', { noremap = true, silent = true, desc = "Move buffer left" })



---------------------------------------------------------------------
------------------ DIRTY BUT COOL HACKS ZONE ------------------------
---------------------------------------------------------------------

-- `<count><Space>o` / `<count><Space>O` - Add <count> blank lines (default=1)
-- Insert a blank line below / above current line (not moving the cursor),
-- see https://stackoverflow.com/a/16136133/6064933
vim.keymap.set("n", "<Leader>o", "printf('m`%so<ESC>``', v:count1)", {
  expr = true,
  desc = "insert line below",
})

vim.keymap.set("n", "<Leader>O", "printf('m`%sO<ESC>``', v:count1)", {
  expr = true,
  desc = "insert line above",
})



---------------------------------------------------------------------
-------------- Emacs-like shortcuts in command line mode ------------
---------------------------------------------------------------------
-- go to start of line
vim.cmd("cnoremap <C-a> <Home>")
-- go back one character
vim.cmd("cnoremap <C-b> <Left>")
-- delete character under cursor
vim.cmd("cnoremap <C-d>	<Del>")
-- go to end of line
vim.cmd("cnoremap <C-e>	<End>")
-- go forward one character
-- [Note / TODO]: <C-f> remap below overrides standard mapping
-- for opening command-line window, maybe it's better not to do so.
vim.cmd("cnoremap <C-f>	<Right>")
-- go back one word
vim.cmd("cnoremap <M-b>	<S-Left>")
-- go forward one word
vim.cmd("cnoremap <M-f>	<S-Right>")



--############################################################################################
--####################### Plugin related key bindings ########################################
--############################################################################################

----------------------------------------------------------------------------------------------
--------------------------- Telescope key bindings -------------------------------------------
----------------------------------------------------------------------------------------------
-- Change Telescope navigation to use j and k for navigation and n and p for history
-- in both input and normal mode.
local actions_ok, actions = pcall(require, "telescope.actions")
if actions_ok then
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
end




-------------------------------------------------------------------------------------------
---------------------- Additional bindings for which-key plugin ---------------------------
-------------------------------------------------------------------------------------------
lvim.builtin.which_key.mappings["P"] = { "<cmd>Telescope projects<CR>", "Projects" }

-- Buffer view/settings bindings
lvim.builtin.which_key.mappings["v"] = {
  name = "+View",
  w = { "<cmd>set wrap!<cr>", "Toggle line wrap" },
}

lvim.builtin.which_key.mappings.l['R'] = { "<cmd>LspRestart<CR>", "Restart LSP" }

-- Telescope bindings
lvim.builtin.which_key.mappings["t"] = {
  name = "+Telescope",
  l = { "<cmd>Telescope live_grep<cr>", "Live grep" },
  g = { ":execute 'Telescope live_grep default_text=' . expand('<cword>')<cr>", "Grep word under cursor" },
  s = { "<cmd>Telescope search_history<cr>", "Search history" },
  f = { "<cmd>Telescope find_files<cr>", "Find files" },
  c = { "<cmd>Telescope command_history<cr>", "Command history" },
  j = { "<cmd>Telescope jumplist<cr>", "Jumplist" },
}

-- spectre bindings
lvim.builtin.which_key.mappings["r"] = {
  name = "+Spectre",
  r = { "<cmd>lua require('spectre').toggle()<CR>", "Toggle Spectre" },
  w = { "<cmd>lua require('spectre').open_visual({select_word=true})<CR>", "Search current word" },
  f = { "<cmd>lua require('spectre').open_file_search({select_word=true})<CR>", "Search on current file" },
}

-- trouble.nvim bindings (v3 syntax)
lvim.builtin.which_key.mappings["T"] = {
  name = "+Trouble",
  r = { "<cmd>Trouble lsp_references toggle<cr>", "References" },
  f = { "<cmd>Trouble lsp_definitions toggle<cr>", "Definitions" },
  d = { "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", "Buffer Diagnostics" },
  w = { "<cmd>Trouble diagnostics toggle<cr>", "Workspace Diagnostics" },
  q = { "<cmd>Trouble qflist toggle<cr>", "QuickFix" },
  l = { "<cmd>Trouble loclist toggle<cr>", "LocationList" },
}

-- persistence.nvim bindings
lvim.builtin.which_key.mappings["S"] = {
  name = "Session",
  c = { "<cmd>lua require('persistence').load()<cr>", "Restore last session for current dir" },
  l = { "<cmd>lua require('persistence').load({ last = true })<cr>", "Restore last session" },
  Q = { "<cmd>lua require('persistence').stop()<cr>", "Quit without saving session" },
}

---------------------------------------------------------------------
------ Live grep selected text in visual mode with `<Leader>g` ------
---------------------------------------------------------------------
function vim.getVisualSelection() -- Helper function to get selected text
  vim.cmd('noau normal! "vy"')
  local text = vim.fn.getreg('v')
  vim.fn.setreg('v', {})

  text = string.gsub(text, "\n", "")
  if #text > 0 then
    return text
  else
    return ''
  end
end

local tb = require('telescope.builtin')

-- which-key binding for `<Leader>g` in visual mode
lvim.builtin.which_key.vmappings['g'] = {
  function()
    local text = vim.getVisualSelection()
    tb.live_grep({ default_text = text })
  end,
  "Live grep selected text"
}
---------------------------------------------------------------------



-------------------------------------------------------------------------------------------




--#########################################################################################
--############################## Plugins config ###########################################
--#########################################################################################


--=========================================================================================
--=================== User Config for Lvim preinstalled plugins ===========================
--=========================================================================================

lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.terminal.active = true -- enable builtin terminal (`Ctrl+\` to toggle)

-- Disable vim-illuminate due to none-ls compatibility issues with Neovim 0.11+
lvim.builtin.illuminate.active = false


-- Nvim-Tree options
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.setup.renderer.icons.show.git = true
lvim.builtin.nvimtree.setup.renderer.indent_markers.enable = true
lvim.builtin.nvimtree.setup.view.number = true
lvim.builtin.nvimtree.setup.view.relativenumber = true
lvim.builtin.nvimtree.setup.filters.dotfiles = true
lvim.builtin.nvimtree.setup.filters.custom = { ".git", ".cache", "__pycache__" }
-- Fix for nvim-tree conflict with project.nvim plugin // NOTE: It fucks up cwd in nvim-tree - disabling by now
lvim.builtin.nvimtree.setup.respect_buf_cwd = true
-- lvim.builtin.nvimtree.setup.sync_root_with_cwd = true
-- lvim.builtin.nvimtree.setup.update_focused_file.enable = true
-- lvim.builtin.nvimtree.setup.update_focused_file.update_root = true
lvim.builtin.project.manual_mode = true

-- Fix for indent-blankline error with markdown files
lvim.builtin.indentlines.options.filetype_exclude = vim.list_extend(
  lvim.builtin.indentlines.options.filetype_exclude or {},
  { "markdown" }
)




--=========================================================================================
--============================== User Installed Plugins ===================================
--=========================================================================================

lvim.plugins = {
  -- vim-numbertoggle: Toggles between hybrid and absolute line numbers automatically
  -- NOTE: Add `set-option -g focus-events on` to .tmux.conf if you're using Tmux
  { "jeffkreeftmeijer/vim-numbertoggle" },
  -- Autoinstall LSPs/linters/formatters from predefined list via Mason
  { "WhoIsSethDaniel/mason-tool-installer.nvim" },
  { "Mofiqul/vscode.nvim" }, -- vscode colorscheme
  { "wellle/targets.vim" },
  { "tpope/vim-surround" },
  { "tpope/vim-repeat" },
  { "mattn/emmet-vim" },
  -- persistence.nvim: Save nvim sessions automatically
  {
    "folke/persistence.nvim",
    event = "BufReadPre", -- this will only start session saving when an actual file was opened
    -- module = "persistence",
    config = function()
      require("persistence").setup {
        dir = vim.fn.expand(vim.fn.stdpath "config" .. "/session/"),
        options = { "buffers", "curdir", "tabpages", "winsize" },
      }
    end,
  },
  -- A pretty diagnostics, references, telescope results, quickfix and location list
  { "folke/trouble.nvim" },
  -- hex color codes colorizer (using maintained fork)
  {
    "NvChad/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup({
        filetypes = { "css", "scss", "html", "javascript", "tmux" },
        user_default_options = {
          RGB = true,      -- #RGB hex codes
          RRGGBB = true,   -- #RRGGBB hex codes
          RRGGBBAA = true, -- #RRGGBBAA hex codes
          rgb_fn = true,   -- CSS rgb() and rgba() functions
          hsl_fn = true,   -- CSS hsl() and hsla() functions
          css = true,      -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
          css_fn = true,   -- Enable all CSS *functions*: rgb_fn, hsl_fn
        },
      })
    end,
  },
  -- Python extension for nvim-dap
  "mfussenegger/nvim-dap-python",
  -- -- Python Venv Selector
  -- {
  --   "linux-cultist/venv-selector.nvim",
  --   dependencies = {
  --     "neovim/nvim-lspconfig",
  --     "nvim-telescope/telescope.nvim",
  --     -- for DAP support
  --     "mfussenegger/nvim-dap-python"
  --   },
  --   config = true,
  --   opts = {
  --     search_workspace = false,
  --     search = true,
  --     dap_enabled = false,
  --     name = { ".venv" },
  --     fd_binary_name = "fd",
  --     notify_user_on_activate = true,

  --   },
  --   event = "VeryLazy", -- Optional: needed only if you want to type `:VenvSelect` without a keymapping
  -- },
  ----------------------------------------------------------------
  -- nvim-spectre: Search and replace plugin
  {
    "windwp/nvim-spectre",
    event = "BufRead",
    config = function()
      require('spectre').setup({
        color_devicons = true,
        highlight      = {
          ui = "String",
          search = "DiffChange",
          replace = "DiffAdd"
        },
      })
    end,
  },
}




--====================================================================
--=========== Additional config for user installed plugins ===========
--====================================================================

--------------------- mason-tool-installer setup ---------------------
-- require('mason-tool-installer').setup {
--   ensure_installed = {
--     'bash-language-server',
--     'dockerfile-language-server',
--     'vim-language-server',
--     'yaml-language-server',
--     'stylua',
--     'shellcheck',
--     'editorconfig-checker',
--     'pyright',
--     'flake8',
--     'black',
--     'blue',
--     'debugpy',
--     'css-lsp',
--   },
--   auto_update = true,
-- }






--#########################################################################################
--############# Autocommands (https://neovim.io/doc/user/autocmd.html) ####################
--#########################################################################################

-- Reload LunarVim config after launch, required for some keybindings/hacks to work
-- (e.g., <Leader>o/<Leader>O for adding blank lines)
vim.api.nvim_create_autocmd("VimEnter", {
  command = "LvimReload",
})


-- -- Disable Copilot on Neovim startup
-- vim.api.nvim_create_autocmd("VimEnter", {
--   command = "Copilot disable",
-- })

-- set filetype to SQL for .ddl files
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = { "*.ddl" },
  command = "setfiletype sql",
})

-- Other examples of autocommands usage:
-- vim.api.nvim_create_autocmd("BufEnter", {
--   pattern = { "*.json", "*.jsonc" },
--   -- enable wrap mode for json files only
--   command = "setlocal wrap",
-- })
--
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "zsh",
--   callback = function()
--     -- let treesitter use bash highlight for zsh files as well
--     require("nvim-treesitter.highlight").attach(0, "bash")
--   end,
-- })






--###########################################################################################
--############################# LSP, linters, DAP settings ##################################
--###########################################################################################


---------------------------------------------------------------------------------------------
------------------------------- Treesitter / LSP config -------------------------------------
---------------------------------------------------------------------------------------------
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
  "html",
  "rust",
  "java",
  "yaml",
  "toml",
  "markdown",
  "markdown_inline",
  "regex",
  "vim",
  "vimdoc",
}

lvim.builtin.treesitter.ignore_install = { "haskell" }
lvim.builtin.treesitter.highlight.enabled = true

-- Disable treesitter highlighting for markdown to fix "Invalid 'end_col': out of range" error
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown" },
  callback = function()
    vim.treesitter.stop()
  end,
})

-- -- make sure server will always be installed even if the server is in skipped_servers list
-- lvim.lsp.installer.setup.ensure_installed = {
--   "lua_ls",
--   "jsonls",
-- }

-- ---@usage disable automatic installation of servers
-- lvim.lsp.automatic_servers_installation = false

---configure a server manually. !!Requires `:LvimCacheReset` to take effect!!
---see the full default list `:lua print(vim.inspect(lvim.lsp.automatic_configuration.skipped_servers))`
--vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "pyright" }) -- disable autoinstallation of pyright
-- local opts = {} -- check the lspconfig documentation for a list of all possible options
-- require("lvim.lsp.manager").setup("pyright", opts)

--##################################################################################################
--####################################### Python LSP setup #########################################
--##################################################################################################

-------------------- Pyright setup -----------------------------------------------------------------
require("lspconfig").pyright.setup {
  settings = {
    python = {
      analysis = {
        typeCheckingMode = "off",
      }
    }
  }
}

-- NOTE: Disabling by now, don't know how to use ruff-lsp together with pyright
-- -------------------- Ruff-lsp setup -----------------------------------------------------------------
-- -- remove `ruff_lsp` from `skipped_servers` list
-- lvim.lsp.automatic_configuration.skipped_servers = vim.tbl_filter(function(server)
--   return server ~= "ruff_lsp"
-- end, lvim.lsp.automatic_configuration.skipped_servers)
-- -- See: https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#ruff_lsp
-- -- For the default config, along with instructions on how to customize the settings
-- local on_attach = function(client, bufnr)
--   -- Disable hover in favor of Pyright
--   client.server_capabilities.hoverProvider = false
-- end

-- require('lspconfig').ruff_lsp.setup {
--   on_attach = on_attach,
--   init_options = {
--     settings = {
--       -- Any extra CLI arguments for `ruff` go here.
--       args = {},
--     }
--   }
-- }


--##################################################################################################
--######################################## SQL LSP setup ###########################################
--##################################################################################################
-- -- (requires some dirty hacks / black magic)
-- -- https://github.com/LunarVim/LunarVim/discussions/4210#discussioncomment-6083169
-- lvim.lsp.automatic_configuration.skipped_servers = vim.tbl_filter(function(server)
--   return server ~= "sqlls"
-- end, lvim.lsp.automatic_configuration.skipped_servers)

-- require("lvim.lsp.manager").setup("sqlls", {
--   cmd = { "sql-language-server", "up", "--method", "stdio" },
--   filetypes = { "sql", "mysql", "ddl" },
--   root_dir = function() return vim.loop.cwd() end,
-- })
--------------------------------------------------------------



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



---------------------------------------------------------------------------------------------
---------------------------------- Formatters config ----------------------------------------
---------------------------------------------------------------------------------------------
-- NOTE: Disabled due to none-ls incompatibility with Neovim 0.11+
-- Re-enable once LunarVim updates none-ls or switches to conform.nvim/nvim-lint
-- local formatters = require "lvim.lsp.null-ls.formatters"
-- formatters.setup {
--   { command = "blue", filetypes = { "python" } },
--   { command = "isort", filetypes = { "python" } },
-- }



---------------------------------------------------------------------------------------------
----------------------------------- Linters config ------------------------------------------
---------------------------------------------------------------------------------------------
-- NOTE: Disabled due to none-ls incompatibility with Neovim 0.11+
-- local linters = require "lvim.lsp.null-ls.linters"
-- linters.setup {
--   {
--     command = "flake8",
--     filetypes = { "python" },
--     prefer_local = ".venv/bin"
--   },
-- }



---------------------------------------------------------------------------------------------
------------------------------------- DAP config ------------------------------------------
---------------------------------------------------------------------------------------------
-- Setup dap for python
lvim.builtin.dap.active = true
local mason_path = vim.fn.stdpath("data") .. "/mason/"

-- Setup Python DAP with proper error handling
local dap_python_ok, dap_python = pcall(require, "dap-python")
if dap_python_ok then
  dap_python.setup(mason_path .. "packages/debugpy/venv/bin/python")
  -- Supported test frameworks are unittest, pytest and django. By default it
  -- tries to detect the runner by probing for pytest.ini and manage.py, if
  -- neither are present it defaults to unittest.
  dap_python.test_runner = "pytest"
else
  vim.notify("dap-python not installed. Install via :Mason", vim.log.levels.WARN)
end
