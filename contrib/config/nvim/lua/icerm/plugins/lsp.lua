return {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
    config = function()
        require("mason").setup()
        require("mason-lspconfig").setup()

        vim.g.coq_settings = { auto_start = 'shut-up' }
        local coq = require("coq")

        -- mojo
        require("lspconfig")["mojo"].setup {}

        --
        -- Automatically set up LSP servers installed via mason.nvim
        --
        require("mason-lspconfig").setup_handlers {
            -- The first entry (without a key) will be the default handler
            -- and will be called for each installed server that doesn't have
            -- a dedicated handler.
            function (server_name) -- default handler (optional)
                require("lspconfig")[server_name].setup {
                    coq.lsp_ensure_capabilities{
                        on_attach = on_attach,
                        single_file_support = false
                    }
                }
            end,
            -- Next, you can provide a dedicated handler for specific servers.
            -- For example, a handler override for the `rust_analyzer`:
            -- ["rust_analyzer"] = function ()
            --     require("rust-tools").setup {
            --         coq.lsp_ensure_capabilities() }
            -- end
            ["ruff_lsp"] = function()
                require("lspconfig")["ruff_lsp"].setup {
                    on_attach = function(client, bufnr)
                        client.server_capabilities.hoverProvider = false
                    end,
                }
            end,
            ["beancount"] = function()
                require("lspconfig")["beancount"].setup {
                    init_options = {
                        journal_file = "~/Personal/accounting/main.beancount",
                    };
                    coq.lsp_ensure_capabilities{
                        on_attach = on_attach,
                        single_file_support = false
                    };
                };
            end,
        }

        -- Add python filetype to pyopencl for proper lsp mapping to happend
        vim.api.nvim_create_autocmd('FileType', { pattern = 'pyopencl', command = ':set filetype=pyopencl.python' })

        -- Trigger linters
        vim.api.nvim_create_autocmd({ "BufWritePost" }, {
            callback = function() require("lint").try_lint() end, })
    end,
}