-- ~/.config/nvim/lua/plugins/java-dap.lua
return {
  {
    "mfussenegger/nvim-dap",
    ft = { "java" },
    config = function()
      local dap = require("dap")

      dap.adapters.java = function(callback, config)
        callback({
          type = "executable",
          command = "java",
          args = { "-jar", vim.fn.stdpath("data") .. "/mason/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin.jar" },
        })
      end

      dap.configurations.java = {
        {
          type = "java",
          request = "launch",
          name = "Launch Current File",
          mainClass = function()
            return vim.fn.input("Main class > ", "", "file")
          end,
          projectName = function()
            return vim.fn.input("Project name > ", "")
          end,
        },
      }

      vim.notify("✅ Java DAP configured", vim.log.levels.INFO)
    end,
  },
}
