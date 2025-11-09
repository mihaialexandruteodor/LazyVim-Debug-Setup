-- ~/.config/nvim/lua/plugins/java.lua
return {
  {
    "nvim-java/nvim-java",
    ft = { "java" },
    dependencies = {
      -- Mason plugins (updated org name)
      { "mason-org/mason.nvim", opts = {} },
      { "mason-org/mason-lspconfig.nvim", opts = {} },

      -- LSP support
      { "neovim/nvim-lspconfig" },
    },
    config = function()
      -- 🧩 Setup nvim-java with its Mason registry
      require("java").setup({
        mason = {
          registries = { "github:nvim-java/mason-registry" },
        },
      })

      -- 🪄 Ensure essential Java tools are installed via Mason
      local ok, mr = pcall(require, "mason-registry")
      if ok then
        local pkgs = { "jdtls", "java-test", "java-debug-adapter" }
        for _, name in ipairs(pkgs) do
          local pkg_ok, pkg = pcall(mr.get_package, name)
          if pkg_ok and not pkg:is_installed() then
            pkg:install()
          end
        end
      end

      -- 🧠 Configure the Java LSP
      local lspconfig = require("lspconfig")
      lspconfig.jdtls.setup({
        cmd = { "jdtls" },
        filetypes = { "java" },
        root_dir = lspconfig.util.root_pattern("build.gradle", "pom.xml", ".git", "settings.gradle"),
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
