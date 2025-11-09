-- ~/.config/nvim/lua/user/plugins/java-dap.lua
return {
  {
    "mfussenegger/nvim-dap",
    optional = true,
    config = function()
      vim.schedule(function() -- <— defer until safe to yield
        local ok, dap = pcall(require, "dap")
        if not ok then
          return
        end

        dap.adapters.java = function(callback, config)
          callback({
            type = "server",
            host = "127.0.0.1",
            port = config.port or 5005,
          })
        end

        dap.configurations.java = {
          {
            type = "java",
            request = "attach",
            name = "Debug (Attach) - Remote",
            hostName = "127.0.0.1",
            port = 5005,
          },
          {
            type = "java",
            request = "launch",
            name = "Launch Java Program",
            mainClass = function()
              return vim.fn.input("Main class > ", "", "file")
            end,
            projectName = vim.fn.fnamemodify(vim.fn.getcwd(), ":t"),
            cwd = "${workspaceFolder}",
            console = "integratedTerminal",
          },
        }
      end)
    end,
  },
}
