-- AUTHOR:        AISK11
-- LOCATION:      ˜/.config/nvim/init.lua (0644)
-- DESCRIPTION:   Neovim CLI text editor user configuration file.
-- SOURCE:        https://github.com/neovim/neovim

--------------------------------------------------------------------------------
--                                  PACKAGES                                  --
--------------------------------------------------------------------------------
-- Paq package manager.
function install_paq()
  local path = os.getenv("HOME") ..
    "/.local/share/nvim/site/pack/paqs/start/paq-nvim"
  local f = io.open(path, "r")
  if (f) then
    io.close(f)
  else
    os.execute("git clone --depth=1 https://github.com/savq/paq-nvim.git " ..
      path .. " > /dev/null 2>&1")
  end
end
install_paq()

-- Custom Paq commands.
vim.cmd("command! PS source | PaqSync | source")
vim.cmd("command! PL PaqList")

-- Packages (use ":PS" command).
require "paq" {
  { "savq/paq-nvim", opt = false }, -- Package manager.
}

--------------------------------------------------------------------------------
--                                 CONFIGURATION                              --
--------------------------------------------------------------------------------
-- Filesystem.
vim.cmd("set noswapfile")

-- Copy-paste.
vim.cmd("set mouse=r")
vim.cmd("xnoremap <expr> P 'Pgv\"'.v:register.'y`>'")
vim.cmd("xnoremap <expr> p 'pgv\"'.v:register.'y`>'")

-- IDE.
vim.cmd("set number")
vim.cmd("set scrolloff=999")
vim.cmd("set cursorline")
vim.cmd("set guicursor=n-sm:block,i-c-ci:ver50,v-r-cr:hor50")
vim.cmd("set statusline=File:\\ \\[%F\\]\\ (%Y)%=%R\\ %M%=Position:\\ [%l:%c]\\ (%p%%)")
vim.cmd("set colorcolumn=81")
vim.cmd("set list")
vim.cmd("set listchars=tab:▸·")
vim.cmd("match ExtraTabOrSpace /\\s\\+$/")
vim.cmd("highlight! link ExtraTabOrSpace ColorColumn")

-- Text format.
vim.cmd("set fileformats=unix")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.cmd("set expandtab")
vim.cmd("autocmd FileType make setlocal noexpandtab")

--------------------------------------------------------------------------------
--                                  COMMANDS                                  --
--------------------------------------------------------------------------------
-- Text formatting.
function format()
  -- Replace tabs with spaces (if "expandtab" is set).
  vim.cmd("silent retab")

  -- Remove carriage returns.
  vim.cmd("silent %s /\\r//eg")

  -- Remove trailing spaces and tabs at the end of lines.
  vim.cmd("silent %s/\\s\\+$//e")

  -- Remove empty lines at the end of file.
  vim.cmd("silent %s/\\n\\+\\%$//e")

  -- Remove empty lines at the start of file.
  if (vim.fn.getline(1) == "") then
    vim.cmd("silent :1,/^./-1delete | silent nohl")
  end
end

vim.cmd("command! FORMAT lua format()")
