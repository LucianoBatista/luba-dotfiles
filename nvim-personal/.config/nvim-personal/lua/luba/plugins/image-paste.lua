return {
  {
    'evanpurkhiser/image-paste.nvim',
    config = function()
      require('image-paste').setup {
        imgur_client_id = '9e175315e657a12',
        paste_script = [[pngpaste -]],
      }
    end,
    keys = {
      {
        '<leader>p',
        function()
          require('image-paste').paste_image()
        end,
        mode = 'n',
        desc = 'Paste image from clipboard',
      },
    },
  },
}
