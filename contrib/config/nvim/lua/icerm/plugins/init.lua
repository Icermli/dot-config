return {
    { 'nvim-lua/plenary.nvim' }, -- lua functions that many plugins use
    { 'christoomey/vim-tmux-navigator' }, -- tmux & split window navigation

    -- colorscheme
    { 
        'bluz71/vim-nightfly-colors',
        name = 'nightfly',
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd([[colorscheme nightfly]])

            vim.g.nightflyCursorColor          = true
            vim.g.nightflyNormalFloat          = true
            vim.g.nightflyUnderlineMatchParen  = true
            vim.g.nightflyVirtualTextColor     = true
        end,
    },

    { 'HiPhish/rainbow-delimiters.nvim' }, -- parentheses guides

    -- status line
    {
        'akinsho/bufferline.nvim',
        dependencies = 'nvim-tree/nvim-web-devicons',
        version = "*",
        opts = {
            options = {
            mode = "tabs",
            separator_style = "slant",
            },
        },
    },
    { 
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function() require('lualine').setup({
            sections = {
                lualine_x = { "encoding", { "fileformat", symbols = { unix = "" } }, "filetype" },
            },
        }) end,

    },
    -- fzf
    { 'junegunn/fzf', dir = '~/.local/share/fzf', build = './install --all' },
    { 'ibhagwan/fzf-lua' },

    -- surround
    -- e.g. cs"' das(
    {
        "kylechui/nvim-surround",
        event = { "BufReadPre", "BufNewFile" },
        version = "*", -- Use for stability; omit to use `main` branch for the latest features
        config = true,
    },

    -- comment
    -- e.g. gcc gbc, and in visual mode: gb gc
    {
        'numToStr/Comment.nvim',
        config = function() require('Comment').setup() end,
    },

    -- git
    { 
        'NeogitOrg/neogit',
        dependencies = {
            "nvim-lua/plenary.nvim",         -- required
            "sindrets/diffview.nvim",        -- optional - Diff integration
            "ibhagwan/fzf-lua",              -- optional
          },
          config = true
    },

    -- syntax for languages not supported by treesitter
    { 'david-a-wheeler/vim-metamath' },
    { 'czheo/mojo.vim' },
    { 'sheerun/vim-polyglot' },
    { 'nathangrigg/vim-beancount' },
    { 'hjson/vim-hjson' },

    -- treesitter
    {
        'nvim-treesitter/nvim-treesitter',
        build = function()
            local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
            ts_update()
        end,
    },
    { 'nvim-treesitter/nvim-treesitter-context' },

    -- linters
    { 
        'j-hui/fidget.nvim',
        config = function() require('fidget').setup() end,
    },
    { 'mfussenegger/nvim-lint' },

    -- snippets
    {
        "L3MON4D3/LuaSnip",
        -- follow latest release.
        version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
        -- install jsregexp (optional!:).
        build = "make install_jsregexp"
    },
}
