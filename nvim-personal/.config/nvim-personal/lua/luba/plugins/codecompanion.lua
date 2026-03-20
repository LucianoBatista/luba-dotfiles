return {
  'olimorris/codecompanion.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
    'ravitemer/mcphub.nvim',
    'j-hui/fidget.nvim',
  },
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
            make_vars = false, -- disabled: mcphub#275 - crashes with codecompanion v19+ (variables → editor_context rename)
            make_slash_commands = true,
            show_result_in_chat = true,
          },
        },
      },
      adapters = {
        acp = {
          claude_code = function()
            -- Read OAuth token from Claude CLI credentials
            local creds_path = vim.fn.expand '~/.claude/.credentials.json'
            local f = io.open(creds_path, 'r')
            local token
            if f then
              local ok, creds = pcall(vim.json.decode, f:read '*all')
              f:close()
              if ok and creds.claudeAiOauth then
                token = creds.claudeAiOauth.accessToken
              end
            end
            return require('codecompanion.adapters').extend('claude_code', {
              env = {
                CLAUDE_CODE_OAUTH_TOKEN = token,
              },
            })
          end,
        },
      },
      prompt_library = {
        ['Docs Google Style'] = {
          interaction = 'inline',
          description = 'Add docstring in the format of Google Style',
          opts = { is_slash_cmd = true, alias = 'docs' },
          prompts = {
            {
              role = 'system',
              content = read_prompt_file 'docstrings',
            },
            { role = 'user', content = 'write docstrings to all functions, classes or methods' },
          },
        },
        ['Code Review'] = {
          interaction = 'chat',
          description = 'Review my code please',
          opts = { is_slash_cmd = true, alias = 'review' },
          prompts = {
            {
              role = 'system',
              content = read_prompt_file 'code-review',
            },
            { role = 'user', content = '#buffer and #lsp' },
          },
        },
      },

      interactions = {
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
          adapter = 'claude_code',
          keymaps = {
            regenerate = {
              modes = {
                n = '<localleader>r',
              },
            },
            stop = {
              modes = {
                n = 'q',
              },
            },
            close = {
              modes = {
                n = '<C-c>',
                i = '<C-c>',
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
            buffer_sync_all = {
              modes = {
                n = '<localleader>p',
              },
            },
            buffer_sync_diff = {
              modes = {
                n = '<localleader>w',
              },
            },
            codeblock = {
              modes = {
                n = '<localleader>c',
              },
            },
            -- ACP tool approval keymaps
            _acp_allow_always = {
              modes = {
                n = 'g1',
              },
            },
            _acp_allow_once = {
              modes = {
                n = 'g2',
              },
            },
            _acp_reject_once = {
              modes = {
                n = 'g3',
              },
            },
            _acp_reject_always = {
              modes = {
                n = 'g4',
              },
            },
          },
        },
        inline = { adapter = 'claude_code' },
        cmd = { adapter = 'claude_code' },
        background = { adapter = 'claude_code' },
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

