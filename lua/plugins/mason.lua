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

      local mr = require("mason-registry")

      -- Ensure jdtls and java-test are installed via Mason
      for _, pkg_name in ipairs({ "jdtls", "java-test" }) do
        local ok, pkg = pcall(mr.get_package, pkg_name)
        if ok and pkg and not pkg:is_installed() then
          pkg:install()
        end
      end

      -- Setup java-debug-adapter manually
      local debug_pkg_path = vim.fn.stdpath("data") .. "/mason/packages/java-debug-adapter"
      local debug_jar = debug_pkg_path .. "/extension/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin.jar"

      -- If the JAR is missing, download VSIX and extract it
      if vim.fn.filereadable(debug_jar) == 0 then
        vim.fn.mkdir(debug_pkg_path, "p")

        local vsix_url = "https://marketplace.visualstudio.com/_apis/public/gallery/publishers/ms-vscode/vsextensions/java-debug/latest/vspackage"
        local vsix_path = debug_pkg_path .. "/java-debug.vsix"

        vim.notify("⬇️ Downloading java-debug VSIX...", vim.log.levels.INFO)
        vim.fn.system({"curl", "-L", "-o", vsix_path, vsix_url})

        vim.notify("📦 Extracting java-debug VSIX...", vim.log.levels.INFO)
        vim.fn.system({"unzip", "-o", vsix_path, "-d", debug_pkg_path})

        vim.notify("✅ java-debug-adapter ready", vim.log.levels.INFO)
      end
    end,
  },
}
