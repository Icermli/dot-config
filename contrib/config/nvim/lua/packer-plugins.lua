return require('packer').startup(function()
    -- packer can manage itself
    use 'wbthomason/packer.nvim'

    -- colorscheme
    use 'gruvbox-community/gruvbox'

    -- indentation guides
    use 'lukas-reineke/indent-blankline.nvim'

    --- parentheses guides
    use {
        'https://gitlab.com/HiPhish/rainbow-delimiters.nvim',
        as = 'rainbow-delimiters.nvim' }

    -- status line
    use {
        'nvim-lualine/lualine.nvim',
        config = function() require('lualine').setup() end }

    -- fzf
    use { 'junegunn/fzf', dir = '~/.local/share/fzf', run = ':call "./install --all"' }
    use { 'ibhagwan/fzf-lua' }

    -- surround
    -- e.g. cs"' das(
    use {
        'kylechui/nvim-surround', tag = '*',
        config = function() require('nvim-surround').setup() end }

    -- comment
    -- e.g. gcc gbc, and in visual mode: gb gc
    use {
        'numToStr/Comment.nvim',
        config = function() require('Comment').setup() end }

    -- git
    use { 'NeogitOrg/neogit', requires = 'nvim-lua/plenary.nvim' }

    -- which-key
    use {
        'folke/which-key.nvim',
        config = function() require('which-key').setup() end }

    -- syntax for languages not supported by treesitter
    use 'david-a-wheeler/vim-metamath'
    use 'czheo/mojo.vim'
    use 'sheerun/vim-polyglot'
    use 'nathangrigg/vim-beancount'
    use 'hjson/vim-hjson'

    -- treesitter
    use {
        'nvim-treesitter/nvim-treesitter',
        run = function()
            local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
            ts_update()
        end,
    }
    use 'nvim-treesitter/nvim-treesitter-context'

    -- lsp & linters
    use {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "neovim/nvim-lspconfig",
    }
    use {
        'j-hui/fidget.nvim', tag = 'v1.2.0',
        config = function() require('fidget').setup() end }
    use 'mfussenegger/nvim-lint'

    -- completion
    use { 'ms-jpq/coq_nvim', branch = 'coq' }
    use { 'ms-jpq/coq.artifacts', branch = 'artifacts' }
    use { 'ms-jpq/coq.thirdparty', branch = '3p' }

    -- snippets
    use({
        "L3MON4D3/LuaSnip",
        -- follow latest release.
        tag = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
        -- install jsregexp (optional!:).
        run = "make install_jsregexp"
    })

end)
