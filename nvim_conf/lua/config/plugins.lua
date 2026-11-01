-- Plugin setup using lazy.nvim

require("lazy").setup({
  -- Core dependencies
  { "nvim-lua/plenary.nvim" },

  -- Black canvas with quiet borders.
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    opts = {
      style = "night",
      transparent = false,
      styles = {
        sidebars = "dark",
        floats = "dark",
      },
      on_colors = function(colors)
        -- Force all main backgrounds to pure black
        colors.bg = "#000000"
        colors.bg_dark = "#000000"
        colors.bg_sidebar = "#000000"
        colors.bg_float = "#000000"
      end,
      on_highlights = function(hl)
        hl.FloatBorder = { fg = "#444444", bg = "#000000" }
        hl.WinSeparator = { fg = "#444444", bg = "#000000" }
        hl.LineNr = { fg = "#737373", bg = "#000000" }
      end,
    },
    config = function(_, opts)
      require("tokyonight").setup(opts)
      vim.cmd([[colorscheme tokyonight]])
    end,
  },

  -- File explorer
  {
    "nvim-tree/nvim-tree.lua",
    config = function()
      require("nvim-tree").setup({
        sync_root_with_cwd = true,
        view = { width = 30, signcolumn = "no" },
        renderer = {
          group_empty = true,
          root_folder_label = ":t",
          add_trailing = true,
          icons = {
            web_devicons = { file = { enable = false }, folder = { enable = false } },
            show = {
              file = false,
              folder = false,
              folder_arrow = true,
              git = false,
              modified = false,
              diagnostics = false,
              bookmarks = false,
            },
            glyphs = { folder = { arrow_closed = ">", arrow_open = "v" } },
          },
        },
        filters = { custom = { "^\\.git$", "^\\.DS_Store$" } },
        update_focused_file = { enable = true },
        actions = { open_file = { quit_on_open = true } },
      })
    end,
  },

  -- One text-only status line, shared by all splits.
  {
    "nvim-lualine/lualine.nvim",
    config = function()
      local theme = {}
      for mode, color in pairs({
        normal = "#7aa2f7",
        insert = "#9ece6a",
        visual = "#bb9af7",
        replace = "#f7768e",
        command = "#e0af68",
        inactive = "#737373",
      }) do
        theme[mode] = {
          a = { fg = color, bg = "#000000", gui = "bold" },
          b = { fg = "#a9b1d6", bg = "#000000" },
          c = { fg = "#a9b1d6", bg = "#000000" },
        }
      end
      require("lualine").setup({
        options = {
          theme = theme,
          icons_enabled = false,
          section_separators = "",
          component_separators = "",
          globalstatus = true,
          ignore_focus = { "TelescopePrompt" },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = {},
          lualine_c = {
            {
              "filename",
              path = 1,
              fmt = function(name)
                return vim.bo.buftype == "terminal" and "Terminal" or name
              end,
            },
          },
          lualine_x = {
            {
              "diagnostics",
              sources = { "nvim_diagnostic" },
              sections = { "error", "warn" },
              symbols = { error = "E:", warn = "W:" },
              colored = false,
            },
          },
          lualine_y = {
            {
              function()
                return "Cmd-P: files  Cmd-/: search  Cmd-E: tree"
              end,
              cond = function()
                return vim.api.nvim_buf_get_name(0) == "" and vim.bo.buftype == ""
              end,
            },
          },
          lualine_z = { "location" },
        },
        extensions = { "nvim-tree" },
      })
    end,
  },

  -- Hints appear only after pressing Space.
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      local keys = {}
      for _, name in ipairs({
        "Up", "Down", "Left", "Right", "C", "M", "D", "S", "CR", "Esc",
        "ScrollWheelDown", "ScrollWheelUp", "NL", "BS", "Space", "Tab",
        "F1", "F2", "F3", "F4", "F5", "F6", "F7", "F8", "F9", "F10", "F11", "F12",
      }) do
        keys[name] = name .. " "
      end
      require("which-key").setup({
        delay = 300,
        triggers = { { "<leader>", mode = "nx" } },
        icons = { mappings = false, keys = keys, breadcrumb = ">", separator = ">" },
        win = { border = "single", padding = { 0, 1 } },
        show_help = false,
        show_keys = false,
        spec = {
          { "<leader>b", group = "Buffers" },
          { "<leader>c", group = "Code" },
          { "<leader>f", group = "Files" },
          { "<leader>s", group = "Splits" },
          { "<leader>t", group = "Terminal" },
          { "<leader>u", group = "View" },
        },
      })
    end,
  },

  -- Telescope fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    tag = "v0.1.9",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local actions = require("telescope.actions")
      require("telescope").setup({
        defaults = {
          prompt_prefix = "Search: ",
          selection_caret = "> ",
          entry_prefix = "  ",
          sorting_strategy = "ascending",
          layout_config = {
            width = 0.85,
            height = 0.75,
            prompt_position = "top",
            horizontal = { preview_cutoff = 100 },
          },
          path_display = { "truncate" },
          mappings = { i = { ["<Esc>"] = actions.close } },
        },
        pickers = {
          find_files = {
            hidden = true,
            file_ignore_patterns = { "^%.git/", "%.DS_Store$" },
            disable_devicons = true,
          },
          buffers = {
            sort_mru = true,
            ignore_current_buffer = true,
            previewer = false,
            disable_devicons = true,
          },
          oldfiles = { only_cwd = true, disable_devicons = true },
        },
      })
    end,
  },

  -- Treesitter for syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    -- This configuration uses the API supported by Neovim 0.11.
    branch = "master",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "c",
          "cpp",
          "python",
          "lua",
          "vim",
          "vimdoc",
          "rust",
          "verilog",
        },
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },

  -- LSP, Mason, and completion
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/nvim-cmp",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
    },
    config = function()
      -- Mason setup
      require("mason").setup()
      require("mason-lspconfig").setup({
        -- Only auto-install tools that don't require extra system package managers.
        -- You can still install others (like pyright, svls) manually.
        ensure_installed = {
          "clangd",
          "rust_analyzer",
        },
        automatic_enable = false,
      })

      -- nvim-cmp setup
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup({
        preselect = cmp.PreselectMode.None,
        window = {
          completion = cmp.config.window.bordered({ border = "single", scrollbar = false }),
          documentation = cmp.config.window.bordered({ border = "single" }),
        },
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = false }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
        }, {
          { name = "buffer" },
          { name = "path" },
        }),
      })

      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      local on_attach = function(_, bufnr)
        local bufmap = function(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
        end

        -- VS Code–like LSP keymaps
        bufmap("n", "gd", vim.lsp.buf.definition, "Go to definition")
        bufmap("n", "gr", vim.lsp.buf.references, "Go to references")
        bufmap("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
        bufmap("n", "K", vim.lsp.buf.hover, "Hover documentation")
        bufmap("n", "<F2>", vim.lsp.buf.rename, "Rename symbol")
        bufmap("n", "<leader>cr", vim.lsp.buf.rename, "Rename symbol")
        bufmap("n", "<leader>ca", vim.lsp.buf.code_action, "Code action")
        bufmap("n", "<leader>cf", function()
          vim.lsp.buf.format({ async = true })
        end, "Format buffer")
      end

      -- Configure servers using the new vim.lsp.config / vim.lsp.enable API.
      local function setup_server(name, opts)
        opts = opts or {}
        opts.capabilities = capabilities
        opts.on_attach = on_attach
        vim.lsp.config(name, opts)
        vim.lsp.enable(name)
      end

      -- Python (pyright)
      setup_server("pyright")

      -- C / C++ (clangd)
      setup_server("clangd")

      -- Rust (rust-analyzer)
      setup_server("rust_analyzer", {
        settings = {
          ["rust-analyzer"] = {
            cargo = { allFeatures = true },
            checkOnSave = { command = "clippy" },
          },
        },
      })

      -- Verilog / SystemVerilog (svls)
      setup_server("svls")
    end,
  },
})
