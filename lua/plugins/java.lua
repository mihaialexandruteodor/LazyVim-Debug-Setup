-- lua/plugins/java.lua
return {
  {
    "nvim-java/nvim-java",
    ft = { "java" },
    dependencies = {
      -- Mason and Mason-LSPConfig must be loaded first
      { "mason-org/mason.nvim", opts = {} },
      { "mason-org/mason-lspconfig.nvim", opts = {
          ensure_installed = { "jdtls", "java-debug-adapter", "java-test" },
        }
      },
      -- core LSP config
      { "neovim/nvim-lspconfig", opts = {} },
    },
    config = function()
      -- ensure the custom registry for nvim-java in Mason
      require("java").setup({
        mason = {
          registries = { "github:nvim-java/mason-registry" },
        },
        -- other custom settings for nvim-java
        java = {
          -- example: use Java 17 runtime by default
          configuration = {
            runtimes = {
              {
                name = "JavaSE-17",
                path = vim.fn.expand("~/.local/share/mason/packages/openjdk-17"),
                default = true,
              },
            },
          },
        },
        verification = {
          invalid_order = false,
          duplicate_setup_calls = false,
          invalid_mason_registry = false,
        },
      })

      -- setup the LSP server `jdtls` using lspconfig
      require("lspconfig").jdtls.setup({
        filetypes = { "java" },
        -- Example on_attach and capabilities could be merged from your existing config
        on_attach = function(client, bufnr)
          -- your custom on_attach here
        end,
        capabilities = vim.lsp.protocol.make_client_capabilities(),
        settings = {
          java = {
            -- you can customize settings here
          },
        },
      })

      -- Optionally: install missing tools via Mason programmatically
      local mr = require("mason-registry")
      if not mr.is_installed("java-test") then
        mr.get_package("java-test"):install()
      end
      if not mr.is_installed("java-debug-adapter") then
        mr.get_package("java-debug-adapter"):install()
      end

      -- Print message or set keymaps if you like
      vim.notify("nvim-java is configured", vim.log.levels.INFO)
    end,
  },
}
