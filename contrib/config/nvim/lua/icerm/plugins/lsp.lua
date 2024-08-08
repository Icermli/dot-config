return {
    'neovim/nvim-lspconfig',
    lazy = false,
    dependencies = {
        { 'williamboman/mason.nvim' },
        { 'williamboman/mason-lspconfig.nvim' },
        { 'WhoIsSethDaniel/mason-tool-installer.nvim' },
        { 'ms-jpq/coq_nvim', branch = 'coq' }, 
        { 'ms-jpq/coq.artifacts', branch = 'artifacts' },
        { 'ms-jpq/coq.thirdparty', branch = '3p' },
    },
    init = function()
        vim.g.coq_settings = { 
            auto_start = true
        }
    end,
    config = function()
        require('mason').setup()
        require('mason-lspconfig').setup()

        local coq = require('coq')

        -- mojo
        require('lspconfig')['mojo'].setup {}

        --
        -- Automatically set up LSP servers installed via mason.nvim
        --
        require('mason-lspconfig').setup_handlers {
            -- The first entry (without a key) will be the default handler
            -- and will be called for each installed server that doesn't have
            -- a dedicated handler.
            function (server_name) -- default handler (optional)
                require('lspconfig')[server_name].setup {
                    coq.lsp_ensure_capabilities{
                        on_attach = on_attach,
                        single_file_support = false
                    }
                }
            end,
            -- Next, you can provide a dedicated handler for specific servers.
            -- For example, a handler override for the `rust_analyzer`:
            -- ['rust_analyzer'] = function ()
            --     require('rust-tools').setup {
            --         coq.lsp_ensure_capabilities() }
            -- end
            ['ruff_lsp'] = function()
                require('lspconfig')['ruff_lsp'].setup {
                    on_attach = function(client, bufnr)
                        client.server_capabilities.hoverProvider = false
                    end,
                }
            end,
            ['beancount'] = function()
                require('lspconfig')['beancount'].setup {
                    init_options = {
                        journal_file = '~/Personal/accounting/main.beancount',
                    };
                    coq.lsp_ensure_capabilities{
                        on_attach = on_attach,
                        single_file_support = false
                    };
                };
            end,
        }

        require("mason-tool-installer").setup({
            ensure_installed = {
                "prettier", -- prettier formatter
                "stylua", -- lua formatter
                "isort", -- python formatter
                "black", -- python formatter
            },
        })

        -- Add python filetype to pyopencl for proper lsp mapping to happend
        vim.api.nvim_create_autocmd('FileType', { pattern = 'pyopencl', command = ':set filetype=pyopencl.python' })

        -- Trigger linters
        vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
            callback = function() require('lint').try_lint() end, })

        local signs = {
            { name = "DiagnosticSignError", text = "✘" },
            { name = "DiagnosticSignWarn", text = "▲" },
            { name = "DiagnosticSignHint", text = "⚑" },
            { name = "DiagnosticSignInfo", text = "»" },
        }
    
        for _, sign in ipairs(signs) do
            vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
        end
    end,
}