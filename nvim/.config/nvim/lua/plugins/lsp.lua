return {
  -- Mason
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "stylua",
        "prettier",
        "eslint_d",
        "tailwindcss-language-server",
        "typescript-language-server",
        "vtsls",
        "css-lsp",
        "lua-language-server",
      })
    end,
  },

  -- LSP configuration
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = {
        enabled = false,
      },

      servers = {

        -- TypeScript / JavaScript
        vtsls = {
          settings = {
            typescript = {
              inlayHints = {
                parameterNames = {
                  enabled = "literals",
                },
                parameterTypes = {
                  enabled = true,
                },
                variableTypes = {
                  enabled = false,
                },
                propertyDeclarationTypes = {
                  enabled = true,
                },
                functionLikeReturnTypes = {
                  enabled = true,
                },
                enumMemberValues = {
                  enabled = true,
                },
              },
            },
          },
        },

        -- ESLint
        eslint = {
          settings = {
            workingDirectory = {
              mode = "location",
            },

            validate = "on",

            experimental = {
              useFlatConfig = false,
            },

            codeAction = {
              disableRuleComment = {
                enable = true,
                location = "separateLine",
              },

              showDocumentation = {
                enable = true,
              },
            },
          },

          filetypes = {
            "javascript",
            "javascriptreact",
            "typescript",
            "typescriptreact",
            "vue",
          },
        },

        -- CSS
        cssls = {},

        -- Tailwind
        tailwindcss = {
          root_dir = function(...)
            return require("lspconfig.util").root_pattern(
              "tailwind.config.js",
              "tailwind.config.ts",
              "package.json",
              ".git"
            )(...)
          end,
        },

        -- HTML
        html = {},

        -- YAML
        yamlls = {
          settings = {
            yaml = {
              keyOrdering = false,
            },
          },
        },

        -- Lua
        lua_ls = {
          settings = {
            Lua = {
              workspace = {
                checkThirdParty = false,
              },

              completion = {
                callSnippet = "Both",
              },

              diagnostics = {
                disable = {
                  "trailing-space",
                },
              },

              hint = {
                enable = true,
              },

              format = {
                enable = false,
              },
            },
          },
        },
      },
    },
  },
}
