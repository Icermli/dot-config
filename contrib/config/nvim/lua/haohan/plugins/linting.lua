return {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        local lint = require("lint")
        local function active_python()
            local candidates = {}
            if vim.env.CONDA_PREFIX then
                table.insert(candidates, vim.env.CONDA_PREFIX .. "/bin/python")
            end
            if vim.env.VIRTUAL_ENV then
                table.insert(candidates, vim.env.VIRTUAL_ENV .. "/bin/python")
            end
            table.insert(candidates, vim.fn.exepath("python3"))
            table.insert(candidates, vim.fn.exepath("python"))

            for _, python in ipairs(candidates) do
                if python ~= "" and vim.fn.executable(python) == 1 then
                    return python
                end
            end
        end

        local function python_has_module(python, module)
            if not python then
                return false
            end

            local result = vim.system({ python, "-c", "import " .. module }, { text = true }):wait()
            return result.code == 0
        end

        local python_path = active_python()
        if python_has_module(python_path, "pylint") then
            lint.linters.pylint.cmd = python_path
            lint.linters.pylint.args = {
                "-m",
                "pylint",
                "-f",
                "json",
                "--from-stdin",
                function()
                    return vim.api.nvim_buf_get_name(0)
                end,
            }
        end

        lint.linters_by_ft = {
            python = { "pylint" },
        }

        local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

        local function file_in_cwd(file_name)
            return vim.fs.find(file_name, {
                upward = true,
                stop = vim.loop.cwd():match("(.+)/"),
                path = vim.fs.dirname(vim.api.nvim_buf_get_name(0)),
                type = "file",
            })[1]
        end

        local function remove_linter(linters, linter_name)
            for k, v in pairs(linters) do
                if v == linter_name then
                    linters[k] = nil
                    break
                end
            end
        end

        local function linter_in_linters(linters, linter_name)
            for k, v in pairs(linters) do
                if v == linter_name then
                    return true
                end
            end
            return false
        end

        local function remove_linter_if_missing_config_file(linters, linter_name, config_file_name)
            if linter_in_linters(linters, linter_name) and not file_in_cwd(config_file_name) then
                remove_linter(linters, linter_name)
            end
        end

        local function try_linting()
            local linters = lint.linters_by_ft[vim.bo.filetype]

            -- if linters then
            --   -- remove_linter_if_missing_config_file(linters, "eslint_d", ".eslintrc.cjs")
            --   remove_linter_if_missing_config_file(linters, "eslint_d", "eslint.config.js")
            -- end

            lint.try_lint(linters)
        end

        vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
            group = lint_augroup,
            callback = function()
                try_linting()
            end,
        })

        vim.keymap.set("n", "<leader>L", function()
            try_linting()
        end, { desc = "Lint current file" })
    end,
}
