-- ~/.config/nvim/lua/plugins/java.lua
return {
  {
    "nvim-java/nvim-java",
    ft = { "java" },
    dependencies = {
      -- Mason plugins (updated org name)
      { "mason-org/mason.nvim", config = true },
      { "mason-org/mason-lspconfig.nvim", config = true },

      -- LSP support
      { "neovim/nvim-lspconfig" },

      -- Java ecosystem modules
      { "nvim-java/language-server" },
      { "nvim-java/test" },
      { "nvim-java/debug" },
      { "nvim-java/core" },
      { "nvim-java/dap" },
    },
    config = function()
      -- 🧩 Ensure Mason knows about the nvim-java registry
      require("java").setup({
        mason = {
          registries = {
            "github:nvim-java/mason-registry",
          },
        },
      })

      -- 🪄 Automatically ensure java tools are installed
      local mr = require("mason-registry")
      local pkgs = { "jdtls", "java-test", "java-debug-adapter" }
      for _, name in ipairs(pkgs) do
        local ok, pkg = pcall(mr.get_package, name)
        if ok and not pkg:is_installed() then
          pkg:install()
        end
      end

      -- 🧠 Configure the Java LSP
      local lspconfig = require("lspconfig")
      lspconfig.jdtls.setup({
        cmd = { "jdtls" },
        filetypes = { "java" },
        root_dir = function(fname)
          return lspconfig.util.root_pattern("build.gradle", "pom.xml", ".git")(fname)
        end,
        settings = {
          java = {
            signatureHelp = { enabled = true },
            contentProvider = { preferred = "fernflower" },
          },
        },
      })

      vim.notify("✅ nvim-java & JDTLS configured", vim.log.levels.INFO)
    end,
  },
}
