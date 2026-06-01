local ok, configs = pcall(require, "nvim-treesitter.configs")
if not ok then return end

configs.setup({
    ensure_installed = {
        "lua", "vim", "vimdoc", "bash",
        "json", "yaml", "toml",
        "markdown", "markdown_inline",
        "html", "css", "xml",
        "python", "javascript", "typescript", "tsx",
        "c", "cpp", "rust", "go",
        "dockerfile", "gitcommit", "diff",
    },
    auto_install = false,
    highlight = { enable = true },
    indent = { enable = true },
})
