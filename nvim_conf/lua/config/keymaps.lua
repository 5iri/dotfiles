-- Keymaps with a VS Code flavor

local map = vim.keymap.set

-- Better defaults
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- Very small core set of VS Code-like keys

-- File explorer toggle (VS Code: Cmd+B)
map("n", "<D-b>", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" })

-- Quick open file (VS Code: Cmd+P)
map("n", "<D-p>", "<cmd>Telescope find_files<CR>", { desc = "Find file" })

-- Command palette (VS Code: Cmd+Shift+P)
map("n", "<D-S-p>", "<cmd>Telescope commands<CR>", { desc = "Command palette" })

-- Quick save / quit
map("n", "<D-s>", "<cmd>w<CR>", { desc = "Save file" })

-- Close editor (VS Code: Cmd+W)
map("n", "<D-w>", "<cmd>bd<CR>", { desc = "Close buffer" })

-- Terminal toggle (like VS Code integrated terminal)
map("n", "<D-`>", "<cmd>split | terminal<CR>", { desc = "Open terminal below" })
map("t", "<Esc>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })
