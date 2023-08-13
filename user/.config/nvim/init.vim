"" AUTHOR:        AISK11
"" LOCATION:      ˜/.config/nvim/init.vim (0644)
"" DESCRIPTION:   Neovim CLI text editor user configuration file.
"" SOURCE:        https://github.com/neovim/neovim
"" DOCUMENTATION: https://neovim.io/doc/user/quickref.html#option-list

"" Filesystem.
set noswapfile

"" Text format.
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4
autocmd FileType css,html,make,xml setlocal tabstop=2 softtabstop=2 shiftwidth=2
autocmd Filetype make setlocal noexpandtab

"" Copy-paste.
set mouse=r
xnoremap <expr> p 'pgv"'.v:register.'y`>'
xnoremap <expr> P 'Pgv"'.v:register.'y`>'

"" IDE.
syntax on
set guicursor=n-sm:block,i-c-ci:ver50,v-r-cr:hor50
set cursorline
set colorcolumn=81
set number
set scrolloff=999
set statusline=File:\ \[%F\]\ (%Y)%=%R\ %M%=Position:\ [%l:%c]\ (%p%%)
match ExtraWhitespace /\s\+$/

"" Theme.
if $TERM != 'linux'
    let color_tui=209
    exe 'highlight LineNr       cterm=bold         ctermfg=' . color_tui
    exe 'highlight CursorLineNr cterm=bold,reverse ctermfg=' . color_tui
    exe 'highlight StatusLine   cterm=bold         ctermfg=' . color_tui
    exe 'highlight ColorColumn  cterm=none         ctermbg=' . color_tui

    let color_error=202
    exe 'highlight ExtraWhiteSpace ctermbg=' . color_error

    let color_bg=232
    let color_fg=231
    let color_line=234
    exe 'highlight Normal     cterm=none ctermfg=' . color_fg . ' ctermbg=' . color_bg
    exe 'highlight CursorLine cterm=none ctermbg=' . color_line
endif
