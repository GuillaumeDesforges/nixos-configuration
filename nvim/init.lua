-- change leader key to spacebar
vim.g.mapleader = " "

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

-- feline
vim.opt.termguicolors = true
require'nvim-web-devicons'.setup{
    -- globally enable different highlight colors per icon (default to true)
    -- if set to false all icons will have the default icon's color
    color_icons = true;
    -- globally enable default icons (default to false)
    -- will get overriden by `get_icons` option
    default = true;
    -- globally enable "strict" selection of icons - icon will be looked up in
    -- different tables, first by filename, and if not found by extension; this
    -- prevents cases when file doesn't have any extension but still gets some icon
    -- because its name happened to match some extension (default to false)
    strict = true;
}
require('feline').setup()

-- telescope
require('telescope').setup{
  defaults = {
    -- Default configuration for telescope goes here:
    mappings = {
      i = {
        -- map actions.which_key to <C-h> (default: <C-/>)
        -- actions.which_key shows the mappings for your picker,
        -- e.g. git_{create, delete, ...}_branch for the git_branches picker
        -- ["<C-h>"] = "which_key"
      }
    }
  },
  pickers = {
    -- Default configuration for builtin pickers goes here:
    -- picker_name = {
    --   picker_config_key = value,
    --   ...
    -- }
    -- Now the picker_config_key will be applied every time you call this
    -- builtin picker
  },
  extensions = {
    -- Your extension configuration goes here:
    -- extension_name = {
    --   extension_config_key = value,
    -- }
    -- please take a look at the readme of the extension you want to configure
  }
}
local telescope_builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', telescope_builtin.find_files, {})
vim.keymap.set('n', '<leader>fb', telescope_builtin.buffers, {})
vim.keymap.set('n', '<leader>fg', telescope_builtin.live_grep, {})
