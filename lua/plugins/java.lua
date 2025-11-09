-- ~/.config/nvim/lua/plugins/java.lua
return {
  {
    "nvim-java/nvim-java",
    ft = { "java" },
    dependencies = {
      { "neovim/nvim-lspconfig" },
    },
    config = function()
      -- Automatically download and setup Java DAP
      require("java").setup({
        dap = {
          enabled = true,  -- download debug adapter automatically
          adapter_path = vim.fn.stdpath("config") .. "/java-debug",
        },
      })

      -- Configure JDTLS via lspconfig
      local lspconfig = require("lspconfig")
      lspconfig.jdtls.setup({
        cmd = { "jdtls" },
        filetypes = { "java" },
        root_dir = lspconfig.util.root_pattern("build.gradle", "pom.xml", ".git"),
      })

      -- Optional: auto-setup java-test when opening Java files
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "java",
        callback = function()
          local ok, java_test = pcall(require, "java.test")
          if ok then java_test.setup() end
        end,
      })

      vim.notify("✅ nvim-java, JDTLS & DAP fully configured", vim.log.levels.INFO)
    end,
  },
}
