require 'luba.config.options'
require 'luba.core.lazy'
require 'luba.core.lsp'
require 'luba.config.keymaps'
require 'current-theme'
require 'luba.config.autocmds'

-- Auto-configure vim-pencil plugin for writing-focused file types
-- This enables soft word wrapping and other writing enhancements
-- vim.cmd [[
-- augroup pencil
--   autocmd!
--   autocmd FileType markdown,mkd call pencil#init()
--   autocmd FileType text         call pencil#init()
-- augroup END
-- ]]
