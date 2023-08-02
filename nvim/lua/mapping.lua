local telescope_builtin = require('telescope.builtin')

-- change leader key to spacebar
vim.g.mapleader = " "

-- define mappings
local mappings = {
  n = {
    {'<leader>ff', telescope_builtin.find_files, desc = "Open telescope to search files"},
    {'<leader>fb', telescope_builtin.buffers, desc = "Open telescope to search buffers"}
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
