return {
    'neovim/nvim-lspconfig',
    lazy = false,
    dependencies = {
        { 'williamboman/mason.nvim' },
        { 'williamboman/mason-lspconfig.nvim' },
        { 'WhoIsSethDaniel/mason-tool-installer.nvim' },
        { 'ms-jpq/coq_nvim',       branch = 'coq',       lazy = true }, 
        { 'ms-jpq/coq.artifacts',  branch = 'artifacts', lazy = true },
        { 'ms-jpq/coq.thirdparty', branch = '3p',        lazy = true },
    },
    init = function()
        vim.g.coq_settings = { 
            auto_start = 'shut-up',
            -- recommended minimal settings
            display = { pum = { fast_close = false } },
            keymap = { recommended = false },   -- if you want to define your own bindings
        }
    end,
    config = function()
        require('mason').setup({
            ui = { border = "rounded" },
        })
        require("mason-tool-installer").setup({
            ensure_installed = {
                "prettier", 
                "stylua", 
                "isort", 
                "black",
                "eslint_d",
                "ruff",
            },
            auto_update = true,
            run_on_start = true,
        })

        local coq = require('coq')

        local on_attach = function(client, bufnr)
            -- Your keymaps, etc. here
            -- Example:
            -- vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = bufnr })
            -- vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = bufnr })
            -- ...

            -- If you still want coq keymaps, define them manually since recommended = false
        end
        require('mason-lspconfig').setup({
            ensure_installed = {
                "html",
                "cssls",
                "tailwindcss",
                "svelte",
                "lua_ls",
                "graphql",
                "emmet_ls",
                "prismals",
            },
            -- automatic_installation = true,    
        })

        -- Default / fallback for auto-installed servers
        vim.lsp.config('*', {
            on_attach = on_attach,
            capabilities = coq.lsp_ensure_capabilities({}).capabilities,
            single_file_support = false,
        })

        -- pyright example
        vim.lsp.config('pyright', {
            on_attach = on_attach,
            capabilities = coq.lsp_ensure_capabilities({}).capabilities,
            settings = {
                python = {
                    analysis = {
                        autoSearchPaths = true,
                        useLibraryCodeForTypes = true,
                        diagnosticMode = 'workspace',
                        typeCheckingMode = 'standard',  -- or 'strict'
                    },
                },
            },
        })

        -- ruff (modern name; disable hover if you prefer another source)
        vim.lsp.config('ruff', {
            on_attach = function(client, bufnr)
                on_attach(client, bufnr)
                client.server_capabilities.hoverProvider = false
            end,
            capabilities = coq.lsp_ensure_capabilities({}).capabilities,
        })

        -- beancount
        vim.lsp.config('beancount', {
            on_attach = on_attach,
            capabilities = coq.lsp_ensure_capabilities({}).capabilities,
            init_options = {
                journal_file = '~/Personal/accounting/main.beancount',
            },
        })

        -- Add python filetype to pyopencl for proper lsp mapping to happend
        vim.api.nvim_create_autocmd('FileType', { 
            pattern = 'pyopencl', 
            command = ':set filetype=pyopencl.python',
        })

        -- Trigger linters
        -- vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
        --     callback = function() require('lint').try_lint() end, })

        vim.diagnostic.config({
            signs = {
                text = {
                    [vim.diagnostic.severity.ERROR] = "✘",
                    [vim.diagnostic.severity.WARN]  = "▲",
                    [vim.diagnostic.severity.HINT]  = "⚑",
                    [vim.diagnostic.severity.INFO]  = "»",
                },
                -- optional: highlight groups (recommended)
                texthl = {
                    [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
                    [vim.diagnostic.severity.WARN]  = "DiagnosticSignWarn",
                    [vim.diagnostic.severity.HINT]  = "DiagnosticSignHint",
                    [vim.diagnostic.severity.INFO]  = "DiagnosticSignInfo",
                },
                -- optional: number column signs
                numhl = {
                    -- [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
                    -- ...
                },
            },

            -- your other settings
            virtual_text = { prefix = "●" },
            underline = true,
            update_in_insert = false,
            severity_sort = true,
            float = { border = "rounded" },
        })
    end,
}