local telescope_builtin = require('telescope.builtin')
local nvim_tree_api = require('nvim-tree.api')

-- change leader key to spacebar
vim.g.mapleader = " "

-- define mappings
local mappings = {
  n = {
    {'<leader>ff', telescope_builtin.find_files, desc = "Open telescope to search files"},
    {'<leader>fb', telescope_builtin.buffers, desc = "Open telescope to search buffers"},
    {'<leader>flr', telescope_builtin.lsp_references, desc = "Open telescope to search references found by the LSP"},
    {'<leader>fls', telescope_builtin.lsp_document_symbols, desc = "Open telescope to search symbols found by the LSP"},
    {'<leader>flD', telescope_builtin.diagnostics, desc = "Open telescope to search diagnostics found by the LSP"},
    {'<leader>fld', telescope_builtin.lsp_definitions, desc = "Goto the definition of the word under the cursor, if there's only one, otherwise show all options in Telescope"},
    {'<leader>flt', telescope_builtin.lsp_definitions, desc = "Goto the definition of the type of the word under the cursor, if there's only one, otherwise show all options in Telescope"},
    {'<leader>t', nvim_tree_api.tree.toggle, desc = "Toggle nvim-tree"},
  }
}

for key, maps in pairs(mappings) do
  for _, map in ipairs(maps) do
    local mode = key
    local lhs = map[1]
    local rhs = map[2]
    local opts = map[3]
    vim.keymap.set(mode, lhs, rhs, opts)
  end
end
