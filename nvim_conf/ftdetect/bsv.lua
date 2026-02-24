-- Treat Bluespec (.bsv) as Verilog for now to get
-- reasonable syntax highlighting and indentation.

vim.filetype.add({
  extension = {
    bsv = "verilog",
  },
})

