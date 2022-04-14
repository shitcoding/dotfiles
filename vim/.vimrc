" #######################################################
"   Beginning of vim-plug plugins installation section
"          https://github.com/junegunn/vim-plug
" #######################################################
call plug#begin('~/.vim/plugged')

" Airline plugin
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Gruvbox Theme
Plug 'morhetz/gruvbox'

" NERDTree and related plugins
Plug 'preservim/nerdtree'
Plug 'ryanoasis/vim-devicons'  " Icons in NERDTree
Plug 'tiagofumo/vim-nerdtree-syntax-highlight' " Coloured files in NERDTree

" Warning: CoC and YCM autocompletion plugins are incompatible!
" YCM aka YouCompleteMe code completion plugin
Plug 'valloric/youcompleteme'

" CoC autocompletion plugin
" Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Syntax highlighting plugins
Plug 'sheerun/vim-polyglot'
Plug 'tomlion/vim-solidity'
Plug 'tridactyl/vim-tridactyl'

Plug 'jiangmiao/auto-pairs'

" https://vimawesome.com/plugin/targets-vim
Plug 'wellle/targets.vim'

" https://github.com/tpope/vim-surround
Plug 'tpope/vim-surround'
" https://github.com/tpope/vim-repeat
Plug 'tpope/vim-repeat'

" Emmet plugin
Plug 'mattn/emmet-vim'

" hex colors highlighting
Plug 'ap/vim-css-color'

" FuzzyFind
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

call plug#end()
" =======================================================
"      End of vim-plug plugins installation section
" =======================================================



" #######################################################
"                   Key Bindings Begin
" #######################################################

" H / L - go to the beginning/end of the line
nmap H ^
nmap L $

" Use <count>+arrow key to resize the split by <count> rows/columns
nnoremap <Up> :<C-U>exe ':resize +' . v:count1<CR><C-c>
nnoremap <Down> :<C-U>exe ':resize -' . v:count1<CR><C-c>
nnoremap <Left> :<C-U>exe ':vertical-resize +' . v:count1<CR><C-c>
nnoremap <Right> :<C-U>exe ':vertical-resize -' . v:count1<CR><C-c>


" TODO: lags when using o/O as usual - find another binging
" <count>oo / <count>OO - Add <count> blank lines (default=1)
" below/above the current line without entering insert mode
"nnoremap <expr> oo 'm`' . v:count1 . 'o<Esc>``'
"nnoremap <expr> OO 'm`' . v:count1 . 'O<Esc>``'


" Use Ctrl-hjkl keys to switch between splits
nnoremap <C-k> <C-w><Up>
nnoremap <C-j> <C-w><Down>
nnoremap <C-l> <C-w><Right>
nnoremap <C-h> <C-w><Left>

" Open NERDTree with Ctrl+n
map <C-n> :NERDTreeToggle<CR>

" Clear highlights on pressing `\` (backslash)
nnoremap \ :noh<CR>

" Copy to system clipboard with `Ctrl+Y`
vnoremap <C-Y> "+y

" =======================================================
"                   Key Bindings End
" =======================================================





" #######################################################
"                   General Settings Begin
" #######################################################
syntax on
filetype on
set number
highlight Normal ctermbg=None
highlight LineNr ctermfg=DarkGrey

" Fix issues with delete key in vim insert mode
set backspace=indent,eol,start

" Tabs settings for Python
set tabstop=4
set shiftwidth=4
set smarttab
set expandtab
set softtabstop=4 "4 spaces in tab

" Auto indent settings for HTML, Django templates, CSS files
autocmd FileType html setlocal shiftwidth=2 tabstop=2
autocmd FileType htmldjango setlocal shiftwidth=2 tabstop=2
autocmd FileType css setlocal shiftwidth=2 tabstop=2

" Turning off .swp and ~ (backup) files
set nobackup
set noswapfile
set encoding=utf-8 " Default encoding
set fileencodings=utf8,cp1251

set mousehide "Hide mouse cursor when typing
set mouse=a "Turn on mouse support

" --------------- Nerd Tree tuning --------------------
" Hide 'Press ? for help' text at the top of NERDTree
let NERDTreeMinimalUI = 1 

