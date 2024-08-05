-- set leader key to space
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local keymap = vim.keymap

------------------------
-- General Keymaps -----

-- clear search highlights
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })


