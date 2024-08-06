return {
    "vim-airline/vim-airline",
    lazy = false,
    dependencies = {
        "vim-airline/vim-airline-themes"
    },
    init = function()
        vim.g["airline#extensions#whitespace#max_lines"] = 20000
        vim.g["airline#extensions#tagbar#enabled"] = 0
        vim.g["airline#extensions#tabline#enabled"] = 1
        vim.g["airline#extensions#tmuxline#enabled"] = 1
        vim.g["airline#extensions#tmuxline#snapshot_file"] = "~/.tmux-statusline-colors.conf"
        vim.g["airline#extensions#nvimlsp#enabled"] = 1

        vim.g.airline_powerline_fonts = true
        vim.g.airline_theme = "nightfly"
    end,
}