" Remove extra spacing between dir arrows and icons
let g:WebDevIconsNerdTreeBeforeGlyphPadding = ''

" Exit Vim if NERDTree is the only window remaining in the only tab.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
" ---------------------------------------------------

" ---------------- Persistent Undo ------------------
" Keep undo history across sessions, by storing in file.
if has('persistent_undo')
  silent !mkdir /tmp/.vim/backups > /dev/null 2>&1
  set undodir=/tmp/.vim/backups
  set undofile
endif
" ---------------------------------------------------


" Enable hotkeys for Russian layout
" https://github.com/vim/vim/blob/master/runtime/doc/russian.txt
set langmap=ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz


" ---------- YouCompleteMe plugin settings --------------
" Django autocompletion settings for YCM
" https://code.djangoproject.com/wiki/UsingVimWithDjango#YouCompleteMe
let g:ycm_collect_identifiers_from_tags_files = 1 " Let YCM read tags from Ctags file
let g:ycm_use_ultisnips_completer = 1 " Default 1, just ensure
let g:ycm_seed_identifiers_with_syntax = 1 " Completion for programming language's keyword
let g:ycm_complete_in_comments = 1 " Completion in comments
let g:ycm_complete_in_strings = 1 " Completion in string
" -------------------------------------------------------


" ---------- emmet-vim plugin settings ------------------
"  Expand tags with newline per tag
"  NOTE: it sucks because expands with newline all the time 
"let g:user_emmet_settings = {
"\  'html' : {
"\    'block_all_childless' : 1,
"\  },
"\}
" -------------------------------------------------------


" =======================================================
"                   General Settings End
" =======================================================





" #######################################################
"                   Styling Settings Begin
" #######################################################
colorscheme gruvbox
set background=dark
set termguicolors
let g:limelight_conceal_ctermfg = 240
let g:limelight_conceal_guifg = '#777777'
hi! Normal ctermbg=NONE guibg=NONE 
hi! NonText ctermbg=NONE guibg=NONE guifg=NONE ctermfg=NONE

let g:airline_powerline_fonts = 1
let g:airline_theme='minimalist'
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

" Customize fzf colors to match your color scheme
" - fzf#wrap translates this to a set of `--color` options
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

" Neovim/Vim True Color support 
if (empty($TMUX))
  if (has("nvim"))
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  if (has("termguicolors"))
    set termguicolors
  endif
endif

" =======================================================
"            Styling Settings End
" =======================================================



