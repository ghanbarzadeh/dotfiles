local themes = {
    {
        'folke/tokyonight.nvim',
        -- init = function()
        --     vim.cmd.colorscheme 'catppuccin-mocha'
        -- end,
    },
    {
        "catppuccin/nvim", 
        init = function()
            vim.cmd.colorscheme 'catppuccin-mocha'
        end,
    },
}

return themes

