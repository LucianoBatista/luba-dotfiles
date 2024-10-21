return {
  '3rd/image.nvim',
  config = function()
    require('image').setup {
      integrations = {
        markdown = {
          enabled = true,
          clear_in_insert_mode = false,
          download_remote_images = true,
          only_render_image_at_cursor = false,
          filetypes = { 'markdown', 'vimwiki', 'quarto' }, -- markdown extensions (ie. quarto) can go here
        },
      },
    }
  end,
}
