-- ========================================================================== --
-- 1. BASIC SETTINGS
-- ========================================================================== --
vim.g.mapleader = " "              -- Sets Spacebar as the Leader key
vim.opt.number = true              -- Show line numbers
vim.opt.relativenumber = true      -- Relative numbers for fast movement
vim.opt.shiftwidth = 4             -- Tab size
vim.opt.softtabstop = 4
vim.opt.expandtab = true           -- Use spaces instead of tabs
vim.opt.smartindent = true         -- Smart indentation for C/C++
vim.opt.termguicolors = true       -- Enable 24-bit RGB colors
vim.opt.clipboard = "unnamedplus"  -- Sync with system clipboard (Copy/Paste)

-- ========================================================================== --
-- 2. PLUGIN MANAGER (Lazy.nvim)
-- ========================================================================== --
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- ========================================================================== --
-- 3. PLUGIN LIST
-- ========================================================================== --
require("lazy").setup({
  -- Theme
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha",
      })
    end,
  },

  -- LSP & Autocomplete
  "neovim/nvim-lspconfig",
  "hrsh7th/nvim-cmp",
  "hrsh7th/cmp-nvim-lsp",
  "L3MON4D3/LuaSnip",

  -- Syntax Highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    config = function()
      local parsers = { "c", "cpp", "lua", "python", "rust", "make", "cmake", "haskell" }

      require('nvim-treesitter').setup({})

      -- Install parsers (replaces old ensure_installed)
      require('nvim-treesitter').install(parsers)

      -- Enable highlighting per-buffer (replaces old highlight.enable)
      vim.api.nvim_create_autocmd('FileType', {
        pattern = parsers,
        callback = function()
          vim.treesitter.start()
        end,
      })

      -- Enable treesitter-based indentation (replaces old indent.enable)
      vim.api.nvim_create_autocmd('FileType', {
        pattern = parsers,
        callback = function()
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end,
  },

  -- File Explorer (The "Dropdown" system)
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({
        view = {
          width = 30,
          side = "left",
        },
        renderer = {
          group_empty = true,
          icons = {
            show = {
              file = true,
              folder = true,
              folder_arrow = true,
              git = true,
            },
          },
        },
      })
    end,
  },

  -- Utils
  {
    'Civitasv/cmake-tools.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {},
  },

  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true,
  },

  -- Statusline
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require('lualine').setup({
        options = { theme = 'catppuccin-mocha' }
      })
    end,
  },

  -- Fuzzy Finder
  {
    'nvim-telescope/telescope.nvim', tag = '0.1.8',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
      vim.keymap.set('n', 'gr', builtin.lsp_references, { desc = 'Telescope LSP references' })
    end
  },
})

-- ========================================================================== --
-- 4. THEME & LSP CONFIG
-- ========================================================================== --
vim.cmd.colorscheme "catppuccin-mocha"

local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Apply capabilities to every server by extending the shared default config
vim.lsp.config('*', {
  capabilities = capabilities,
})

-- C/C++ (Make sure you ran: sudo pacman -S clang)
vim.lsp.enable('clangd')

-- Python
vim.lsp.enable('pyright')

-- Lua
vim.lsp.enable('lua_ls')

-- Rust
vim.lsp.enable('rust_analyzer')

-- Haskell
vim.lsp.enable('hls')

-- ========================================================================== --
-- 5. AUTOCOMPLETE (CMP)
-- ========================================================================== --
local cmp = require('cmp')
cmp.setup({
  snippet = {
    expand = function(args) require('luasnip').lsp_expand(args.body) end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
  }, {
    { name = 'buffer' },
  })
})

-- ========================================================================== --
-- 6. KEYBINDINGS
-- ========================================================================== --
-- File Tree
vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>', { desc = 'Toggle File Explorer' })

-- LSP
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = 'Go to Definition' })
vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = 'Show Documentation' })
vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, { desc = 'Rename Variable' })

-- General
vim.keymap.set('n', '<leader>w', ':w<CR>', { desc = 'Save File' })
vim.keymap.set('n', '<leader>q', ':q<CR>', { desc = 'Quit' })

