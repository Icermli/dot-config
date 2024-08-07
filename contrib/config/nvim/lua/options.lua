vim.o.number          = true
vim.o.relativenumber = true
vim.o.termguicolors  = true
vim.o.spell          = true
vim.o.spelllang      = 'en,cjk'

vim.o.tabstop        = 4
vim.o.softtabstop    = 4
vim.o.shiftwidth     = 4
vim.o.expandtab      = true

vim.o.autoread       = true
vim.api.nvim_create_autocmd('FocusGained', { pattern = '*', command = ':checktime' })

-- vim.o.noswapfile     = true
-- vim.o.nobackup       = true
vim.o.undodir        = vim.fn.expand('~/.cache/nvim/undodir/')
vim.o.undofile       = true

vim.o.clipboard      = 'unnamedplus'
vim.o.fileencodings  = 'utf-8,gb2312,gb18030,gbk,ucs-bom,cp936,latin1'

vim.o.scrolloff      = 4

-- mainly affects the delay of which-key popup
vim.o.timeout        = true
vim.o.timeoutlen     = 230

-- syntax highlighting for fenced code blocks in md
vim.g.markdown_fenced_languages = {'python', 'javascript', 'html', 'css'}

-- avoid folds messing up syntax highlighting
vim.o.foldmethod     = 'marker'
vim.opt.foldlevel = 3
vim.api.nvim_create_autocmd("Syntax", {
    pattern = "*",
    callback = function()
        vim.cmd("normal zR")
    end,
})

vim.opt.comments:append(":--")
vim.opt.formatoptions = "cql"

-----------------------------------------------------------------------------
-- Set the title of the Kitty tab to the current open file
vim.cmd([[
  augroup KittyTabTitle
    autocmd!
    autocmd BufEnter * call v:lua.set_kitty_tab_title()
  augroup END
]])

function _G.set_kitty_tab_title()
  vim.fn.system("kitty @ set-tab-title " .. vim.fn.expand("%:t"))
end

vim.api.nvim_create_autocmd("VimLeave", {
    pattern = "*",
    callback = function()
        vim.fn.system("kitty @ set-tab-title ''")
    end
})

-----------------------------------------------------------------------------
-- Reload kitty config automatically
local home = os.getenv("HOME")
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = home .. "/.config/kitty/kitty.conf",
  callback = function()
    vim.fn.system("bash -c 'kill -SIGUSR1 $(pgrep kitty)'")
  end,
})

-----------------------------------------------------------------------------
-- hex editing
-- https://vi.stackexchange.com/questions/2232/how-can-i-use-vim-as-a-hex-editor
local function setup_binary_hex_editing(pattern)
  local augroup_name = pattern:gsub("%.", "") .. "BinaryHex"
  local group = vim.api.nvim_create_augroup(augroup_name, { clear = true })

  -- Convert binary file to hex
  local function bin_to_hex()
    vim.cmd('%!xxd')
  end

  -- Convert hex back to binary
  local function hex_to_bin()
    vim.cmd('%!xxd -r')
  end

  vim.api.nvim_create_autocmd('BufReadPre', {
    group = group,
    pattern = pattern,
    callback = function()
      vim.bo.binary = true
    end
  })

  vim.api.nvim_create_autocmd({'BufReadPost', 'BufWritePost'}, {
    group = group,
    pattern = pattern,
    callback = function()
      if vim.bo.binary then
        bin_to_hex()
        vim.bo.filetype = 'xxd'
        if vim.fn.expand('<afile>:p:t') == 'BufWritePost' then
          vim.bo.modified = false
        end
      end
    end
  })

  vim.api.nvim_create_autocmd('BufWritePre', {
    group = group,
    pattern = pattern,
    callback = function()
      if vim.bo.binary then
        hex_to_bin()
      end
    end
  })
end

setup_binary_hex_editing('*.a')
setup_binary_hex_editing('*.bin')
setup_binary_hex_editing('*.dll')
setup_binary_hex_editing('*.o')
setup_binary_hex_editing('*.obj')
setup_binary_hex_editing('*.out')
setup_binary_hex_editing('*.pdf')
setup_binary_hex_editing('*.so.*')
setup_binary_hex_editing('*.sqlite')
setup_binary_hex_editing('*.wasm')


-----------------------------------------------------------------------------
-- exotic filetypes
local function setup_filetypes_and_syntaxes(configs)
  for _, conf in ipairs(configs) do
    local augroup_name = conf.pattern:gsub("%.", ""):gsub("*", "") .. "FTAndSyntax"
    local group = vim.api.nvim_create_augroup(augroup_name, { clear = true })

    -- Set filetype autocommand
    vim.api.nvim_create_autocmd({"BufNewFile", "BufRead"}, {
      group = group,
      pattern = conf.pattern,
      callback = function()
        vim.bo.filetype = conf.filetype
        if conf.syntax then
          vim.cmd("set syntax=" .. conf.syntax)
        end
      end,
    })

    -- Additional autocommands for special cases, e.g., hidden comments
    if conf.special then
      for _, special_conf in ipairs(conf.special) do
        vim.api.nvim_create_autocmd(special_conf.event, {
          group = group,
          pattern = conf.pattern,
          callback = special_conf.callback
        })
      end
    end
  end
end

setup_filetypes_and_syntaxes({
  {pattern = "*.bend", filetype = "bend", syntax = "python"},
  {pattern = "*.kind", filetype = "kind", syntax = "javascript"},
  {pattern = "*.kindelia", filetype = "kindelia", syntax = "javascript"},
  {
    pattern = "*.hvm",
    filetype = "hvm1",
    syntax = "javascript",
    special = {
      {
        event = "BufRead",
        callback = function()
          vim.cmd('syntax region Password start=/^\\/\\/~ end=/$/ " HVM hidden comments')
          vim.cmd('highlight Password ctermfg=red guifg=red ctermbg=red guifg=red')
        end
      }
    }
  },
})
