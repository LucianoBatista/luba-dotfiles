return {
  root_markers = { 'pyproject.toml', 'ruff.toml', '.ruff.toml', 'setup.py', 'setup.cfg', 'requirements.txt', '.git' },
  init_options = {
    settings = {
      -- Configure Ruff settings here if needed
      logLevel = 'info',
      lint = {
        select = { 'ALL' },
        ignore = { 'D100', 'INP001', 'B008' },
      },
    },
  },
}
