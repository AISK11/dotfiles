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
if $COLORTERM == 'truecolor'
    set termguicolors

    let color_tui='#F5CD7B'
    exe 'highlight LineNr       gui=bold         guifg=' . color_tui
    exe 'highlight CursorLineNr gui=bold,reverse guifg=' . color_tui
    exe 'highlight StatusLine   gui=bold,reverse guifg=' . color_tui
    exe 'highlight ColorColumn  gui=bold         guibg=' . color_tui

    let color_bg='#282C34'
    let color_fg='#ABB2BF'
    let color_line='#383E4A'
    exe 'highlight Normal     gui=none guibg=' . color_bg . ' guifg=' . color_fg
    exe 'highlight CursorLine gui=none guibg=' . color_line
    exe 'highlight Visual     gui=none guibg=' . color_line
    exe 'highlight Search     gui=none guibg=' . color_tui ' guifg=' . color_bg
    exe 'highlight CurSearch  gui=bold guibg=' . color_tui ' guifg=' . color_bg

    let color_red='#E06C75'
    exe 'highlight ExtraWhiteSpace gui=none guibg=' . color_red
    exe 'highlight Statement       gui=none guifg=' . color_red

    let color_comment='#676F7D'
    exe 'highlight Comment gui=none guifg=' . color_comment

    let color_string='#E5C07B'
    let color_value='#C678DD'
    exe 'highlight String gui=none guifg=' . color_string
    exe 'highlight Number gui=none guifg=' . color_value

    let color_type='#56B6C2'
    exe 'highlight Type gui=none guifg=' . color_type
endif
