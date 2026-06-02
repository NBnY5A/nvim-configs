return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        gopls = {
          -- 1. Isso ativa os tokens semânticos na versão nova do gopls
          init_options = {
            semanticTokens = true,
          },
          settings = {
            gopls = {
              gofumpt = true,
              codelenses = {
                gc_details = false,
                generate = true,
                regenerate_cgo = true,
                run_govulncheck = true,
                test = true,
                tidy = true,
                upgrade_dependency = true,
                vendor = true,
              },
              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
              analyses = {
                fieldalignment = true,
                nilness = true,
                unusedparams = true,
                unusedwrite = true,
                useany = true,
              },
              usePlaceholders = true,
              completeUnimported = true,
              staticcheck = true,
              directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
            },
          },
        },
      },
      setup = {
        gopls = function(_, opts)
          -- 2. O remendo corrigido com os "nil guards" (as checagens para não dar erro)
          if tonumber(vim.version().minor) >= 11 then
            return -- Se seu nvim for muito novo, ele já lida com isso
          end

          Snacks.util.lsp.on({ name = "gopls" }, function(_, client)
            if client.config and client.config.init_options and client.config.init_options.semanticTokens then
              if not client.server_capabilities.semanticTokensProvider then
                local capabilities = client.config.capabilities
                local textDocument = capabilities and capabilities.textDocument
                local semantic = textDocument and textDocument.semanticTokens

                if semantic then
                  client.server_capabilities.semanticTokensProvider = {
                    full = true,
                    legend = {
                      tokenTypes = semantic.tokenTypes,
                      tokenModifiers = semantic.tokenModifiers,
                    },
                    range = true,
                  }
                end
              end
            end
          end)
        end,
      },
    },
  },
}
