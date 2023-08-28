-- AUTHOR:        AISK11
-- LOCATION:      ˜/.config/nvim/init.lua (0644)
-- DESCRIPTION:   Neovim CLI text editor user configuration file.
-- SOURCE:        https://github.com/neovim/neovim

--------------------------------------------------------------------------------
--                                  SETTINGS                                  --
--------------------------------------------------------------------------------
-- Choose if packages should be used (requires internet on first launch).
--local use_packages = true

--------------------------------------------------------------------------------
--                                  PACKAGES                                  --
--------------------------------------------------------------------------------
if (use_packages and os.getenv("COLORTERM") == "truecolor") then
  local nvim_data_path     = os.getenv("HOME") .. "/.local/share/nvim"
  local is_fresh_install   = false
  local installed_packages = ""

  -- Paq package manager autoinstall.
  function autoinstall_paq()
    local path = nvim_data_path .. "/site/pack/paqs/start/paq-nvim"
    local f    = io.open(path, "r")
    if (f) then
      io.close(f)
    else
      os.execute("git clone --depth=1 https://github.com/savq/paq-nvim.git " ..
        path .. " > /dev/null 2>&1")
        is_fresh_install = true
    end
  end
  autoinstall_paq()

  -- Paq installed packages (required for ":Paq*" commands).
  require "paq" {
    { "savq/paq-nvim", opt = false },                   -- Package manager.
    { "loctvl842/monokai-pro.nvim", opt = false },      -- Color scheme.
    { "nvim-treesitter/nvim-treesitter", opt = false }, -- Syntax highlighting.
    { "norcalli/nvim-colorizer.lua", opt = false },     -- Colorizer.
  }

  -- Check if package is installed.
  function get_installed_packages()
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

  function is_package_installed(package)
    return string.find(installed_packages, package, 1, true) ~= nil
  end

  -- Paq installed packages autoinstall.
  function autoinstall_packages()
    vim.cmd("PaqSync")
  end
  if (is_fresh_install) then
    autoinstall_packages()
  else
    installed_packages = get_installed_packages()
  end

  -- Package settings and usage.
  if (is_package_installed("monokai-pro.nvim")) then
    require("monokai-pro").setup({
      filter = "pro",
    })
    vim.cmd("colorscheme monokai-pro")
  end
  if (is_package_installed("nvim-treesitter")) then
    require("nvim-treesitter.configs").setup({
      ensure_installed = { "c", "lua", "query" },
      highlight = {
        enable = true,
      },
    })
  end
  if (is_package_installed("nvim-colorizer.lua")) then
    require("colorizer").setup()
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
vim.cmd("command! BEAUTIFY lua beautify()")
