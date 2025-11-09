-- ~/.config/nvim/lua/plugins/java.lua
return {
  {
    "nvim-java/nvim-java",
    ft = { "java" },
    dependencies = {
      -- LSP support
      {
        "neovim/nvim-lspconfig",
        opts = {
          -- Declare servers you want LazyVim to manage
          servers = {
            jdtls = {},
          },
          -- Custom setup for jdtls
          setup = {
            jdtls = function()
              require("java").setup({
                -- Ensure Mason knows about nvim-java registry
                mason = {
                  registries = { "github:nvim-java/mason-registry" },
                },
              })
            end,
          },
        },
      },

      -- Mason for managing LSPs and tools
      { "mason-org/mason.nvim", opts = {} },
      { "mason-org/mason-lspconfig.nvim", opts = {} },
    },
    config = function()
      -- Notify when Java config is ready
      vim.notify("✅ nvim-java & JDTLS configured via LazyVim", vim.log.levels.INFO)
    end,
  },
}
