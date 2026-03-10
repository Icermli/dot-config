return {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons", "folke/todo-comments.nvim" },
    opts = {
        focus = true,
    },
    cmd = "Trouble",
    keys = {
        { "<leader>x",  "", desc = "Trouble" },
        { "<leader>xx", "<cmd>Trouble toggle<CR>", desc = "Toggle trouble" },
        { "<leader>xs", "<cmd>Trouble symbols toggle focus=false<CR>", desc = "Document symbols" },
        { "<leader>xw", "<cmd>Trouble diagnostics toggle<CR>", desc = "Workspace diagnostics" },
        { "<leader>xd", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Document diagnostics" },
        { "<leader>xq", "<cmd>Trouble quickfix toggle<CR>", desc = "Quickfix list" },
        { "<leader>xl", "<cmd>Trouble loclist toggle<CR>", desc = "Location list" },
        { "<leader>xt", "<cmd>Trouble todo toggle<CR>", desc = "TODO list" },
    },
}
