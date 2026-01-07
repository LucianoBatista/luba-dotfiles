return {
  {
    'stevearc/oil.nvim',
    opts = {},
    -- Optional dependencies
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('oil').setup {
        default_file_explorer = true,
        columns = { 'icon' },
        keymaps = {
          ['<C-h>'] = false,
          ['<C-c>'] = false,
          ['q'] = 'actions.close',
        },
        delete_to_trash = true,
        view_options = {
          show_hidden = true,
        },
      }
    end,
  },
}
