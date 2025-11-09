-- ~/.config/nvim/lua/plugins/mason.lua
return {
  {
    "mason-org/mason.nvim",
    cmd = "Mason",
    config = function()
      local mason = require("mason")
      mason.setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
        },
      })

      -- Ensure java-related tools are installed
      local mr = require("mason-registry")
      local packages = {
        "jdtls",               -- Java LSP server
        "java-debug-adapter",  -- DAP adapter
        "java-test",           -- Test runner
      }

      for _, name in ipairs(packages) do
        local ok, pkg = pcall(mr.get_package, name)
        if ok and not pkg:is_installed() then
          pkg:install()
        end
      end
    end,
  },
}
