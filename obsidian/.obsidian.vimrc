" .obsidian.vimrc config for Obsidian Vim mode
" Note: Needs this plugin in order to work:
" https://github.com/esm7/obsidian-vimrc-support



"""""""""""""""""""""" Various mappings """""""""""""""""""""
" Unmap Space to use as a leader key
unmap <Space>

" H and L to go to the beginning/end of line
nmap H ^
nmap L $
vmap H ^
vmap L $

" Quickly remove search highlights
nmap \ :nohl<CR>


" Yank to system clipboard
set clipboard=unnamed

" Scroll viewport one line with Ctrl-p/n (like Ctrl-y/e)
nmap <C-p> <C-y>
nmap <C-n> <C-e>

" gj - Join the current line with the line beyond with a space in between
noremap gj J

" Switch tabs in normal mode with J / K
unmap J
exmap nexttab obcommand workspace:next-tab
exmap prevtab obcommand workspace:previous-tab
nmap J :nexttab<CR>
nmap K :prevtab<CR>

" Close the current tab with ZZ / ZQ
exmap closetab obcommand workspace:close
nmap ZZ :closetab<CR>
nmap ZQ :closetab<CR>


" Reload Obsidian
exmap reload_obsidian obcommand app:reload
map <A-r> :reload_obsidian<CR>
map <A-к> :reload_obsidian<CR>


" Surround text (like with vim-surround plugin)
" NOTE: must use 'map' and not 'nmap'
exmap surround_double_quotes surround " "
exmap surround_single_quotes surround ' '
exmap surround_backtick surround ` `
exmap surround_brackets surround ( )
exmap surround_square_brackets surround [ ]
exmap surround_curly_brackets surround { }
exmap surround_superscript surround <sup> </sup>
exmap surround_subscript surround <sub> </sub>

nunmap S
vunmap S
map S" :surround_double_quotes<CR>
map S' :surround_single_quotes<CR>
map S` :surround_backtick<CR>
map Sb :surround_brackets<CR>
map S( :surround_brackets<CR>
map S) :surround_brackets<CR>
map S[ :surround_square_brackets<CR>
map S] :surround_square_brackets<CR>
map S{ :surround_curly_brackets<CR>
map S} :surround_curly_brackets<CR>
map S^ :surround_superscript<CR>
map S_ :surround_subscript<CR>

"""""""""""""" Flash navigation (obsidian-flash plugin) """"""""""""""
" Flash Mode: press s or gs, type 2+ chars, labels appear on ALL matches
" Supports Russian/Cyrillic text - labels match input layout.
exmap flashMode obcommand obsidian-flash:activate-flash-mode
nmap s :flashMode<CR>
vmap s :flashMode<CR>

" Jump to Anywhere: <Space>s shows labels on all words immediately (easymotion-style)
exmap flashAnywhere obcommand obsidian-flash:activate-flash-anywhere
nmap <Space>s :flashAnywhere<CR>
vmap <Space>s :flashAnywhere<CR>


"""""""""""""" Russian layout support via langmap """"""""""""""
" Maps Russian ЙЦУКЕН layout to QWERTY for normal/visual mode
" KNOWN BUG: ж (;) and б (,) cannot be mapped due to Obsidian bug with
" physical semicolon/comma keys on non-English layouts. Use English layout
" for f/t repeat motions (;/,).
" Also removed: э (') and Э (") due to quote escaping issues in langmap.
set langmap=йq,цw,уe,кr,еt,нy,гu,шi,щo,зp,х[,ъ],фa,ыs,вd,аf,пg,рh,оj,лk,дl,яz,чx,сc,мv,иb,тn,ьm,ю.,ё`,ЙQ,ЦW,УE,КR,ЕT,НY,ГU,ШI,ЩO,ЗP,Х{,Ъ},ФA,ЫS,ВD,АF,ПG,РH,ОJ,ЛK,ДL,Ж:,ЯZ,ЧX,СC,МV,ИB,ТN,ЬM,Б<,Ю>,Ё~

" Ctrl mappings for Russian layout
imap <C-с> <Esc>
nmap <C-с> <Esc>
vmap <C-с> <Esc>

imap <C-х> <Esc>
nmap <C-х> <Esc>
vmap <C-х> <Esc>

nmap <C-г> <C-u>
nmap <C-в> <C-d>
vmap <C-г> <C-u>
vmap <C-в> <C-d>

