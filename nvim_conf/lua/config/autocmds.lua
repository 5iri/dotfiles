local group = vim.api.nvim_create_augroup("EditorDefaults", { clear = true })

-- A directory argument is an explicit request to browse that directory.
vim.api.nvim_create_autocmd("VimEnter", {
  group = group,
  callback = function(data)
    if data.file ~= "" and vim.fn.isdirectory(data.file) == 1 then
      vim.api.nvim_set_current_dir(data.file)
      require("nvim-tree.api").tree.open({ path = data.file })
    end
  end,
})

vim.api.nvim_create_autocmd("TermOpen", {
  group = group,
  callback = function()
    vim.wo.number = false
    vim.wo.relativenumber = false
    vim.wo.signcolumn = "no"
  end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
  group = group,
  callback = function()
    vim.highlight.on_yank({ timeout = 120 })
  end,
})
