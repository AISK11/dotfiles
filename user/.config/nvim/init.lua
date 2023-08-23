-- AUTHOR:        AISK11
-- LOCATION:      ˜/.config/nvim/init.lua (0644)
-- DESCRIPTION:   Neovim CLI text editor user configuration file.
-- SOURCE:        https://github.com/neovim/neovim

--------------------------------------------------------------------------------
--                                  PACKAGES                                  --
--------------------------------------------------------------------------------
-- Path to package manager and packages.
local nvim_data_path = os.getenv("HOME") .. "/.local/share/nvim"

-- Paq package manager autoinstall.
function paq_autoinstall()
  local path = nvim_data_path .. "/site/pack/paqs/start/paq-nvim"
  local f = io.open(path, "r")
  if (f) then
    io.close(f)
  else
    os.execute("git clone --depth=1 https://github.com/savq/paq-nvim.git " ..
      path .. " > /dev/null 2>&1")
  end
end
paq_autoinstall()

-- Packages (use ":PaqSync" and ":source" commands to install packages).
require "paq" {
  { "savq/paq-nvim", opt = false },             -- Package manager.
  { "loctvl842/monokai-pro.nvim", opt = false } -- Color scheme.
}

-- Internal functions.
function paq_installed_packages()
  local f = io.open(nvim_data_path .. "/paq-lock.json", "r")
  if (f) then
    local f_content = f:read("*all")
    f:close()
    local plugins = {}
    for plugin in f_content:gmatch("\"([^\"]+)\":{") do
      table.insert(plugins, plugin)
    end
    return table.concat(plugins, "\n")
  end
  return ""
end
local packages = paq_installed_packages()

function is_package_installed(package)
  return string.find(packages, package, 1, true) ~= nil
end

-- Package settings.
if (is_package_installed("monokai-pro.nvim")) then
  require("monokai-pro").setup({
    filter = "pro"
  })
end

-- Package usage.
if (os.getenv("COLORTERM") == "truecolor") then
  if (is_package_installed("monokai-pro.nvim")) then
    vim.cmd("colorscheme monokai-pro")
  end
end

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
local tab_size = "2"
vim.cmd("set fileformats=unix")
vim.cmd("set tabstop=" .. tab_size)
vim.cmd("set softtabstop=" .. tab_size)
vim.cmd("set shiftwidth=" .. tab_size)
vim.cmd("set expandtab")
vim.cmd("autocmd FileType make setlocal noexpandtab")

--------------------------------------------------------------------------------
--                                  COMMANDS                                  --
--------------------------------------------------------------------------------
-- Basic code/text beautifying.
function beautify()
  -- Remove carriage returns.
  vim.cmd("silent %s /\\r//eg")

  -- Replace tabs with spaces (if "expandtab" is set).
  vim.cmd("silent retab")

  -- Remove trailing spaces and tabs at the end of lines.
  vim.cmd("silent %s/\\s\\+$//e")

  -- Remove empty lines at the end of file.
  vim.cmd("silent %s/\\n\\+\\%$//e")

  -- Remove empty lines at the start of file.
  if (vim.fn.getline(1) == "") then
    vim.cmd("silent :1,/^./-1delete | silent nohl")
  end
end
vim.cmd("command! FORMAT lua beautify()")
