-- theming
vim.cmd [[
    colorscheme codedark
]]

-- disable mouse
vim.opt.mouse = ""
-- number/sign columns
vim.opt.relativenumber = true
-- always show the signcolumn, otherwise it would shift the text each time diagnostics appeared/became resolved
vim.opt.signcolumn = "number"
-- share vim clipboard with desktop
vim.opt.clipboard = 'unnamedplus'

-- load plugins
require("plugins/feline")
require("plugins/telescope")

-- load mapping
require("mapping")

