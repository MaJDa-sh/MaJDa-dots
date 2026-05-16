return {
  {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonUpdate" },
    opts = {
      ensure_installed = {
        "lua-language-server",
        "typescript-language-server",
        "gopls",
        "prettierd",
      },
    },
  },
  {
    "williamboman/mason-lspconfig.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = { "lua_ls", "ts_ls", "gopls" },
      automatic_installation = true,
    },
  },
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    dependencies = { "hrsh7th/cmp-nvim-lsp", "williamboman/mason-lspconfig.nvim" },
    config = function()
      vim.diagnostic.config({
        underline = true,
        update_in_insert = false,
        virtual_text = {
          spacing = 2,
          source = "if_many",
          prefix = "●",
        },
        severity_sort = true,
        float = { border = "rounded", source = "if_many" },
      })

      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      local on_attach = function(_, bufnr)
        local map = function(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
        end

        map("n", "gD", vim.lsp.buf.declaration, "LSP declaration")
        map("n", "gd", vim.lsp.buf.definition, "LSP definition")
        map("n", "K", vim.lsp.buf.hover, "LSP hover")
        map("n", "gi", vim.lsp.buf.implementation, "LSP implementation")
        map("n", "<leader>ls", vim.lsp.buf.signature_help, "LSP signature help")
        map("n", "<leader>D", vim.lsp.buf.type_definition, "LSP definition type")
        map("n", "<leader>ra", vim.lsp.buf.rename, "LSP rename")
        map("n", "<leader>ca", vim.lsp.buf.code_action, "LSP code action")
        map("n", "gr", vim.lsp.buf.references, "LSP references")

        map("n", "<leader>lf", function()
          vim.diagnostic.open_float({ border = "rounded" })
        end, "Floating diagnostic")
        map("n", "[d", function()
          vim.diagnostic.goto_prev({ float = { border = "rounded" } })
        end, "Goto prev")
        map("n", "]d", function()
          vim.diagnostic.goto_next({ float = { border = "rounded" } })
        end, "Goto next")
        map("n", "<leader>q", vim.diagnostic.setloclist, "Diagnostic setloclist")
        map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, "Add workspace folder")
        map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, "Remove workspace folder")
        map("n", "<leader>wl", function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, "List workspace folders")
      end

      local function setup(server, opts)
        opts = opts or {}
        opts.capabilities = capabilities
        opts.on_attach = on_attach
        opts.flags = vim.tbl_extend("force", opts.flags or {}, { debounce_text_changes = 300 })
        vim.lsp.config(server, opts)
        vim.lsp.enable(server)
      end

      setup("lua_ls", {
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
            telemetry = { enable = false },
            workspace = { checkThirdParty = false },
          },
        },
      })

      setup("ts_ls", {
        cmd = { "typescript-language-server", "--stdio" },
        init_options = {
          maxTsServerMemory = 1024,
        },
        filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
      })

      setup("gopls", {
        filetypes = { "go", "gomod" },
        settings = {
          gopls = {
            analyses = { unusedparams = true },
            staticcheck = false,
            gofumpt = true,
          },
        },
      })

      local ft_servers = {
        lua = { "lua_ls" },
        javascript = { "ts_ls" },
        javascriptreact = { "ts_ls" },
        typescript = { "ts_ls" },
        typescriptreact = { "ts_ls" },
        go = { "gopls" },
        gomod = { "gopls" },
      }

      local function ensure_servers_for_buffer(bufnr, ft)
        local servers = ft_servers[ft]
        if not servers or vim.bo[bufnr].buftype ~= "" then
          return
        end

        for _, server in ipairs(servers) do
          local attached = false
          for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
            if client.name == server then
              attached = true
              break
            end
          end
          if not attached then
            pcall(vim.cmd, "LspStart " .. server)
          end
        end
      end

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("UserLspFirstBufferFix", { clear = true }),
        callback = function(args)
          ensure_servers_for_buffer(args.buf, vim.bo[args.buf].filetype)
        end,
      })

      vim.defer_fn(function()
        for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
          if vim.api.nvim_buf_is_loaded(bufnr) then
            ensure_servers_for_buffer(bufnr, vim.bo[bufnr].filetype)
          end
        end
      end, 20)
    end,
  },
}
