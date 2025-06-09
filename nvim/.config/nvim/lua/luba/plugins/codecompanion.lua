return {
  'olimorris/codecompanion.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
    'ravitemer/mcphub.nvim',
    'j-hui/fidget.nvim',
  },
  -- sources = {
  --   per_filetype = { codecompanion = { 'codecompanion' } },
  -- },
  opts = function()
    -- Helper function to read markdown files
    local function read_prompt_file(filename)
      local config_path = vim.fn.stdpath 'config'
      local file_path = config_path .. '/lua/luba/plugins/prompts/' .. filename .. '.md'
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

      strategies = {
        chat = {
          roles = {
            ---The header name for the LLM's messages
            ---@type string|fun(adapter: CodeCompanion.Adapter): string
            llm = function(adapter)
              return ' AI (' .. adapter.formatted_name .. ')'
            end,

            ---The header name for your messages
            ---@type string
            user = 'Luba',
          },
          keymaps = {
            regenerate = {
              modes = {
                n = '<localleader>r',
              },
            },
            close = {
              modes = {
                n = 'q',
                i = '<C-S-x>',
              },
            },
            clear = {
              modes = {
                n = '<localleader>x',
              },
            },
            yank_code = {
              modes = {
                n = '<localleader>y',
              },
            },
            pin = {
              modes = {
                n = '<localleader>p',
              },
            },
            watch = {
              modes = {
                n = '<localleader>w',
              },
            },
            codeblock = {
              modes = {
                n = '<localleader>c',
              },
            },
          },
        },
      },
    }
  end,
  config = function(_, opts)
    require('codecompanion').setup(opts)

    local progress = require 'fidget.progress'
    local handles = {}
    local group = vim.api.nvim_create_augroup('CodeCompanionFidget', {})

    vim.api.nvim_create_autocmd('User', {
      pattern = 'CodeCompanionRequestStarted',
      group = group,
      callback = function(e)
        handles[e.data.id] = progress.handle.create {
          title = 'CodeCompanion',
          message = 'Thinking...',
          lsp_client = { name = e.data.adapter.formatted_name },
        }
      end,
    })

    vim.api.nvim_create_autocmd('User', {
      pattern = 'CodeCompanionRequestFinished',
      group = group,
      callback = function(e)
        local h = handles[e.data.id]
        if h then
          h.message = e.data.status == 'success' and 'Done' or 'Failed'
          h:finish()
          handles[e.data.id] = nil
        end
      end,
    })
  end,
}
