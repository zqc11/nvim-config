-- lua/plugins/rust.lua
return {
    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                rust_analyzer = {
                    settings = {
                        ["rust-analyzer"] = {
                            cargo = {
                                buildScripts = {
                                    enable = true,
                                },
                                allFeatures = true,
                            },
                            files = {
                                excludeDirs = { "target", "tests" },
                            },
                            cachePriming = {
                                enable = true,
                            },
                            maxMemory = "4096",
                        },
                    },
                },
            },
        },
    },
}
