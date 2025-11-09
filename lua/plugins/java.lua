-- ~/.config/nvim/lua/plugins/java.lua
return {
  {
    "nvim-java/nvim-java",
    ft = { "java" },  -- load only on Java files
    dependencies = {
      -- LSP support
      { "neovim/nvim-lspconfig" },
    },
    config = function()
      -- Just bootstrap nvim-java
      require("java").setup()

      -- Configure JDTLS via lspconfig
      local lspconfig = require("lspconfig")
      lspconfig.jdtls.setup({
        cmd = { "jdtls" },  -- uses the system-installed jdtls
        filetypes = { "java" },
        root_dir = lspconfig.util.root_pattern("build.gradle", "pom.xml", ".git"),
      })

      vim.notify("✅ nvim-java & JDTLS loaded", vim.log.levels.INFO)
    end,
  },
}
