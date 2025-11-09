return {
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate", -- always keep Mason registry up to date
  },
  {
    "nvim-java/nvim-java",
    dependencies = {
      "neovim/nvim-lspconfig",
      "williamboman/mason.nvim", -- ensure Mason is available first
      "williamboman/mason-lspconfig.nvim",
      "nvim-java/language-server",
      "nvim-java/test",
    },
    config = function()
      require("java").setup({
        -- Your nvim-java configuration goes here
      })
    end,
  },
}
