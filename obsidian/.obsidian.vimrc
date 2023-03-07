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
nmap \ :nohl


" Yank to system clipboard
set clipboard=unnamed

" gj - Join the current line with the line beyond with a space in between
noremap gj J

" Switch tabs in normal mode with J / K
unmap J
exmap nexttab obcommand workspace:next-tab
exmap prevtab obcommand workspace:previous-tab
nmap J :nexttab
nmap K :prevtab

" Close the current tab with ZZ / ZQ
exmap closetab obcommand workspace:close
nmap ZZ :closetab
nmap ZQ :closetab


" Reload Obsidian
exmap reload_obsidian obcommand app:reload
map <A-r> :reload_obsidian
map <A-к> :reload_obsidian


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
map S" :surround_double_quotes
map S' :surround_single_quotes
map S` :surround_backtick
map Sb :surround_brackets
map S( :surround_brackets
map S) :surround_brackets
map S[ :surround_square_brackets
map S] :surround_square_brackets
map S{ :surround_curly_brackets
map S} :surround_curly_brackets
map S^ :surround_superscript
map S_ :surround_subscript

" Same bindings for Russian layout
nunmap Ы
vunmap Ы
map Ы" :surround_double_quotes
map Ы' :surround_single_quotes
map Ы` :surround_asterisc
map Ыb :surround_brackets
map Ы( :surround_brackets
map Ы) :surround_brackets
map Ы[ :surround_square_brackets
map Ы] :surround_square_brackets
map Ы{ :surround_curly_brackets
map Ы} :surround_curly_brackets


"""""""""""""" Begin Mappings for Russian layout """"""""""""""
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


nmap й q
nmap Й Q
nmap ц w
nmap Ц W
nmap у e
nmap У E
nmap к r
nmap К R
nmap е t
nmap Е T
nmap н y
nmap Н Y
nmap г u
nmap Г U
nmap ш i
nmap Ш I
nmap щ o
nmap Щ O
nmap з p
nmap З P
nmap х [
nmap Х {
nmap ъ ]
nmap Ъ }
vmap й q
vmap Й Q
vmap ц w
vmap Ц W
vmap у e
vmap У E
vmap к r
vmap К R
vmap е t
vmap Е T
vmap н y
vmap Н Y
vmap г u
vmap Г U
vmap ш i
vmap Ш I
vmap щ o
vmap Щ O
vmap з p
vmap З P
vmap х [
vmap Х {
vmap ъ ]
vmap Ъ }

nmap ф a
nmap Ф A
nmap ы s
nmap Ы S
nmap в d
nmap В D
nmap а f
nmap А F
nmap п g
nmap П G
nmap р h
nmap Р H
nmap о j
nmap О J
nmap л k
nmap Л K
nmap д l
nmap Д L
nmap ж ;
nmap Ж :
nmap э '
nmap Э "
vmap ф a
vmap Ф A
vmap ы s
vmap Ы S
vmap в d
vmap В D
vmap а f
vmap А F
vmap п g
vmap П G
vmap р h
vmap Р ^
vmap о j
vmap О J
vmap л k
vmap Л K
vmap д l
vmap Д $
vmap ж ;
vmap Ж :
vmap э '
vmap Э "

nmap я z
nmap Я Z
nmap ч x
nmap Ч X
nmap с c
nmap С C
nmap м v
nmap М V
nmap и b
nmap И B
nmap т n
nmap Т N
nmap ь m
nmap Ь M
nmap б ,
nmap Б <
nmap ю .
nmap Ю >
vmap я z
vmap Я Z
vmap ч x
vmap Ч X
vmap с c
vmap С C
vmap м v
vmap М V
vmap и b
vmap И B
vmap т n
vmap Т N
vmap ь m
vmap Ь M
vmap б ,
vmap Б <
vmap ю .
vmap Ю >

nmap ё `
nmap Ё ~
nmap № #
nmap ? &
vmap ё `
vmap Ё ~
vmap № #



"""""""""""""" End of Mappings for Russian layout """"""""""""""

