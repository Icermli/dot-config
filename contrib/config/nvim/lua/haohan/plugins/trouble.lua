return {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons", "folke/todo-comments.nvim" },
    opts = {
        focus = true,
    },
    cmd = "Trouble",
    keys = {
        { "<leader>x",  "", desc = "Trouble lists" },
        { "<leader>xx", "<cmd>Trouble toggle<CR>", desc = "Toggle Trouble panel" },
        { "<leader>xs", "<cmd>Trouble symbols toggle focus=false<CR>", desc = "Document symbols in Trouble" },
        { "<leader>xw", "<cmd>Trouble diagnostics toggle<CR>", desc = "Workspace diagnostics in Trouble" },
        { "<leader>xd", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Buffer diagnostics in Trouble" },
        { "<leader>xq", "<cmd>Trouble quickfix toggle<CR>", desc = "Quickfix list in Trouble" },
        { "<leader>xl", "<cmd>Trouble loclist toggle<CR>", desc = "Location list in Trouble" },
        { "<leader>xt", "<cmd>Trouble todo toggle<CR>", desc = "TODO comments in Trouble" },
    },
}
