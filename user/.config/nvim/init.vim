"" AUTHOR:      AISK11
"" LOCATION:    ~/.config/nvim/init.vim (0644)
"" DESCRIPTION: Neovim CLI text editor configuration file.
"" SOURCE:      https://github.com/neovim/neovim
"" - ARCH:      community/neovim

"" View all options at: 'https://neovim.io/doc/user/options.html'.

"" Allow editing file from anywhere.
set noswapfile

"" Enable mouse copy-paste.
set mouse=r

"" Allow pasting text multiple times.
xnoremap <expr> p 'pgv"'.v:register.'y`>'
xnoremap <expr> P 'Pgv"'.v:register.'y`>'

"" Find serach results after whole pattern is typed.
set noincsearch

"" Replace tab with spaces.
set expandtab

"" Differentiate tabs from spaces.
set list
set listchars=tab:>-,trail:-

"" Tab space amount.
set tabstop=4
set softtabstop=4
set shiftwidth=4
autocmd FileType html,css,xml setlocal tabstop=2 softtabstop=2 shiftwidth=2

"" Allow syntax highlighting.
syntax on

"" Highlight 81st column.
set colorcolumn=81
:highlight ColorColumn ctermbg=red

"" Highlight trailing spaces.
:match ExtraWhitespace /\s\+$/
:highlight ExtraWhitespace ctermbg=red

"" Make text on current line bold.
set cursorline
:highlight CursorLine cterm=bold

"" Cursor in variant modes.
set guicursor=n-sm:block,i-c-ci:ver50,v-r-cr:hor50

"" Print line numbers.
set number

"" Scroll 'n' lines before reaching end of page.
set scrolloff=4

"" Always show statusline.
set laststatus=2

"" Statusline format.
set statusline=File:\ \"%F\"\ (%Y)\ %R\ %M%=Position:\ [%l:%c]\ (%p%%)
