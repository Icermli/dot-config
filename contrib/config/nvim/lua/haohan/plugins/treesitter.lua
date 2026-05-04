return {
    'nvim-treesitter/nvim-treesitter',
    branch = "master",
    event = { "BufReadPre", "BufNewFile" },
    build = ":TSUpdate",
    dependencies = {
        "windwp/nvim-ts-autotag",
    },
    config = function()
        -- import nvim-treesitter plugin
        local treesitter = require("nvim-treesitter.configs")
        local query = require("vim.treesitter.query")
        local directive_opts = vim.fn.has("nvim-0.10") == 1 and { force = true, all = false } or true
        local markdown_injection_aliases = {
            ex = "elixir",
            pl = "perl",
            sh = "bash",
            uxn = "uxntal",
            ts = "typescript",
        }

        query.add_directive("set-lang-from-info-string!", function(match, _, bufnr, pred, metadata)
            local capture = match[pred[2]]
            local node = type(capture) == "table" and capture[1] or capture
            if not node then
                return
            end

            local injection_alias = vim.treesitter.get_node_text(node, bufnr):lower()
            metadata["injection.language"] = vim.filetype.match({ filename = "a." .. injection_alias })
                or markdown_injection_aliases[injection_alias]
                or injection_alias
        end, directive_opts)

        treesitter.setup({
            highlight = {
                enable = true,
            },
            -- enable indentation
            indent = { enable = true },
            -- enable autotagging (w/ nvim-ts-autotag plugin)
            autotag = {
                enable = true,
            },
            -- ensure these language parsers are installed
            ensure_installed = {
                "json",
                "javascript",
                "typescript",
                "tsx",
                "yaml",
                "html",
                "css",
                "prisma",
                "markdown",
                "markdown_inline",
                "svelte",
                "graphql",
                "bash",
                "lua",
                "vim",
                "dockerfile",
                "gitignore",
                "query",
                "vimdoc",
                "c",
                "python",
            },
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection      = "<C-n>",
                    node_incremental    = "<C-n>",
                    scope_incremental   = false, -- 如果 tmux 没用 Ctrl+s 冻结功能
                    node_decremental    = "<C-p>",
                },
            },
        })
    end,
}