" NOTE: Disabled CoC and its' settings above as CoC and YCM
" are incompatible
"" -------------------------------------------------------
""            beginning of coc plugin settings
"" -------------------------------------------------------
"" Set internal encoding of vim, not needed on neovim, since coc.nvim using some
"" unicode characters in the file autoload/float.vim
"set encoding=utf-8
"
"" TextEdit might fail if hidden is not set.
"set hidden
"
"" Some servers have issues with backup files, see #649.
"set nobackup
"set nowritebackup
"
"" Give more space for displaying messages.
""set cmdheight=2    " [EDITED] Turned it off because it sucks
"
"" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
"" delays and poor user experience.
"set updatetime=300
"
"" Don't pass messages to |ins-completion-menu|.
"set shortmess+=c
"
"" Always show the signcolumn, otherwise it would shift the text each time
"" diagnostics appear/become resolved.
"if has("nvim-0.5.0") || has("patch-8.1.1564")
"  " Recently vim can merge signcolumn and number column into one
"  set signcolumn=number
"else
"  set signcolumn=yes
"endif
"
"" Use tab for trigger completion with characters ahead and navigate.
"" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
"" other plugin before putting this into your config.
"inoremap <silent><expr> <TAB>
"      \ pumvisible() ? "\<C-n>" :
"      \ <SID>check_back_space() ? "\<TAB>" :
"      \ coc#refresh()
"inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
"
"function! s:check_back_space() abort
"  let col = col('.') - 1
"  return !col || getline('.')[col - 1]  =~# '\s'
"endfunction
"
"" Use <c-space> to trigger completion.
"if has('nvim')
"  inoremap <silent><expr> <c-space> coc#refresh()
"else
"  inoremap <silent><expr> <c-@> coc#refresh()
"endif
"
"" Make <CR> auto-select the first completion item and notify coc.nvim to
"" format on enter, <cr> could be remapped by other vim plugin
"inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
"                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
"
"" Use `[g` and `]g` to navigate diagnostics
"" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
"nmap <silent> [g <Plug>(coc-diagnostic-prev)
"nmap <silent> ]g <Plug>(coc-diagnostic-next)
"
"" GoTo code navigation.
"nmap <silent> gd <Plug>(coc-definition)
"nmap <silent> gy <Plug>(coc-type-definition)
"nmap <silent> gi <Plug>(coc-implementation)
"nmap <silent> gr <Plug>(coc-references)
"
"" Use K to show documentation in preview window.
"nnoremap <silent> K :call <SID>show_documentation()<CR>
"
"function! s:show_documentation()
"  if (index(['vim','help'], &filetype) >= 0)
"    execute 'h '.expand('<cword>')
"  elseif (coc#rpc#ready())
"    call CocActionAsync('doHover')
"  else
"    execute '!' . &keywordprg . " " . expand('<cword>')
"  endif
"endfunction
"
"" Highlight the symbol and its references when holding the cursor.
"autocmd CursorHold * silent call CocActionAsync('highlight')
"
"" Symbol renaming.
"nmap <leader>rn <Plug>(coc-rename)
"
"" Formatting selected code.
"xmap <leader>f  <Plug>(coc-format-selected)
"nmap <leader>f  <Plug>(coc-format-selected)
"
"augroup mygroup
"  autocmd!
"  " Setup formatexpr specified filetype(s).
"  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
"  " Update signature help on jump placeholder.
"  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
"augroup end
"
"" Applying codeAction to the selected region.
"" Example: `<leader>aap` for current paragraph
"xmap <leader>a  <Plug>(coc-codeaction-selected)
"nmap <leader>a  <Plug>(coc-codeaction-selected)
"
"" Remap keys for applying codeAction to the current buffer.
"nmap <leader>ac  <Plug>(coc-codeaction)
"" Apply AutoFix to problem on the current line.
"nmap <leader>qf  <Plug>(coc-fix-current)
"
"" Map function and class text objects
"" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
"xmap if <Plug>(coc-funcobj-i)
"omap if <Plug>(coc-funcobj-i)
"xmap af <Plug>(coc-funcobj-a)
"omap af <Plug>(coc-funcobj-a)
"xmap ic <Plug>(coc-classobj-i)
"omap ic <Plug>(coc-classobj-i)
"xmap ac <Plug>(coc-classobj-a)
"omap ac <Plug>(coc-classobj-a)
"
"" Remap <C-f> and <C-b> for scroll float windows/popups.
"if has('nvim-0.4.0') || has('patch-8.2.0750')
"  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
"  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
"  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
"  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
"  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
"  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
"endif
"
"" Use CTRL-S for selections ranges.
"" Requires 'textDocument/selectionRange' support of language server.
"nmap <silent> <C-s> <Plug>(coc-range-select)
"xmap <silent> <C-s> <Plug>(coc-range-select)
"
"" Add `:Format` command to format current buffer.
"command! -nargs=0 Format :call CocAction('format')
"
"" Add `:Fold` command to fold current buffer.
"command! -nargs=? Fold :call     CocAction('fold', <f-args>)
"
"" Add `:OR` command for organize imports of the current buffer.
"command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')
"
"" Add (Neo)Vim's native statusline support.
"" NOTE: Please see `:h coc-status` for integrations with external plugins that
"" provide custom statusline: lightline.vim, vim-airline.
"set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}
"
"" Mappings for CoCList
"" Show all diagnostics.
"nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
"" Manage extensions.
"nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
"" Show commands.
"nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
"" Find symbol of current document.
"nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
"" Search workspace symbols.
"nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
"" Do default action for next item.
"nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
"" Do default action for previous item.
"nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
"" Resume latest coc list.
"nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>
"
"
"" -------------------------------------------------------
""               end of coc plugin settings
"" -------------------------------------------------------
