return {
  'olimorris/codecompanion.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
    'ravitemer/mcphub.nvim',
  },
  sources = {
    per_filetype = { codecompanion = { 'codecompanion' } },
  },
  opts = function()
    -- Helper function to read markdown files
    local function read_prompt_file(filename)
      local config_path = vim.fn.stdpath 'config'
      local file_path = config_path .. '/lua/kickstart/prompts/' .. filename .. '.md'
      local file = io.open(file_path, 'r')
      if not file then
        vim.notify('Could not read prompt file: ' .. file_path, vim.log.levels.WARN)
        return 'Prompt file not found'
      end
      local content = file:read '*all'
      file:close()
      return content
    end

    return {
      extensions = {
        mcphub = {
          callback = 'mcphub.extensions.codecompanion',
          opts = {
            make_vars = true,
            make_slash_commands = true,
            show_result_in_chat = true,
          },
        },
      },
      adapters = {
        copilot = function()
          return require('codecompanion.adapters').extend('copilot', {
            schema = {
              model = {
                default = 'claude-sonnet-4',
              },
            },
          })
        end,
      },
      prompt_library = {
        ['Docs Google Style'] = {
          strategy = 'inline',
          description = 'Add docstring in the format of Google Style',
          opts = { is_slash_cmd = true, short_name = 'docs' },
          prompts = {
            {
              role = 'system',
              content = read_prompt_file 'docstrings',
            },
            { role = 'user', content = 'write docstrings to all functions, classes or methods' },
          },
        },
        ['Code Review'] = {
          strategy = 'chat',
          description = 'Review my code please',
          opts = { is_slash_cmd = true, short_name = 'review' },
          prompts = {
            {
              role = 'system',
              content = read_prompt_file 'code-review',
            },
            { role = 'user', content = '#buffer and #lsp' },
          },
        },
      },
    }
  end,
}
