--------------------------------------------------------------------------------
--                                 CONFIGURATION                              --
--------------------------------------------------------------------------------
----------------------------------------
--             FILESYSTEM             --
----------------------------------------
-- Do no use swapfile (store all text in memory).
vim.cmd("set noswapfile")

----------------------------------------
--             COPY-PASTE             --
----------------------------------------
-- Mouse support (Ctrl+Shift+C and Ctrl+Shift+V).
vim.cmd("set mouse=a")
vim.cmd("set clipboard=unnamedplus")
vim.keymap.set("v", "<C-c>", "y")
vim.keymap.set("v", "<C-S-c>", "y")

-- Keep copied/cut text in memory after pasting - allow multiple pasting.
vim.cmd("xnoremap <expr> P 'Pgv\"'.v:register.'y`>'")
vim.cmd("xnoremap <expr> p 'pgv\"'.v:register.'y`>'")

-- Do not show Right click menu (still works on multiple-click).
vim.keymap.set("n", "<RightMouse>", "<NOP>")
vim.keymap.set("v", "<RightMouse>", "<NOP>")
vim.keymap.set("i", "<RightMouse>", "<NOP>")

----------------------------------------
--            TEXT FORMAT             --
----------------------------------------
-- Use <LF> instead of <CR><LF>.
vim.cmd("set fileformats=unix")

-- Auto indentation.
vim.cmd("set autoindent")
vim.cmd("set smartindent")

-- Replace tabs with spaces (to insert tab press Shift+Tab or Ctrl+V+Tab).
vim.cmd("set expandtab")
vim.api.nvim_set_keymap("i", "<S-Tab>", "<C-V><Tab>", { noremap = true })

-- Tab size.
vim.cmd("set tabstop=4 softtabstop=4 shiftwidth=4")

-- Specific filetype settings.
local langs_tab_sensitive = "make"
vim.cmd("autocmd FileType " .. langs_tab_sensitive .. " setlocal noexpandtab")
local langs_tab_2 = "html,css,javascript,jsonc,lua,haskell"
vim.cmd("autocmd FileType " .. langs_tab_2 .. " set tabstop=2 softtabstop=2 shiftwidth=2")

----------------------------------------
--                IDE                 --
----------------------------------------
-- Case insensitive search if lowercase search.
vim.cmd("set ignorecase")
vim.cmd("set smartcase")

-- Cursor.
vim.cmd("set guicursor=n-sm:block,i-c-ci:ver50,v-r-cr:hor50")
vim.cmd("set cursorline")

-- Status line.
vim.cmd("set statusline=File:\\ \\[%F\\]\\ (%Y)%=%R\\ %M%=Position:\\ [%l:%c]\\ (%p%%)")

-- Line numbers.
vim.cmd("set number")

-- Scroll from middle.
vim.cmd("set scrolloff=4")

-- Highlighting.
vim.cmd("set colorcolumn=81")
vim.cmd("match ExtraTabOrSpace /\\s\\+$/")
vim.cmd("highlight! link ExtraTabOrSpace ColorColumn")

-- Character representation.
vim.cmd("set list")
vim.cmd("set listchars=tab:→·")

-- Syntax highlighting for less-known formats.
local langs_syntax_html = "*.astro,*.hta"
vim.cmd("autocmd BufNewFile,BufRead " .. langs_syntax_html .. " setfiletype html")

--------------------------------------------------------------------------------
--                                 SHORTCUTS                                  --
--------------------------------------------------------------------------------
-- Replace text (Ctrl+H).
vim.api.nvim_set_keymap('n', '<C-h>', ':%s/', { noremap = true })

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

--------------------------------------------------------------------------------
--                                  PACKAGES                                  --
--------------------------------------------------------------------------------
-- Choose if packages should be used (requires internet on first launch).
local use_packages = true
if (use_packages and os.getenv("COLORTERM") == "truecolor") then
  -- Packages.
  local packages = {
    "savq/paq-nvim",               -- Package manager.
    "catppuccin/nvim",             -- Color scheme.
    "norcalli/nvim-colorizer.lua", -- Colorizer.
    "lewis6991/gitsigns.nvim",     -- Git changes.
  }

  -- Install Paq if necessary.
  local paq_path = os.getenv("HOME") .. "/.local/share/nvim/site/pack/paqs/start/paq-nvim"
  f = io.open(paq_path .. "/lua/paq.lua", "r")
  if (f) then
    io.close(f)
  else
    os.execute("git clone --depth=1 https://github.com/savq/paq-nvim.git " .. paq_path .. " > /dev/null 2>&1")
    vim.cmd("packadd paq-nvim")
    require("paq")(packages)
    require("paq").install()
    vim.cmd("autocmd User PaqDoneInstall lua vim.cmd('source ' .. vim.fn.stdpath('config') .. '/init.lua')")
  end

  -- Paq installed packages (required for ":Paq*" commands).
  require("paq")(packages)

  ---- Package settings.
  -- "catppuccin/nvim"
  vim.cmd("colorscheme catppuccin-mocha")

  -- norcalli/nvim-colorizer.lua
  require("colorizer").setup()

  -- "lewis6991/gitsigns.nvim"
  require("gitsigns").setup()
end
