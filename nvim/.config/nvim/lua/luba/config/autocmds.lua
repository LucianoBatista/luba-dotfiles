vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
  callback = function(event)
    local function map(keys, func, desc)
      vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
    end
    local function vmap(keys, func, desc)
      vim.keymap.set('v', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
    end

    local client = vim.lsp.get_client_by_id(event.data.client_id)
    assert(client, 'LSP client not found')

    -- Disable Ruff hover in favor of Pyright
    if client.name == 'ruff' then
      client.server_capabilities.hoverProvider = false
    end

    if client.name == 'ty' then
      client.server_capabilities.hoverProvider = false
    end

    ---@diagnostic disable-next-line: inject-field
    client.server_capabilities.document_formatting = true

    map('gS', vim.lsp.buf.document_symbol, '[g]o so [S]ymbols')
    map('gD', vim.lsp.buf.type_definition, '[g]o to type [D]efinition')
    map('gd', vim.lsp.buf.definition, '[g]o to [d]efinition')
    map('K', function()
      vim.lsp.buf.hover { border = 'single', max_height = 25, max_width = 120 }
    end, '[K] hover documentation')
    -- map('K', vim.lsp.buf.hover, '[K] hover documentation')
    map('gh', vim.lsp.buf.signature_help, '[g]o to signature [h]elp')
    map('gI', vim.lsp.buf.implementation, '[g]o to [I]mplementation')
    map('gr', function()
      require('telescope.builtin').lsp_references()
    end, '[g]o to [r]eferences')
    map('[d', function()
      vim.diagnostic.jump { count = 1 }
    end, 'previous [d]iagnostic ')
    map(']d', function()
      vim.diagnostic.jump { count = -1 }
    end, 'next [d]iagnostic ')
    -- map('<leader>ll', vim.lsp.codelens.run, '[l]ens run')
    map('<leader>lR', vim.lsp.buf.rename, '[l]sp [R]ename')
    map('<leader>lf', vim.lsp.buf.format, '[l]sp [f]ormat')
    vmap('<leader>lf', vim.lsp.buf.format, '[l]sp [f]ormat')
    map('<leader>lq', vim.diagnostic.setqflist, '[l]sp diagnostic [q]uickfix')
  end,
})
