return {
  root_markers = { 'pyproject.toml', 'ruff.toml', '.ruff.toml', 'setup.py', 'setup.cfg', 'requirements.txt', '.git' },
  init_options = {
    settings = {
      logLevel = 'info',
      lint = {
        select = { 'ALL' },
        ignore = {
          -- Groups: too noisy or redundant
          'ANN',    -- type annotations (let ty/mypy handle)
          'D',      -- docstring rules
          'FBT',    -- boolean trap
          'ERA',    -- commented-out code (false positives)
          'CPY',    -- copyright notices
          'TD',     -- TODO formatting
          'FIX',    -- fixme/todo/hack comments

          -- Formatter conflicts
          'COM812', -- missing trailing comma
          'ISC001', -- implicit string concatenation
          'E501',   -- line too long

          -- Overly pedantic
          'EM101',  -- string literal in exception
          'EM102',  -- f-string in exception
          'TRY003', -- long messages in raise
          'RET504', -- unnecessary assignment before return
          'SIM108', -- use ternary (harms readability)
          'PLR2004',-- magic value comparison
          'PLR0913',-- too many arguments

          -- Original ignores
          'INP001', -- implicit namespace package
          'B008',   -- function call in default argument
        },
      },
    },
  },
}
