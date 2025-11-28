vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

-- Relative lines on/off
vim.api.nvim_set_keymap('n', '<leader>0', ':set relativenumber!<CR>', {noremap = true, silent = true})

-- Jump to matching () using m
local modes = {'n', 'v', 'o'} -- Normal, Visual, Operator-pending modes
for _, mode in ipairs(modes) do
  vim.api.nvim_set_keymap(mode, 'm', '%', {noremap = true})
end

-- call current line as a terminal command, paste below
vim.api.nvim_set_keymap('n', '<leader>,', '0y$:r!<C-r>"<CR>', {noremap = true, silent = true, desc = "Run current line as shell command and paste output below" })

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
vim.api.nvim_set_keymap('n', '<leader>V', 
  "<cmd>lua if vim.o.virtualedit == '' then vim.o.virtualedit = 'all' " ..
  "else vim.o.virtualedit = '' end<CR>", 
  {noremap = true, silent = true, desc = "Toggle virtualedit"})

-- use jk to exit insert mode
vim.keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

-- clear search highlights
vim.keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- Navigation and Searching: Ctrl + p/f/k/b
-- * fzf for fuzzy search
vim.keymap.set("n", "<C-P>", "<cmd>lua require('fzf-lua').files()<CR>", { silent = true })
vim.keymap.set("n", "<C-F>", "<cmd>lua require('fzf-lua').blines()<CR>", { silent = true })
vim.keymap.set("n", "<C-G>", "<cmd>FzfLua live_grep<CR>", { silent = true })
vim.keymap.set("v", "<C-G>", "<cmd>lua require('fzf-lua').grep_visual()<CR>", { silent = true })
-- * netrw for file explorer
vim.keymap.set({ "n", "v", "i" }, "<C-B>", "<esc><cmd>Lex<cr>:vertical resize 30<cr>")
-- * move between windows
vim.keymap.set("n", "<Leader>wh", "<cmd>wincmd h<cr>", { silent = true, desc = "Window left" })
vim.keymap.set("n", "<Leader>wj", "<cmd>wincmd j<cr>", { silent = true, desc = "Window down" })
vim.keymap.set("n", "<Leader>wk", "<cmd>wincmd k<cr>", { silent = true, desc = "Window up" })
vim.keymap.set("n", "<Leader>wl", "<cmd>wincmd l<cr>", { silent = true, desc = "Window right" })
-- * move through quickfix
vim.keymap.set("n", "<Leader>cn", "<cmd>cnext<cr>", { silent = true })
vim.keymap.set("n", "<Leader>cp", "<cmd>cprevious<cr>", { silent = true })
vim.keymap.set("n", "<Leader>cq", "<cmd>cclose<cr>", { silent = true })

-- Fold/unfold
-- Increase/decrease fold level and display current fold level
vim.api.nvim_set_keymap('n', '+', 'zr:echo "foldlevel: " . &foldlevel<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '-', 'zm:echo "foldlevel: " . &foldlevel<CR>', {noremap = true})

--
-- Git integration
--
-- all are using the repository of the current file
-- gs = git status, gc = git commit
vim.keymap.set("n", "<Leader>gs", "<cmd>Neogit cwd=%:p:h<CR>")
vim.keymap.set("n", "<Leader>gc", "<cmd>Neogit commit cwd=%:p:h<CR>")

--
-- LSP
--
vim.keymap.set("n", "<leader>dd", "<cmd>lua vim.lsp.buf.declaration()<cr>", { silent = true })
vim.keymap.set("n", "<leader>di", "<cmd>lua vim.lsp.buf.implementation()<cr>", { silent = true })
vim.keymap.set("n", "<leader>dc", "<cmd>lua vim.lsp.buf.definition()<cr>", { silent = true })
vim.keymap.set("n", "<leader>dv", "<cmd>lua vim.lsp.buf.hover()<cr>", { silent = true })
vim.keymap.set("n", "<leader>ds", "<cmd>lua vim.lsp.buf.signature_help()<cr>", { silent = true })
vim.keymap.set("n", "<leader>de", "<cmd>lua vim.lsp.buf.type_definition()<cr>", { silent = true })
vim.keymap.set("n", "<leader>dr", "<cmd>lua vim.lsp.buf.references()<cr>", { silent = true })
vim.keymap.set("n", "<leader>dw", "<cmd>lua vim.lsp.buf.workspace_symbol()<cr>", { silent = true })
vim.keymap.set("n", "<leader>db", "<cmd>lua vim.diagnostic.open_float()<cr>", { silent = true })
vim.keymap.set("n", "<leader>d[", "<cmd>lua vim.diagnostic.goto_prev()<cr>", { silent = true })
vim.keymap.set("n", "<leader>d]", "<cmd>lua vim.diagnostic.goto_next()<cr>", { silent = true })

-- toggle LSP diagnostics on and off
function toggle_lsp()
    local current_state = vim.diagnostic.config().underline
    vim.diagnostic.config({
        underline = not current_state,
        virtual_text = not current_state,
        signs = not current_state,
        update_in_insert = not current_state,
    })
end
vim.api.nvim_set_keymap('n', '<leader>L', '<cmd>lua toggle_lsp()<CR>', {noremap = true, silent = true})

-- window management
vim.keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
vim.keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
vim.keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
vim.keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

vim.keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
vim.keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" }) -- close current tab
vim.keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" }) --  go to next tab
vim.keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" }) --  go to previous tab
vim.keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) --  move current buffer to new tab

-- --
-- -- AI
-- --
-- local ai = require('ai')
-- vim.keymap.set('n', '<leader>ag', function() ai.FillHoles('gpt-4-0125-preview') end, {silent = true})
-- vim.keymap.set('n', '<leader>aG', function() ai.FillHoles('gpt-4-32k-0314') end, {silent = true})
-- vim.keymap.set('n', '<leader>ac', function() ai.FillHoles('claude-3-haiku-20240307') end, {silent = true})
-- vim.keymap.set('n', '<leader>aC', function() ai.FillHoles('claude-3-opus-20240229') end, {silent = true})
