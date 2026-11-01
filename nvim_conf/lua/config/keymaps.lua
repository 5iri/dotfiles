local map = vim.keymap.set

local function picker(name)
  return function()
    require("telescope.builtin")[name]()
  end
end

local function toggle_terminal()
  require("config.terminal").toggle()
end

map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })
map("n", "<leader><space>", picker("find_files"), { desc = "Find file" })
map("n", "<leader>/", picker("live_grep"), { desc = "Search project text" })
map("n", "<leader>,", picker("buffers"), { desc = "Switch buffer" })
map("n", "<leader>:", picker("commands"), { desc = "Command palette" })
map("n", "<leader>?", function()
  require("which-key").show({ keys = "<leader>", mode = "n" })
end, { desc = "Show shortcuts" })

map("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle files" })
map("n", "<leader>ff", picker("find_files"), { desc = "Find file" })
map("n", "<leader>fr", picker("oldfiles"), { desc = "Recent files" })
map("n", "<leader>fg", picker("live_grep"), { desc = "Search project text" })
map("n", "<leader>fb", picker("buffers"), { desc = "Open buffers" })
map("n", "<leader>fn", "<cmd>enew<CR>", { desc = "New file" })

map({ "n", "i", "x" }, "<C-s>", "<Esc><cmd>write<CR>", { desc = "Save file" })
map("n", "<leader>w", "<cmd>write<CR>", { desc = "Save file" })
map("n", "<leader>q", "<cmd>confirm quit<CR>", { desc = "Close window" })
map("n", "<leader>bd", "<cmd>confirm bdelete<CR>", { desc = "Close buffer" })
map("n", "<leader>bn", "<cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "<leader>bp", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
map("n", "]b", "<cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "[b", "<cmd>bprevious<CR>", { desc = "Previous buffer" })

for key, direction in pairs({ h = "left", j = "down", k = "up", l = "right" }) do
  map("n", "<C-" .. key .. ">", "<C-w>" .. key, { desc = "Focus window " .. direction })
  map("t", "<C-" .. key .. ">", [[<C-\><C-n><C-w>]] .. key, { desc = "Focus window " .. direction })
end
map("n", "<leader>sv", "<cmd>vsplit<CR>", { desc = "Split vertically" })
map("n", "<leader>sh", "<cmd>split<CR>", { desc = "Split horizontally" })
map("n", "<leader>se", "<C-w>=", { desc = "Equalize splits" })
map("n", "<leader>tt", toggle_terminal, { desc = "Toggle terminal" })
map("t", "<Esc><Esc>", [[<C-\><C-n>]], { desc = "Leave terminal input" })

map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line diagnostic" })
map("n", "<leader>cl", picker("diagnostics"), { desc = "Project diagnostics" })
map("n", "[d", function()
  vim.diagnostic.jump({ count = -1, float = true })
end, { desc = "Previous diagnostic" })
map("n", "]d", function()
  vim.diagnostic.jump({ count = 1, float = true })
end, { desc = "Next diagnostic" })
map("n", "<leader>ur", function()
  vim.wo.relativenumber = not vim.wo.relativenumber
end, { desc = "Toggle relative numbers" })
map("n", "<leader>uw", function()
  vim.wo.wrap = not vim.wo.wrap
end, { desc = "Toggle line wrapping" })

-- Command shortcuts work in normal, insert, and visual mode.
-- Ghostty forwards these as CSI-u keys; Space bindings remain as a fallback.
for _, binding in ipairs({
  { "<D-p>", "Telescope find_files", "Find file" },
  { "<D-/>", "Telescope live_grep", "Search project text" },
  { "<D-e>", "NvimTreeToggle", "Toggle files" },
  { "<D-S-p>", "Telescope commands", "Command palette" },
  { "<D-w>", "confirm bdelete", "Close buffer" },
  { "<D-C-t>", "lua require('config.terminal').toggle()", "Toggle terminal" },
}) do
  map({ "n", "i", "x" }, binding[1], "<Esc><Cmd>" .. binding[2] .. "<CR>", { desc = binding[3] })
end
-- Saving keeps the cursor and editing mode intact.
map({ "n", "i", "x" }, "<D-s>", "<Cmd>write<CR>", { desc = "Save file" })
map("t", "<D-C-t>", [[<C-\><C-n><Cmd>lua require('config.terminal').toggle()<CR>]], { desc = "Toggle terminal" })
