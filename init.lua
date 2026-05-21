-- Basic Settings
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.scrolloff = 10
vim.opt.sidescrolloff = 8
vim.opt.wrap = true

vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.cursorline = true

vim.opt.termguicolors = true -- 24-bit color
vim.opt.signcolumn = "yes"
vim.opt.showmatch = true

vim.opt.autoread = true
vim.opt.selection = "inclusive"
vim.opt.clipboard = "unnamedplus"
vim.opt.mouse = "a"
vim.opt.encoding = "UTF-8"

-- Set the leader key to Space
vim.g.mapleader = " "
vim.g.maplocalleader = " " -- Optional: sets a separate leader for local buffers


-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Install plugins
require("lazy").setup({
  {
    "folke/tokyonight.nvim",
    priority = 1000, -- Ensure it loads before other plugins that might set colors
    config = function()
      -- Optional: Customize the theme
      require("tokyonight").setup({
        style = "night", -- Options: 'night', 'day', 'storm', 'moon'
        transparent = false, -- Set to true if you want a transparent background
        styles = {
          sidebars = "transparent",
          floats = "transparent",
        },
      })
    end,
  },

  {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("nvim-tree").setup({
        view = {
          width = 30,
          side = "left",
        },
        filters = {
            dotfiles = false,
        },
        renderer = {
          indent_markers = { enable = true },
          icons = { show = { file = true, folder = true } },
        },
        actions = {
          open_file = { quit_on_open = false },
        },
      })
      vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "Toggle file explorer" })
      vim.keymap.set("n", "<C-h>", ":NvimTreeFocus<CR>", { desc = "Focus Neo-tree" })
    end,
  },

  {
    "akinsho/bufferline.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("bufferline").setup({
        options = {
          mode = "buffers",
          separator_style = "slant",
          show_buffer_close_icons = true,
          show_close_icon = true,
          offsets = {
              {
                  filetype = "NvimTree",
                  text = "File Explorer",
                  highlight = "Directory",
                  separator = true
              }
          }
        }
      })
      vim.keymap.set("n", "<S-h>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev buffer" })
      vim.keymap.set("n", "<S-l>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
      vim.keymap.set("n", "<leader>b", "<cmd>BufferLinePick<cr>", { desc = "Pick buffer" })
      vim.keymap.set("n", "<leader>bd", "<cmd>BufferLinePickClose<cr>", { desc = "Close buffer" })
    end,
  },

  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("toggleterm").setup({
        size = 20,
        open_mapping = [[<c-t>]],
        direction = "horizontal",
        shade_terminals = true,
        shading_factor = 2,
        start_in_insert = true,
      })
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = "VeryLazy",
    config = function()
      require("nvim-treesitter.config").setup({
        ensure_installed = { "lua", "python", "javascript", "typescript", "go", "c", "cpp", "java" },
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },

  {
      "windwp/nvim-autopairs",
      event = "InsertEnter",
      config = function()
        require("nvim-autopairs").setup {}
      end
  },

    {
      "hrsh7th/nvim-cmp",
      event = "InsertEnter", -- Load only when you enter insert mode
      dependencies = {
        "hrsh7th/cmp-buffer",   -- For variable/word completion from buffers
        "hrsh7th/cmp-path",     -- For file path completion
        "hrsh7th/cmp-cmdline",  -- For command line completion
        "L3MON4D3/LuaSnip",     -- Required for snippet expansion (optional but recommended)
        "saadparwaiz1/cmp_luasnip", -- Connects Luasnip to cmp
      },
      config = function()
        local cmp = require("cmp")
        local luasnip = require("luasnip")

        -- Setup the completion engine
        cmp.setup({
          snippet = {
            expand = function(args)
              luasnip.lsp_expand(args.body)
            end,
          },
          mapping = cmp.mapping.preset.insert({
            ["<C-b>"] = cmp.mapping.scroll_docs(-4),
            ["<C-f>"] = cmp.mapping.scroll_docs(4),
            ["<C-Space>"] = cmp.mapping.complete(), -- Trigger completion manually
            ["<C-e>"] = cmp.mapping.abort(),       -- Close completion menu
            ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept selection
          }),
          sources = cmp.config.sources({
            { name = "nvim_lsp" }, -- Keep if add LSP later
            { name = "buffer" },   -- Variable completion from text
            { name = "path" },
          }),
        })

        -- Setup cmdline completion (optional)
        cmp.setup.cmdline({ "/", "?" }, {
          mapping = cmp.mapping.preset.cmdline(),
          sources = { { name = "buffer" } },
        })

        cmp.setup.cmdline(":", {
          mapping = cmp.mapping.preset.cmdline(),
          sources = cmp.config.sources({
            { name = "path" },
          }, {
            { name = "cmdline" },
          }),
        })
      end,
    }

})


-- Activate the Colorscheme
-- This must be called AFTER lazy.setup()
vim.cmd.colorscheme("tokyonight")
