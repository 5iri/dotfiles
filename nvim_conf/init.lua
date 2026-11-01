-- Command shortcuts are primary; Space opens the fallback shortcut menu.
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.o.termguicolors = true
vim.o.background = "dark"
vim.o.number = true
vim.o.relativenumber = false
vim.o.mouse = "a"
vim.o.clipboard = "unnamedplus"
vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.smartindent = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.updatetime = 250
vim.o.timeoutlen = 500
vim.o.signcolumn = "yes"
vim.o.showmode = false
vim.o.showtabline = 0
vim.o.laststatus = 3
vim.o.ruler = false
vim.o.wrap = false
vim.o.scrolloff = 6
vim.o.sidescrolloff = 8
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.undofile = true
vim.o.confirm = true
vim.o.completeopt = "menu,menuone,noselect"
vim.opt.fillchars:append({ eob = " " })
vim.opt.shortmess:append("I")

vim.diagnostic.config({
  virtual_text = false,
  virtual_lines = false,
  severity_sort = true,
  float = { border = "single", source = "if_many" },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "E",
      [vim.diagnostic.severity.WARN] = "W",
      [vim.diagnostic.severity.INFO] = "I",
      [vim.diagnostic.severity.HINT] = "H",
    },
  },
})

require("config.keymaps")
require("config.autocmds")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  local output = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.notify("Could not install lazy.nvim. Check Git/network access and restart.\n" .. output, vim.log.levels.ERROR)
    return
  end
end
vim.opt.rtp:prepend(lazypath)

require("config.plugins")
