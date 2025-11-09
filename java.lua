-- ~/.config/nvim/lua/user/plugins/java.lua
return {
  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "java" } },
  },

  -- Mason packages for Java debugging & testing
  {
    "mason-org/mason.nvim",
    opts = { ensure_installed = { "java-debug-adapter", "java-test" } },
  },

  -- LSP config (defer jdtls setup to nvim-jdtls)
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = { jdtls = {} },
      setup = {
        jdtls = function()
          return true -- avoid duplicate servers
        end,
      },
    },
  },

  -- Java LSP + DAP + Test integration
  {
    "mfussenegger/nvim-jdtls",
    ft = { "java" },
    dependencies = { "folke/which-key.nvim" },
    opts = function()
      local cmd = { vim.fn.exepath("jdtls") }
      if require("lazyvim.util").has("mason.nvim") then
        local lombok_jar = vim.fn.expand("$MASON/share/jdtls/lombok.jar")
        table.insert(cmd, string.format("--jvm-arg=-javaagent:%s", lombok_jar))
      end
      return {
        root_dir = function(path)
          return vim.fs.root(path, vim.lsp.config.jdtls.root_markers)
        end,
        project_name = function(root_dir)
          return root_dir and vim.fs.basename(root_dir)
        end,
        jdtls_config_dir = function(project_name)
          return vim.fn.stdpath("cache") .. "/jdtls/" .. project_name .. "/config"
        end,
        jdtls_workspace_dir = function(project_name)
          return vim.fn.stdpath("cache") .. "/jdtls/" .. project_name .. "/workspace"
        end,
        cmd = cmd,
        full_cmd = function(opts)
          local fname = vim.api.nvim_buf_get_name(0)
          local root_dir = opts.root_dir(fname)
          local project_name = opts.project_name(root_dir)
          local cmd = vim.deepcopy(opts.cmd)
          if project_name then
            vim.list_extend(cmd, {
              "-configuration",
              opts.jdtls_config_dir(project_name),
              "-data",
              opts.jdtls_workspace_dir(project_name),
            })
          end
          return cmd
        end,
        dap = { hotcodereplace = "auto", config_overrides = {} },
        dap_main = {},
        test = true,
        settings = {
          java = {
            inlayHints = {
              parameterNames = { enabled = "all" },
            },
          },
        },
      }
    end,
    config = function(_, opts)
      local wk = require("which-key")
      local bundles = {}
      if require("lazyvim.util").has("mason.nvim") and opts.dap then
        local mason_registry = require("mason-registry")
        if mason_registry.is_installed("java-debug-adapter") then
          bundles = vim.fn.glob("$MASON/share/java-debug-adapter/com.microsoft.java.debug.plugin-*jar", false, true)
          if opts.test and mason_registry.is_installed("java-test") then
            vim.list_extend(bundles, vim.fn.glob("$MASON/share/java-test/*.jar", false, true))
          end
        end
      end

      local function attach_jdtls()
        local fname = vim.api.nvim_buf_get_name(0)
        local config = vim.tbl_extend("force", {
          cmd = opts.full_cmd(opts),
          root_dir = opts.root_dir(fname),
          init_options = { bundles = bundles },
          settings = opts.settings,
        }, opts.jdtls)
        require("jdtls").start_or_attach(config)
      end

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "java",
        callback = attach_jdtls,
      })

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client and client.name == "jdtls" then
            -- Keymaps for Java refactoring & tests
            wk.register({
              ["<leader>cxv"] = { require("jdtls").extract_variable_all, "Extract Variable" },
              ["<leader>cxc"] = { require("jdtls").extract_constant, "Extract Constant" },
              ["<leader>cxm"] = { function() require("jdtls").extract_method(true) end, "Extract Method" },
              ["<leader>cgs"] = { require("jdtls").super_implementation, "Goto Super" },
              ["<leader>co"]  = { require("jdtls").organize_imports, "Organize Imports" },
              ["<leader>tt"]  = { function() require("jdtls.dap").test_class() end, "Run All Tests" },
              ["<leader>tr"]  = { function() require("jdtls.dap").test_nearest_method() end, "Run Nearest Test" },
              ["<leader>tT"]  = { require("jdtls.dap").pick_test, "Pick Test" },
            }, { buffer = args.buf })
            
            -- Setup DAP for Java
            if opts.dap and require("lazyvim.util").has("nvim-dap") then
              require("jdtls").setup_dap(opts.dap)
              if opts.dap_main then
                require("jdtls.dap").setup_dap_main_class_configs(opts.dap_main)
              end
            end
          end
        end,
      })

      attach_jdtls()
    end,
  },

  -- DAP configuration for remote attach
  {
    "mfussenegger/nvim-dap",
    optional = true,
    opts = function()
      local dap = require("dap")
      dap.configurations.java = {
        {
          type = "java",
          request = "attach",
          name = "Debug (Attach) - Remote",
          hostName = "127.0.0.1",
          port = 5005,
        },
      }
    end,
  },
}
