vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

-- Relative lines on/off
vim.keymap.set('n', '<leader>0', ':set relativenumber!<CR>', { silent = true, desc = "Toggle relative line numbers" })

-- Jump to matching () using m
vim.keymap.set({'n', 'v', 'o'}, 'gm', '%', { desc = "Go to matching pair" })

-- call current line as a terminal command, paste below
vim.keymap.set("n", "<leader>,", function()
  local cmd = vim.fn.getline(".")
  if cmd == "" then return end

  local output = vim.fn.systemlist(cmd)
  if #output > 0 then
    vim.api.nvim_put(output, "l", true, true)
  end
  if vim.v.shell_error ~= 0 then
    vim.notify("Command failed: " .. cmd, vim.log.levels.ERROR)
  end
end, { desc = "Run line and paste output" })

-- Toggle virtualedit
local function toggleVirtualedit()
  if vim.o.virtualedit == '' then
    vim.o.virtualedit = 'all'
    print('Virtualedit ON')
  else
    vim.o.virtualedit = ''
    print('Virtualedit OFF')
  end
end
-- vim.api.nvim_set_keymap('n', '<leader>V', 
--   "<cmd>lua if vim.o.virtualedit == '' then vim.o.virtualedit = 'all' " ..
--   "else vim.o.virtualedit = '' end<CR>", 
--   {noremap = true, silent = true, desc = "Toggle virtualedit"})
vim.keymap.set('n', '<leader>V', toggleVirtualedit, { desc = "Toggle free cursor movement" })

-- use jk to exit insert mode
vim.keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

-- clear search highlights
vim.keymap.set("n", "<leader>n", "", { desc = "Search" })
vim.keymap.set("n", "<leader>nh", "<cmd>nohlsearch<CR>", { desc = "Clear search highlights" })

-- Navigation and Searching: Ctrl + p/f/k/b
-- * fzf for fuzzy search
-- Fuzzy finding ─────────────────────────────────────────────────
vim.keymap.set('n', '<leader>f', '', { desc = 'Find' })   -- optional group label
vim.keymap.set('n', '<leader>ff', '<cmd>FzfLua files<CR>',       { desc = "Find files" })
vim.keymap.set('n', '<leader>fb', '<cmd>FzfLua buffers<CR>',     { desc = "Find open buffers" })
vim.keymap.set('n', '<leader>fg', '<cmd>FzfLua live_grep<CR>',   { desc = "Search text in project" })
vim.keymap.set('n', '<leader>fh', '<cmd>FzfLua help_tags<CR>',   { desc = "Search help tags" })

-- ── Window management ─────────────────────────────
vim.keymap.set("n", "<leader>w", "", { desc = "Window focus" })   -- which-key group
vim.keymap.set("n", "<Leader>wh", "<cmd>wincmd h<cr>", { silent = true, desc = "Focus left window" })
vim.keymap.set("n", "<Leader>wj", "<cmd>wincmd j<cr>", { silent = true, desc = "Focus lower window" })
vim.keymap.set("n", "<Leader>wk", "<cmd>wincmd k<cr>", { silent = true, desc = "Focus upper window" })
vim.keymap.set("n", "<Leader>wl", "<cmd>wincmd l<cr>", { silent = true, desc = "Focus right window" })

-- ── Quickfix ─────────────────────────────────────
vim.keymap.set("n", "<leader>c", "", { desc = "Quickfix list" })  -- which-key group
vim.keymap.set("n", "<Leader>cn", "<cmd>cnext<cr>", { silent = true, desc = "Next quickfix item" })
vim.keymap.set("n", "<Leader>cp", "<cmd>cprevious<cr>", { silent = true, desc = "Previous quickfix item" })
vim.keymap.set("n", "<Leader>cq", "<cmd>cclose<cr>", { silent = true, desc = "Close quickfix list" })

-- Fold group (for which-key)
vim.keymap.set("n", "<leader>z", "", { desc = "Code folds" })
vim.keymap.set("n", "<leader>za", "za", { desc = "Toggle fold" })
vim.keymap.set("n", "<leader>zo", "zo", { desc = "Open fold" })
vim.keymap.set("n", "<leader>zc", "zc", { desc = "Close fold" })
vim.keymap.set("n", "<leader>zR", "zR", { desc = "Open all folds" })
vim.keymap.set("n", "<leader>zM", "zM", { desc = "Close all folds" })
vim.keymap.set("n", "<leader>zr", "zr", { desc = "Open one fold level" })
vim.keymap.set("n", "<leader>zm", "zm", { desc = "Close one fold level" })

