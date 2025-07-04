return {
  { -- Autoformat
    'stevearc/conform.nvim',
    tag = 'v8.0.0',
    enabled = true,
    lazy = false,
    keys = {
      { '<leader>cf', '<cmd>lua require("conform").format()<cr>', desc = '[f]ormat' },
    },
    config = function()
      require('conform').setup {
        notify_on_error = false,
        format_on_save = {
          timeout_ms = 1500,
          lsp_fallback = true,
        },
        formatters_by_ft = {
          lua = { 'mystylua' },
          -- this do not works like on lsp, we need to type like this
          python = { 'ruff_fix', 'ruff_format', 'ruff_organize_imports' },
          quarto = { 'injected' },
          markdown = { 'injected' },
          json = { 'prettier', 'prettierd' },
        },
        formatters = {
          mystylua = {
            command = 'stylua',
            args = { '--indent-type', 'Spaces', '--indent-width', '2', '-' },
          },
        },
      }
      -- Customize the "injected" formatter
      require('conform').formatters.injected = {
        -- Set the options field
        options = {
          -- Set to true to ignore errors
          ignore_errors = false,
          -- Map of treesitter language to file extension
          -- A temporary file name with this extension will be generated during formatting
          -- because some formatters care about the filename.
          lang_to_ext = {
            bash = 'sh',
            c_sharp = 'cs',
            elixir = 'exs',
            javascript = 'js',
            julia = 'jl',
            latex = 'tex',
            markdown = 'md',
            python = 'py',
            ruby = 'rb',
            rust = 'rs',
            teal = 'tl',
            typescript = 'ts',
          },
          -- Map of treesitter language to formatters to use
          -- (defaults to the value from formatters_by_ft)
          lang_to_formatters = {},
        },
      }
    end,
  },
}
