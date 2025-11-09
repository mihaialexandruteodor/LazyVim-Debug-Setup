-- ~/.config/nvim/lua/plugins/java.lua
return {
  {
    "nvim-java/nvim-java",
    -- Load immediately so setup exists
    lazy = false,
    dependencies = {
      -- LSP support
      { "neovim/nvim-lspconfig" },
      -- Mason (new org name)
      { "mason-org/mason.nvim", config = true },
      { "mason-org/mason-lspconfig.nvim", config = true },
    },
    config = function()
      local ok, java = pcall(require, "java")
      if not ok then
        vim.notify("⚠️ nvim-java plugin not loaded", vim.log.levels.WARN)
        return
      end

      -- 🛠 Setup Mason packages for Java
      local mason_ok, mr = pcall(require, "mason-registry")
      if mason_ok then
        local packages = { "jdtls", "java-debug-adapter", "java-test" }
        for _, name in ipairs(packages) do
          local ok2, pkg = pcall(mr.get_package, name)
          if ok2 and not pkg:is_installed() then
            pkg:install()
          end
        end
      end

      -- 💻 Configure nvim-java
      java.setup({
        mason = {
          registries = { "github:nvim-java/mason-registry" },
        },
      })

      -- 🔧 Setup LSP (JDTLS)
      local lspconfig = require("lspconfig")
      lspconfig.jdtls.setup({
        cmd = { "jdtls" },
        filetypes = { "java" },
        root_dir = lspconfig.util.root_pattern("build.gradle", "pom.xml", ".git"),
        settings = {
          java = {
            signatureHelp = { enabled = true },
            contentProvider = { preferred = "fernflower" },
          },
        },
      })

      -- ⚡ Setup DAP automatically
      local dap_ok, dap = pcall(require, "dap")
      if dap_ok then
        local debug_jar = vim.fn.stdpath("data") ..
                          "/mason/packages/java-debug-adapter/extension/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar"
        java.setup({
          dap = { jar_path = debug_jar },
        })
      else
        vim.notify("⚠️ nvim-dap not loaded, DAP will not work", vim.log.levels.WARN)
      end

      vim.notify("✅ nvim-java & JDTLS configured", vim.log.levels.INFO)
    end,
  },
}