-- ── Git ───────────────────────────────────────────
vim.keymap.set("n", "<leader>g", "", { desc = "Git" })
vim.keymap.set("n", "<leader>gs", "<cmd>Neogit cwd=%:p:h<CR>", { desc = "Open Git status" })
vim.keymap.set("n", "<leader>gc", "<cmd>Neogit commit cwd=%:p:h<CR>", { desc = "Commit changes" })
vim.keymap.set("n", "<leader>gp", "<cmd>Neogit pull<CR>", { desc = "Pull from remote" })
vim.keymap.set("n", "<leader>gP", "<cmd>Neogit push<CR>", { desc = "Push to remote" })
vim.keymap.set("n", "<leader>gb", "<cmd>Neogit branch<CR>", { desc = "Manage branches" })
vim.keymap.set("n", "<leader>gl", "<cmd>Neogit log<CR>", { desc = "View Git log" })

-- ──────────────────────────────────────────────────────────────
-- LSP Keymaps ───────────────────────────────────────────────────
-- ──────────────────────────────────────────────────────────────

local lsp = vim.lsp.buf
local diag = vim.diagnostic

-- Helper: toggle diagnostics globally
local function toggle_diagnostics()
  local current = diag.config().virtual_text  -- or use underline, signs, etc.
  local state = not current

  diag.config({
    virtual_text = state,
    signs       = state,
    underline   = state,
    update_in_insert = state,
  })

  vim.notify("Diagnostics " .. (state and "ON" or "OFF"), vim.log.levels.INFO)
end

-- Main LSP prefix: <leader>l
vim.keymap.set("n", "<leader>l", "", { desc = "LSP and code" })   -- acts as group label for which-key

-- ── Navigation / Jump ──────────────────────────────────────────
vim.keymap.set("n", "<leader>ld", lsp.definition,       { desc = "Go to definition" })
vim.keymap.set("n", "<leader>lD", lsp.declaration,      { desc = "Go to declaration" })
vim.keymap.set("n", "<leader>li", lsp.implementation,   { desc = "Go to implementation" })
vim.keymap.set("n", "<leader>lt", lsp.type_definition,  { desc = "Go to type definition" })
vim.keymap.set("n", "<leader>lR", lsp.references,       { desc = "Find references" })

-- ── Information ────────────────────────────────────────────────
vim.keymap.set("n", "<leader>lh", lsp.hover,            { desc = "Show hover docs" })
vim.keymap.set("n", "<leader>ls", lsp.signature_help,   { desc = "Show signature help" })
vim.keymap.set("n", "<leader>lw", lsp.workspace_symbol, { desc = "Search workspace symbols" })

-- ── Diagnostics ────────────────────────────────────────────────
vim.keymap.set("n", "<leader>le", diag.open_float,      { desc = "Show line diagnostics" })
vim.keymap.set("n", "]d",         diag.goto_next,       { desc = "Next diagnostic" })
vim.keymap.set("n", "[d",         diag.goto_prev,       { desc = "Previous diagnostic" })
vim.keymap.set("n", "<leader>ll", diag.setloclist,      { desc = "Diagnostics to location list" })   -- optional

-- ── Actions ────────────────────────────────────────────────────
vim.keymap.set("n", "<leader>la", lsp.code_action,      { desc = "Show code actions" })
vim.keymap.set("n", "<leader>lf", lsp.format,           { desc = "Format with LSP" })          -- most common
vim.keymap.set("n", "<leader>lr", lsp.rename,           { desc = "Rename symbol" })
vim.keymap.set("v", "<leader>lc", lsp.code_action, { desc = "Code action for selection" })

-- ── Toggle ─────────────────────────────────────────────────────
vim.keymap.set("n", "<leader>lT", toggle_diagnostics,   { desc = "Toggle diagnostic display" })

-- ── Window management ─────────────────────────────
vim.keymap.set("n", "<leader>s", "", { desc = "Split windows" })   -- which-key group
vim.keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split vertically" })
vim.keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split horizontally" })
vim.keymap.set("n", "<leader>se", "<C-w>=", { desc = "Balance split sizes" })
vim.keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" })

-- ── Tabs ──────────────────────────────────────────
vim.keymap.set("n", "<leader>t", "", { desc = "Tabs" })     -- which-key group
vim.keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
vim.keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" }) -- close current tab
vim.keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" }) --  go to next tab
vim.keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" }) --  go to previous tab
vim.keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current file in new tab" }) --  move current buffer to new tab
