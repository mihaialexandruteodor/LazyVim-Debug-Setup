-- ~/.config/nvim/lua/plugins/java.lua
return {
  {
    "nvim-java/nvim-java",
    ft = { "java" },  -- load only on Java files
    dependencies = {
      { "neovim/nvim-lspconfig" },   -- LSP support
      { "mason-org/mason.nvim" },    -- Mason to install tools
    },
    config = function()
      -- Paths
      local data_path = vim.fn.stdpath("data")
      local debug_jar = data_path .. "/mason/packages/java-debug-adapter/extension/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin.jar"

      -- 🧩 Setup nvim-java
      require("java").setup({
        mason = {
          registries = { "github:nvim-java/mason-registry" },
        },
        dap = {
          jar_path = debug_jar,  -- point DAP to the downloaded debug adapter JAR
        },
      })

      -- 🧠 Setup JDTLS via lspconfig
      local lspconfig = require("lspconfig")
      lspconfig.jdtls.setup({
        cmd = { "jdtls" }, -- system-installed JDTLS
        filetypes = { "java" },
        root_dir = lspconfig.util.root_pattern("build.gradle", "pom.xml", ".git"),
        settings = {
          java = {
            signatureHelp = { enabled = true },
            contentProvider = { preferred = "fernflower" },
          },
        },
      })

      -- 🏃 Automatically run java-test if available
      local ok, java_test = pcall(require, "java-test")
      if ok then
        java_test.setup({})
      end

      vim.notify("✅ nvim-java & JDTLS & DAP configured", vim.log.levels.INFO)
    end,
  },
}
