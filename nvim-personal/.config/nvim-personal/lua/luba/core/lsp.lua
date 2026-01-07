vim.lsp.enable {
  'ruff',
  'ty',
  'lua_ls',
  'jedi_language_server',
  'basedpyright',
}

vim.diagnostic.config {
  -- virtual_lines = true,
  virtual_text = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = 'rounded',
    source = true,
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '󰅚 ',
      [vim.diagnostic.severity.WARN] = '󰀪 ',
      [vim.diagnostic.severity.INFO] = '󰋽 ',
      [vim.diagnostic.severity.HINT] = '󰌶 ',
    },
    numhl = {
      [vim.diagnostic.severity.ERROR] = 'ErrorMsg',
      [vim.diagnostic.severity.WARN] = 'WarningMsg',
    },
  },
}

-- Toggle diagnostics on/off
local diagnostics_enabled = true

local function toggle_diagnostics()
  diagnostics_enabled = not diagnostics_enabled
  if diagnostics_enabled then
    vim.diagnostic.config {
      virtual_text = true,
      underline = true,
      signs = true,
    }
    vim.notify('Diagnostics enabled', vim.log.levels.INFO)
  else
    vim.diagnostic.config {
      virtual_text = false,
      underline = false,
      signs = false,
    }
    vim.notify('Diagnostics disabled', vim.log.levels.INFO)
  end
end

-- Create user command for toggling diagnostics
vim.api.nvim_create_user_command('LspToggleDiagnostics', toggle_diagnostics, {
  desc = 'Toggle LSP diagnostics on/off',
})
