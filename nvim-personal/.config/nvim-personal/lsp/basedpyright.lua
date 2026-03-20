return {
  settings = {
    basedpyright = {
      disableOrganizeImports = true, -- ruff handles this
      analysis = {
        typeCheckingMode = 'off', -- ty handles type checking
        autoImportCompletions = true,
      },
    },
  },
}
