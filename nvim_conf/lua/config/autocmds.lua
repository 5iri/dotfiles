-- Autocommands to make Neovim act more like VS Code

local api = vim.api

-- When starting with a directory (e.g. `nvim .`), open the file explorer.
api.nvim_create_autocmd("VimEnter", {
  callback = function(data)
    -- If the argument is a directory, open NvimTree on it
    if data.file ~= "" and vim.fn.isdirectory(data.file) == 1 then
      vim.cmd.cd(data.file)
      require("nvim-tree.api").tree.open()
    end
  end,
})

