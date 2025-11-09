-- ~/.config/nvim/lua/plugins/java.lua
return {
  {
    "nvim-java/nvim-java",
    ft = { "java" },  -- load only on Java files
    dependencies = {
      { "neovim/nvim-lspconfig" },  -- LSP support
    },
    config = function()
      -- 🧩 Bootstrap nvim-java with automatic DAP
      require("java").setup({
        dap = true,  -- automatically download/setup Java debug adapter
      })

      -- 🧠 Configure JDTLS via lspconfig
      local lspconfig = require("lspconfig")
      lspconfig.jdtls.setup({
        cmd = { "jdtls" },  -- uses system-installed JDTLS
        filetypes = { "java" },
        root_dir = lspconfig.util.root_pattern("build.gradle", "pom.xml", ".git"),
      })

      vim.notify("✅ nvim-java & JDTLS loaded with DAP support", vim.log.levels.INFO)
    end,
  },
}
