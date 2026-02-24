-- Force HDL extensions to use the Verilog filetype.
-- Neovim may otherwise detect `.v` as the V programming language.
vim.filetype.add({
  extension = {
    v = "verilog",
    vh = "verilog",
    sv = "verilog",
    svh = "verilog",
  },
})
